'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { checkLabels, run } = require('./retro-labeler');

test('checkLabels returns both gssoc:approved and level:beginner if PR has no labels', () => {
  const result = checkLabels([]);
  assert.deepEqual(result, ['gssoc:approved', 'level:beginner']);
});

test('checkLabels returns level:beginner if PR already has gssoc:approved but no difficulty label', () => {
  const result = checkLabels(['gssoc:approved']);
  assert.deepEqual(result, ['level:beginner']);
});

test('checkLabels returns gssoc:approved if PR already has difficulty label (exact casing)', () => {
  const result = checkLabels(['level:intermediate']);
  assert.deepEqual(result, ['gssoc:approved']);
});

test('checkLabels returns gssoc:approved if PR already has difficulty label (unprefixed)', () => {
  const result = checkLabels(['Intermediate']);
  assert.deepEqual(result, ['gssoc:approved']);
});

test('checkLabels returns empty array if PR has both gssoc:approved and difficulty label', () => {
  const result = checkLabels(['gssoc:approved', 'level:critical']);
  assert.deepEqual(result, []);
});

test('run function paginates, checks, and adds labels when dryRun is false', async () => {
  let createdLabels = [];
  let addedLabelsToPRs = {};

  const mockGithub = {
    paginate: async (fn, params) => {
      if (fn === mockGithub.rest.issues.listLabelsForRepo) {
        return [{ name: 'some-label' }];
      }
      if (fn === mockGithub.rest.pulls.list) {
        return [
          { number: 101, title: 'First PR', labels: [], merged_at: '2026-07-19T22:00:00Z', user: { login: 'someuser' } },
          { number: 102, title: 'Second PR', labels: [{ name: 'gssoc:approved' }], merged_at: '2026-07-19T22:00:00Z', user: { login: 'someuser' } },
          { number: 103, title: 'Third PR', labels: [{ name: 'level:intermediate' }], merged_at: '2026-07-19T22:00:00Z', user: { login: 'someuser' } },
          { number: 104, title: 'Fourth PR', labels: [{ name: 'gssoc:approved' }, { name: 'level:critical' }], merged_at: '2026-07-19T22:00:00Z', user: { login: 'someuser' } }
        ];
      }
      return [];
    },
    rest: {
      issues: {
        listLabelsForRepo: () => {},
        createLabel: async ({ name }) => {
          createdLabels.push(name);
        },
        addLabels: async ({ issue_number, labels }) => {
          addedLabelsToPRs[issue_number] = labels;
        }
      },
      pulls: {
        list: () => {}
      }
    }
  };

  const mockContext = {
    repo: { owner: 'test-owner', repo: 'test-repo' }
  };

  const mockCore = {
    info: () => {},
    error: () => {}
  };

  const updatedCount = await run({
    github: mockGithub,
    context: mockContext,
    core: mockCore,
    dryRun: false
  });

  // Verify that required labels were ensured
  assert.equal(createdLabels.includes('gssoc:approved'), true);
  assert.equal(createdLabels.includes('level:beginner'), true);

  // Verify updated count (3 PRs should need updates: 101, 102, 103)
  assert.equal(updatedCount, 3);

  // Verify exact labels added to each PR
  assert.deepEqual(addedLabelsToPRs[101], ['gssoc:approved', 'level:beginner']);
  assert.deepEqual(addedLabelsToPRs[102], ['level:beginner']);
  assert.deepEqual(addedLabelsToPRs[103], ['gssoc:approved']);
  assert.equal(addedLabelsToPRs[104], undefined);
});

test('run function skips unmerged closed PRs and Dependabot PRs', async () => {
  let addedLabelsToPRs = {};

  const mockGithub = {
    paginate: async (fn, params) => {
      if (fn === mockGithub.rest.issues.listLabelsForRepo) {
        return [{ name: 'gssoc:approved' }, { name: 'level:beginner' }];
      }
      if (fn === mockGithub.rest.pulls.list) {
        return [
          { number: 301, title: 'Unmerged PR', labels: [], merged_at: null, user: { login: 'someuser' } },
          { number: 302, title: 'Dependabot PR', labels: [], merged_at: '2026-07-19T22:00:00Z', user: { login: 'dependabot[bot]' } },
          { number: 303, title: 'Merged human PR', labels: [], merged_at: '2026-07-19T22:00:00Z', user: { login: 'someuser' } }
        ];
      }
      return [];
    },
    rest: {
      issues: {
        listLabelsForRepo: () => {},
        createLabel: async () => {},
        addLabels: async ({ issue_number, labels }) => {
          addedLabelsToPRs[issue_number] = labels;
        }
      },
      pulls: {
        list: () => {}
      }
    }
  };

  const mockContext = {
    repo: { owner: 'test-owner', repo: 'test-repo' }
  };

  const mockCore = {
    info: () => {},
    error: () => {}
  };

  const updatedCount = await run({
    github: mockGithub,
    context: mockContext,
    core: mockCore,
    dryRun: false
  });

  // Verify that only the merged human PR was updated
  assert.equal(updatedCount, 1);
  assert.equal(addedLabelsToPRs[301], undefined);
  assert.equal(addedLabelsToPRs[302], undefined);
  assert.deepEqual(addedLabelsToPRs[303], ['gssoc:approved', 'level:beginner']);
});

test('run function does not add labels or create labels when dryRun is true', async () => {
  let createdLabels = [];
  let addedLabelsToPRs = {};

  const mockGithub = {
    paginate: async (fn, params) => {
      if (fn === mockGithub.rest.issues.listLabelsForRepo) {
        return [];
      }
      if (fn === mockGithub.rest.pulls.list) {
        return [
          { number: 201, title: 'Some PR', labels: [], merged_at: '2026-07-19T22:00:00Z', user: { login: 'someuser' } }
        ];
      }
      return [];
    },
    rest: {
      issues: {
        listLabelsForRepo: () => {},
        createLabel: async ({ name }) => {
          createdLabels.push(name);
        },
        addLabels: async ({ issue_number, labels }) => {
          addedLabelsToPRs[issue_number] = labels;
        }
      },
      pulls: {
        list: () => {}
      }
    }
  };

  const mockContext = {
    repo: { owner: 'test-owner', repo: 'test-repo' }
  };

  const mockCore = {
    info: () => {},
    error: () => {}
  };

  const updatedCount = await run({
    github: mockGithub,
    context: mockContext,
    core: mockCore,
    dryRun: true
  });

  assert.equal(updatedCount, 1);
  assert.equal(createdLabels.length, 0);
  assert.deepEqual(addedLabelsToPRs, {});
});
