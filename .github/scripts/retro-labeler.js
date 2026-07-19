'use strict';

const difficultyLabels = ['level:beginner', 'level:intermediate', 'level:advanced', 'level:critical'];
const difficultyLabelsLower = difficultyLabels.map(d => d.toLowerCase());

function checkLabels(currentLabels) {
  const currentLabelsLower = currentLabels.map(l => l.toLowerCase());
  const labelsToAdd = [];

  // Check if gssoc:approved is missing
  if (!currentLabelsLower.includes('gssoc:approved')) {
    labelsToAdd.push('gssoc:approved');
  }

  // Check if a difficulty label is already present
  const hasDifficulty = currentLabelsLower.some(l => {
    if (difficultyLabelsLower.includes(l)) return true;
    for (const diff of difficultyLabelsLower) {
      if (l.includes(diff) || diff.includes(l)) return true;
    }
    return false;
  });

  if (!hasDifficulty) {
    labelsToAdd.push('level:beginner');
  }

  return labelsToAdd;
}

async function run({ github, context, core, dryRun = false }) {
  const { owner, repo } = context.repo;

  core.info(`Starting retrospective PR labeler (dryRun = ${dryRun})...`);

  // Fetch available labels in repo to check if we need to create them
  const repoLabels = await github.paginate(github.rest.issues.listLabelsForRepo, {
    owner,
    repo,
    per_page: 100
  });
  const availableLabelsLower = repoLabels.map(l => l.name.toLowerCase());

  async function ensureLabelExists(name, color, description) {
    const normalized = name.toLowerCase();
    if (availableLabelsLower.includes(normalized)) {
      return;
    }
    if (dryRun) {
      core.info(`Dry run: would ensure label "${name}" exists.`);
      return;
    }
    try {
      core.info(`Creating label "${name}"...`);
      await github.rest.issues.createLabel({
        owner,
        repo,
        name,
        color,
        description
      });
      availableLabelsLower.push(normalized);
    } catch (error) {
      if (error.status !== 422) {
        throw error;
      }
    }
  }

  // Ensure gssoc:approved and level:beginner exist
  await ensureLabelExists('gssoc:approved', '0052cc', 'GSSoC approved contribution');
  await ensureLabelExists('level:beginner', '0e8a16', 'Beginner level task/PR');

  // Fetch all closed pull requests
  core.info('Fetching closed pull requests...');
  const pullRequests = await github.paginate(github.rest.pulls.list, {
    owner,
    repo,
    state: 'closed',
    per_page: 100
  });

  core.info(`Found ${pullRequests.length} closed pull requests. Processing...`);

  let updatedCount = 0;
  for (const pr of pullRequests) {
    // Skip if not merged (closed without merge)
    if (!pr.merged_at) {
      core.info(`PR #${pr.number}: Skipped because it was closed without merging.`);
      continue;
    }

    // Skip if authored by dependabot
    const author = pr.user ? pr.user.login.toLowerCase() : '';
    if (author.includes('dependabot')) {
      core.info(`PR #${pr.number}: Skipped because it was created by Dependabot.`);
      continue;
    }

    const currentLabels = (pr.labels || []).map(l => typeof l === 'string' ? l : l.name);
    const labelsToAdd = checkLabels(currentLabels);

    if (labelsToAdd.length > 0) {
      updatedCount++;
      if (dryRun) {
        core.info(`[Dry Run] PR #${pr.number} (${pr.title}): Would add labels: ${labelsToAdd.join(', ')}`);
      } else {
        core.info(`PR #${pr.number} (${pr.title}): Adding labels: ${labelsToAdd.join(', ')}`);
        try {
          await github.rest.issues.addLabels({
            owner,
            repo,
            issue_number: pr.number,
            labels: labelsToAdd
          });
        } catch (error) {
          core.error(`Failed to add labels to PR #${pr.number}: ${error.message}`);
        }
      }
    }
  }

  core.info(`Finished processing. Total updated/to-be-updated PRs: ${updatedCount}/${pullRequests.length}`);
  return updatedCount;
}

module.exports = {
  checkLabels,
  run
};
