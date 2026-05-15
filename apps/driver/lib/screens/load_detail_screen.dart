import 'package:flutter/material.dart';

import '../models/app_models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class LoadDetailScreen extends StatelessWidget {
  const LoadDetailScreen({super.key, required this.load});

  final LoadOffer load;

  Future<void> _showAcceptSheet(BuildContext context) async {
    final accepted = await showModalBottomSheet<bool>(
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
              Text('Accept this load?', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Text(load.route, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 14),
              _SheetLine(label: 'Freight value', value: load.freightValue),
              _SheetLine(label: 'Fuel cost', value: '-${load.fuelCost}'),
              _SheetLine(label: 'Toll cost', value: '-${load.tollCost}'),
              const Divider(height: 28),
              _SheetLine(label: 'Net profit', value: load.netProfit, bold: true, valueColor: TruxifyColors.accentDark),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Confirm & Accept',
                onPressed: () => Navigator.of(context).pop(true),
              ),
              TextActionButton(label: 'Cancel', onPressed: () => Navigator.of(context).pop(false)),
            ],
          ),
        );
      },
    );
    if (accepted == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Load accepted successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TruxifyColors.secondaryBackground,
      appBar: AppBar(
        title: const Text('Load Details'),
        backgroundColor: TruxifyColors.secondaryBackground,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(load.route, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 10),
                  _SheetLine(label: 'Pickup', value: load.pickup),
                  _SheetLine(label: 'Distance', value: load.routeDistance),
                  _SheetLine(label: 'Est. duration', value: load.routeDuration),
                ],
              ),
            ),
            const SizedBox(height: 14),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: 'Customer', subtitle: 'Driver-side verified market demand'),
                  const SizedBox(height: 10),
                  _SheetLine(label: 'Customer', value: load.customer),
                  _SheetLine(label: 'Company', value: load.company),
                  _SheetLine(label: 'Rating', value: '⭐ 4.9 (28 orders)'),
                ],
              ),
            ),
            const SizedBox(height: 14),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: 'Goods details'),
                  const SizedBox(height: 10),
                  _SheetLine(label: 'Type', value: load.goods),
                  _SheetLine(label: 'Weight', value: load.weight),
                  _SheetLine(label: 'Dimensions', value: load.dimensions),
                  _SheetLine(label: 'Stackable', value: load.stackable),
                  _SheetLine(label: 'Fragile', value: load.fragile),
                  _SheetLine(label: 'Special', value: load.specialHandling),
                ],
              ),
            ),
            const SizedBox(height: 14),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: 'Earnings breakdown'),
                  const SizedBox(height: 10),
                  _SheetLine(label: 'Freight value', value: load.freightValue),
                  _SheetLine(label: 'Fuel cost', value: '-${load.fuelCost}'),
                  _SheetLine(label: 'Toll cost', value: '-${load.tollCost}'),
                  _SheetLine(label: 'Net profit', value: load.netProfit, bold: true, valueColor: TruxifyColors.accentDark),
                ],
              ),
            ),
            const SizedBox(height: 14),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: 'Truck capacity'),
                  const SizedBox(height: 10),
                  _SheetLine(label: 'Your truck', value: '10 tonnes total'),
                  _SheetLine(label: 'This load', value: '3 tonnes (30%)'),
                  _SheetLine(label: 'Other loads', value: '3 tonnes (30%)'),
                  _SheetLine(label: 'Remaining', value: '4 tonnes (40%)'),
                  const SizedBox(height: 10),
                  StackedCapacityBar(thisLoad: 0.3, otherLoads: 0.3),
                ],
              ),
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              label: 'Accept This Load',
              onPressed: () => _showAcceptSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetLine extends StatelessWidget {
  const _SheetLine({required this.label, required this.value, this.valueColor, this.bold = false});

  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: valueColor ?? TruxifyColors.primaryText,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
