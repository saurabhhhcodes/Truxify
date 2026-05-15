import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class LoadsScreen extends StatefulWidget {
  const LoadsScreen({
    super.key,
    required this.initialSection,
    required this.onSectionChanged,
    required this.onOpenLoadDetail,
  });

  final LoadsSection initialSection;
  final ValueChanged<LoadsSection> onSectionChanged;
  final ValueChanged<LoadOffer> onOpenLoadDetail;

  @override
  State<LoadsScreen> createState() => _LoadsScreenState();
}

class _LoadsScreenState extends State<LoadsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _activeFilter = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialSection == LoadsSection.available ? 0 : 1,
    );
    _tabController.addListener(_handleTabChanged);
  }

  @override
  void didUpdateWidget(covariant LoadsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextIndex = widget.initialSection == LoadsSection.available ? 0 : 1;
    if (_tabController.index != nextIndex) {
      _tabController.index = nextIndex;
    }
  }

  void _handleTabChanged() {
    if (_tabController.indexIsChanging) {
      return;
    }
    widget.onSectionChanged(
      _tabController.index == 0 ? LoadsSection.available : LoadsSection.enRoute,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showAcceptSheet(BuildContext context, LoadOffer load) async {
    final result = await showModalBottomSheet<bool>(
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
              Text('Load summary', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(load.route, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              _SummaryRow(label: 'Freight value', value: load.freightValue),
              _SummaryRow(label: 'Fuel cost', value: '-${load.fuelCost}'),
              _SummaryRow(label: 'Toll cost', value: '-${load.tollCost}'),
              const Divider(height: 28),
              _SummaryRow(
                label: 'Estimated profit',
                value: load.estimatedProfit,
                valueColor: TruxifyColors.accentDark,
                bold: true,
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Confirm & Accept',
                onPressed: () => Navigator.of(context).pop(true),
              ),
              TextActionButton(
                label: 'Cancel',
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        );
      },
    );
    if (result == true && mounted) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Load accepted successfully')),
      );
    }
  }

  Future<void> _showAddTripSheet(BuildContext context, LoadOffer load) async {
    final result = await showModalBottomSheet<bool>(
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
              Text('New route preview', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(load.route, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              _SummaryRow(label: 'Extra distance', value: '+${load.extraDistance} km'),
              _SummaryRow(label: 'Extra earnings', value: load.extraEarnings),
              _SummaryRow(label: 'Updated total earnings', value: load.updatedTotalEarnings, bold: true, valueColor: TruxifyColors.accentDark),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Confirm Add',
                onPressed: () => Navigator.of(context).pop(true),
              ),
              TextActionButton(label: 'Cancel', onPressed: () => Navigator.of(context).pop(false)),
            ],
          ),
        );
      },
    );
    if (result == true && mounted) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Load added to trip')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
          children: [
            SectionHeader(
              title: 'Loads',
              subtitle: 'Choose high-margin freight or route-matched return loads.',
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: TruxifyColors.secondaryBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: TruxifyColors.border),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: TruxifyColors.accentDark,
                unselectedLabelColor: TruxifyColors.secondaryText,
                indicatorColor: TruxifyColors.accent,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Available'),
                  Tab(text: 'En-Route'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_tabController.index == 0) ...[
              ChipScroller(
                labels: availableFilterChips,
                selectedIndex: _activeFilter,
                onSelected: (index) => setState(() => _activeFilter = index),
              ),
              const SizedBox(height: 16),
              ...availableLoads.map((load) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _LoadCard(
                    load: load,
                    onTap: () => widget.onOpenLoadDetail(load),
                    actionLabel: 'Accept Load',
                    onActionPressed: () => _showAcceptSheet(context, load),
                    showBestBadge: load.bestProfit,
                    bodyChildren: [
                      _LoadInfo(label: 'Customer', value: load.customer),
                      _LoadInfo(label: 'Goods', value: '${load.goods} | ${load.weight}'),
                      _LoadInfo(label: 'Pickup', value: load.pickup),
                      _LoadInfo(label: 'Distance from you', value: load.distanceFromDriver),
                      _LoadInfo(label: 'Estimated profit', value: load.estimatedProfit, bold: true, valueColor: TruxifyColors.accentDark),
                      const SizedBox(height: 8),
                      Text(load.truckFillLabel, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      StackedCapacityBar(thisLoad: load.capacityUsed, otherLoads: 0.0),
                      const SizedBox(height: 8),
                      _LoadInfo(label: 'Sharing truck with', value: load.sharingTruckWith),
                    ],
                  ),
                );
              }),
            ] else ...[
              AppCard(
                color: TruxifyColors.accentLight,
                child: Text(
                  'Loads you can pick up along your current route to Jaipur',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: TruxifyColors.accentDark),
                ),
              ),
              const SizedBox(height: 16),
              ...enRouteLoads.map((load) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _LoadCard(
                    load: load,
                    onTap: () => widget.onOpenLoadDetail(load),
                    actionLabel: 'Add to Trip',
                    onActionPressed: () => _showAddTripSheet(context, load),
                    bodyChildren: [
                      _LoadInfo(label: 'Customer', value: load.customer),
                      _LoadInfo(label: 'Goods', value: '${load.goods} | ${load.weight}'),
                      _LoadInfo(label: 'Pickup', value: load.pickup),
                      _LoadInfo(label: 'Extra earnings', value: '+${load.extraEarnings}', bold: true, valueColor: TruxifyColors.accentDark),
                      _LoadInfo(label: 'Space available', value: load.spaceAvailable),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class _LoadCard extends StatelessWidget {
  const _LoadCard({
    required this.load,
    required this.onTap,
    required this.actionLabel,
    required this.onActionPressed,
    required this.bodyChildren,
    this.showBestBadge = false,
  });

  final LoadOffer load;
  final VoidCallback onTap;
  final String actionLabel;
  final VoidCallback onActionPressed;
  final List<Widget> bodyChildren;
  final bool showBestBadge;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  load.route,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (showBestBadge)
                const StatusPill(
                  label: 'Best Profit',
                  backgroundColor: TruxifyColors.accentLight,
                  foregroundColor: TruxifyColors.accentDark,
                ),
            ],
          ),
          if (load.routeSubtitle.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(load.routeSubtitle, style: Theme.of(context).textTheme.bodyMedium),
          ],
          const SizedBox(height: 14),
          ...bodyChildren,
          const SizedBox(height: 16),
          PrimaryButton(label: actionLabel, onPressed: onActionPressed),
        ],
      ),
    );
  }
}

class _LoadInfo extends StatelessWidget {
  const _LoadInfo({required this.label, required this.value, this.valueColor, this.bold = false});

  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: valueColor ?? TruxifyColors.primaryText,
                    fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.valueColor, this.bold = false});

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
