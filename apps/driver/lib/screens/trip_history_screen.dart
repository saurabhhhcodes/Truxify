import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  int _filterIndex = 1;

  List<TripRecord> get _visibleTrips {
    switch (_filterIndex) {
      case 0:
        return tripHistory.take(2).toList();
      case 1:
        return tripHistory.where((trip) => trip.completed).toList();
      default:
        return tripHistory;
    }
  }

  String get _summaryLabel {
    switch (_filterIndex) {
      case 0:
        return 'Recent completed trips';
      case 1:
        return 'Completed trips this month';
      default:
        return 'All trip records';
    }
  }

  Future<void> _showReceiptSheet(TripRecord trip) async {
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
              Text('Trip Receipt', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              _ReceiptLine(label: 'Trip ID', value: trip.tripId),
              _ReceiptLine(label: 'Route', value: trip.route),
              _ReceiptLine(label: 'Date', value: trip.date),
              _ReceiptLine(label: 'Earnings', value: trip.earnings),
              const SizedBox(height: 10),
              StatusPill(
                label: trip.verifiedBadge,
                backgroundColor: TruxifyColors.accentLight,
                foregroundColor: TruxifyColors.accentDark,
              ),
              const SizedBox(height: 16),
              Text('Blockchain hash: ${trip.hash}', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Close', onPressed: () => Navigator.of(context).pop()),
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
        title: const Text('Trip History'),
        backgroundColor: TruxifyColors.secondaryBackground,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            ChipScroller(
              labels: tripHistoryFilters,
              selectedIndex: _filterIndex,
              onSelected: (index) => setState(() => _filterIndex = index),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Row(
                children: [
                  Expanded(child: _MetricColumn(label: 'Total earned', value: '₹1,24,800')),
                  const Separator(),
                  Expanded(child: _MetricColumn(label: 'Total trips', value: '142')),
                  const Separator(),
                  Expanded(child: _MetricColumn(label: 'Avg per trip', value: '₹879')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${_visibleTrips.length} trips shown • $_summaryLabel',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            ..._visibleTrips.map((trip) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(trip.route, style: Theme.of(context).textTheme.titleLarge)),
                          Text(trip.earnings, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: TruxifyColors.accentDark)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(trip.date, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      StatusPill(
                        label: trip.completed ? 'Completed' : 'Cancelled',
                        backgroundColor: trip.completed ? TruxifyColors.accentLight : const Color(0xFFFFE6D4),
                        foregroundColor: trip.completed ? TruxifyColors.accentDark : TruxifyColors.warning,
                      ),
                      const SizedBox(height: 14),
                      PrimaryButton(label: 'View Receipt', onPressed: () => _showReceiptSheet(trip)),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: TruxifyColors.primaryText, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _ReceiptLine extends StatelessWidget {
  const _ReceiptLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
