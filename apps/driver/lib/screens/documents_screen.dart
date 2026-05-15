import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  String? _selectedUploadType;

  Future<void> _showUploadSheet(BuildContext context) async {
    final rootContext = context;
    String selectedType = _selectedUploadType ?? 'RC Book';
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TruxifyColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BottomSheetHandle(),
              const SizedBox(height: 16),
              Text('Upload document type', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              StatefulBuilder(
                builder: (context, setSheetState) {
                  return Column(
                    children: [
                      ...['RC Book', 'Driving Licence', 'Insurance', 'Pollution Certificate'].map(
                        (type) => RadioListTile<String>(
                          value: type,
                          groupValue: selectedType,
                          contentPadding: EdgeInsets.zero,
                          title: Text(type),
                          activeColor: TruxifyColors.accent,
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setSheetState(() => selectedType = value);
                            setState(() => _selectedUploadType = value);
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        label: 'Continue with $selectedType',
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(rootContext).showSnackBar(
                            SnackBar(content: Text('$selectedType selected for upload')),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TruxifyColors.secondaryBackground,
      appBar: AppBar(
        title: const Text('My Documents'),
        backgroundColor: TruxifyColors.secondaryBackground,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            ...documentRecords.map((document) {
              final isWarning = document.statusTone == 'warning';
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(document.title, style: Theme.of(context).textTheme.titleLarge)),
                          StatusPill(
                            label: isWarning ? 'Expiring Soon' : 'Verified',
                            backgroundColor: isWarning ? TruxifyColors.warningLight : TruxifyColors.accentLight,
                            foregroundColor: isWarning ? TruxifyColors.warning : TruxifyColors.accentDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(document.subtitle, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 10),
                      _DocLine(label: document.statusLabel, value: document.hash),
                      _DocLine(label: 'Last verified', value: document.lastVerified),
                      _DocLine(label: 'Valid until', value: document.validUntil),
                      const SizedBox(height: 14),
                      PrimaryButton(
                        label: document.ctaLabel,
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(isWarning ? '${document.title} renewal started' : '${document.title} opened')),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            AppCard(
              onTap: () => _showUploadSheet(context),
              child: DashedBorderBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  child: Column(
                    children: [
                      const Icon(Icons.cloud_upload_outlined, color: TruxifyColors.accent, size: 36),
                      const SizedBox(height: 10),
                      Text('Upload New Document', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: TruxifyColors.accentDark)),
                      const SizedBox(height: 4),
                      Text('RC, Licence, Insurance, Pollution', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocLine extends StatelessWidget {
  const _DocLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Flexible(child: Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
