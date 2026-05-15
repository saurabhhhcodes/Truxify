import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onViewActiveTrip});

  final VoidCallback onViewActiveTrip;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _online = true;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        children: [
          Row(
            children: [
              const TruxifyLogo(size: 24),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _online = !_online),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: _online ? TruxifyColors.accentLight : TruxifyColors.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _online ? TruxifyColors.accent : TruxifyColors.tertiaryText,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _online ? driverOnlineLabel : driverOfflineLabel,
                        style: TextStyle(
                          color: _online ? TruxifyColors.white : TruxifyColors.secondaryText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Good morning, $driverName 👋',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text(date, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          AppCard(
            color: TruxifyColors.accent,
            elevation: 6,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Earnings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: TruxifyColors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  '₹3,200',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: TruxifyColors.white,
                        fontSize: 32,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'This week: ₹18,400',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: TruxifyColors.white),
                      ),
                    ),
                    Text(
                      'Trips today: 3',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: TruxifyColors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              StatCard(label: 'Rating', value: '4.8', icon: Icons.star_rounded),
              SizedBox(width: 10),
              StatCard(label: 'Total Trips', value: '142', icon: Icons.route_rounded),
              SizedBox(width: 10),
              StatCard(label: 'Completion', value: '97%', icon: Icons.verified_rounded),
            ],
          ),
          const SizedBox(height: 18),
          AppCard(
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: 'Current Trip',
                  subtitle: 'Your live lane to Jaipur is active.',
                  trailing: const StatusPill(
                    label: 'Active',
                    backgroundColor: TruxifyColors.accentLight,
                    foregroundColor: TruxifyColors.accentDark,
                  ),
                ),
                const SizedBox(height: 14),
                _DetailLine(label: 'Route', value: 'Surat → Jaipur'),
                _DetailLine(label: 'Customer', value: 'Karthik Murugan'),
                _DetailLine(label: 'Stop', value: '2 of 3'),
                _DetailLine(label: 'ETA', value: '4:30 PM today'),
                _DetailLine(label: 'Earnings', value: '₹6,800'),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'View Active Trip',
                  onPressed: widget.onViewActiveTrip,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionHeader(
            title: 'High Demand Near You',
            subtitle: 'Quick return loads based on your Jaipur route.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 164,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: demandRoutes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final demand = demandRoutes[index];
                return SizedBox(
                  width: 250,
                  child: AppCard(
                    elevation: 1,
                    color: TruxifyColors.accentLight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(demand.route, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          '${demand.note} ${demand.demand}',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: TruxifyColors.accentDark,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const Spacer(),
                        Text(
                          'Est. earnings: ${demand.estimatedEarnings}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: TruxifyColors.accentDark,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

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
