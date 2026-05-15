import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ActiveTripScreen extends StatefulWidget {
  const ActiveTripScreen({super.key, required this.onViewLoads});

  final VoidCallback onViewLoads;

  @override
  State<ActiveTripScreen> createState() => _ActiveTripScreenState();
}

class _ActiveTripScreenState extends State<ActiveTripScreen> {
  final List<TripStop> _stops = List<TripStop>.from(activeTripStops);
  int _activeStopIndex = 1;
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());
  bool _deliveryComplete = false;

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _confirmDelivery() async {
    final code = _otpControllers.map((controller) => controller.text).join();
    if (code != '2580') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter customer OTP 2580')),
      );
      return;
    }
    setState(() {
      _deliveryComplete = true;
      _stops[1] = const TripStop(
        customer: 'Raj Textiles',
        route: 'Vadodara → Jaipur',
        goods: 'Electronics, 2 tonnes',
        statusLabel: 'Delivered ✅',
        earningsLabel: '₹2,800 released',
        tripPath: 'Delivered',
        dropLocation: 'Jaipur, Rajasthan',
        tonnes: '2 tonnes',
        isCurrent: false,
        isCompleted: true,
      );
      _activeStopIndex = 2;
    });
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Delivery Confirmed! ₹2,800 released to your wallet')),
    );
  }

  Future<void> _showCallSheet() async {
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
              Text('Call customer', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text('Karthik Murugan · +91 90000 11111'),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Mock Call', onPressed: () => Navigator.of(context).pop()),
              TextActionButton(label: 'Close', onPressed: () => Navigator.of(context).pop()),
            ],
          ),
        );
      },
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Calling customer...')));
    }
  }

  Future<void> _showIssueSheet() async {
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
              Text('Report issue', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              ...['Breakdown', 'Accident', 'Wrong Address', 'Other'].map(
                (item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(content: Text('$item issue selected')),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStop = _stops[_activeStopIndex];
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Active Trip', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 4),
                    Text(activeTripId, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LivePulseDot(),
                  const SizedBox(width: 8),
                  Text('Live', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: TruxifyColors.accentDark)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppCard(
            color: TruxifyColors.accent,
            elevation: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Stop', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: TruxifyColors.white)),
                const SizedBox(height: 10),
                Text('Stop ${_activeStopIndex + 1} of 3', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: TruxifyColors.white)),
                const SizedBox(height: 12),
                _WhiteLine(label: 'Customer', value: currentStop.customer),
                _WhiteLine(label: 'Drop', value: currentStop.dropLocation),
                _WhiteLine(label: 'Goods', value: currentStop.goods),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening Google Maps...')),
              );
            },
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: TruxifyColors.accentLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.map_outlined, color: TruxifyColors.accentDark),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Open Route in Google Maps', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text('3 stops pre-loaded', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: TruxifyColors.secondaryText),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionHeader(title: 'Trip Stops'),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              children: [
                _StopTile(stop: _stops[0]),
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 10),
                _StopTile(stop: _stops[1]),
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 10),
                _StopTile(stop: _stops[2]),
              ],
            ),
          ),
          const SizedBox(height: 18),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: 'Confirm Delivery', subtitle: 'Ask customer for OTP'),
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  child: _deliveryComplete
                      ? Container(
                          key: const ValueKey('success'),
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: TruxifyColors.accentLight,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Delivery Confirmed!', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: TruxifyColors.accentDark)),
                              const SizedBox(height: 6),
                              Text('₹2,800 released to your wallet', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: TruxifyColors.accentDark)),
                            ],
                          ),
                        )
                      : Column(
                          key: const ValueKey('input'),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OtpInputRow(controllers: _otpControllers, focusNodes: _otpFocusNodes),
                            const SizedBox(height: 16),
                            PrimaryButton(
                              label: 'Confirm Delivery',
                              onPressed: _confirmDelivery,
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: 'Earnings Tracker'),
                const SizedBox(height: 10),
                _MoneyRow(label: 'Confirmed', value: activeTripConfirmed),
                _MoneyRow(label: 'Pending', value: activeTripPending),
                _MoneyRow(label: 'Total trip', value: activeTripTotal, bold: true),
                const SizedBox(height: 10),
                StackedCapacityBar(thisLoad: 0.31, otherLoads: 0.39),
              ],
            ),
          ),
          const SizedBox(height: 18),
          AppCard(
            color: TruxifyColors.accentLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('2 loads available near Jaipur', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: TruxifyColors.accentDark)),
                const SizedBox(height: 4),
                Text('Earn extra ₹3,500 on return', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: TruxifyColors.accentDark)),
                const SizedBox(height: 14),
                PrimaryButton(label: 'View Loads', onPressed: widget.onViewLoads),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: AppCard(
                  onTap: _showCallSheet,
                  child: Column(
                    children: [
                      Icon(Icons.call_rounded, color: TruxifyColors.accentDark),
                      const SizedBox(height: 8),
                      Text('Call Customer', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppCard(
                  onTap: _showIssueSheet,
                  child: Column(
                    children: [
                      const Icon(Icons.report_outlined, color: TruxifyColors.error),
                      const SizedBox(height: 8),
                      Text('Report Issue', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: TruxifyColors.error)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WhiteLine extends StatelessWidget {
  const _WhiteLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: TruxifyColors.white.withOpacity(0.85)),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: TruxifyColors.white, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _MoneyRow extends StatelessWidget {
  const _MoneyRow({required this.label, required this.value, this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: TruxifyColors.primaryText,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _StopTile extends StatelessWidget {
  const _StopTile({required this.stop});

  final TripStop stop;

  @override
  Widget build(BuildContext context) {
    Widget leading;
    if (stop.isCompleted) {
        leading = Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(color: TruxifyColors.accentDark, shape: BoxShape.circle),
        child: const Icon(Icons.check_rounded, color: TruxifyColors.white, size: 18),
      );
    } else if (stop.isCurrent) {
      leading = const LivePulseDot(size: 12);
    } else {
      leading = const StatusDot(color: TruxifyColors.border, size: 12);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 28, child: Center(child: leading)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(stop.customer, style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Text(stop.earningsLabel, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 4),
              Text(stop.route, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(stop.goods, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(stop.statusLabel, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: stop.isCurrent ? TruxifyColors.accentDark : TruxifyColors.secondaryText)),
            ],
          ),
        ),
      ],
    );
  }
}
