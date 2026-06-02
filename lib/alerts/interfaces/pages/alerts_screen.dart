import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/alerts/domain/model/valueobjects/alert.valueobject.dart';
import 'package:mobile/alerts/domain/model/valueobjects/alert_status.valueobject.dart';
import 'package:mobile/alerts/domain/model/valueobjects/metric_type.valueobject.dart';
import 'package:mobile/alerts/interfaces/pages/alerts_cubit.dart';
import 'package:mobile/alerts/interfaces/widgets/alert_daily_chart.dart';
import 'package:mobile/alerts/interfaces/widgets/alert_filters.dart';
import 'package:mobile/alerts/interfaces/widgets/alert_list.dart';
import 'package:mobile/alerts/interfaces/widgets/alert_table.dart';
import 'package:mobile/shared/interfaces/widgets/widgets.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AlertsCubit>().loadAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ClairAppBar(),
      body: SafeArea(
        child: BlocBuilder<AlertsCubit, AlertsState>(
          builder: (context, state) {
            final filteredAlerts = _applyFilters(
              state.alerts,
              status: state.selectedStatus,
              metric: state.selectedMetric,
            );
            final activeAlerts = filteredAlerts
                .where((alert) => alert.status != AlertStatus.resolved)
                .toList(growable: false);
            final historyAlerts = filteredAlerts
                .where((alert) => alert.status == AlertStatus.resolved)
                .toList(growable: false);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alerts',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  AlertDailyChart(data: state.dailySummary),
                  const SizedBox(height: 16),
                  AlertFilters(
                    selectedStatus: state.selectedStatus,
                    selectedMetric: state.selectedMetric,
                    onStatusChanged: context.read<AlertsCubit>().setStatusFilter,
                    onMetricChanged: context.read<AlertsCubit>().setMetricFilter,
                  ),
                  const SizedBox(height: 16),
                  _AlertsTabBar(
                    tab: state.tab,
                    onChanged: context.read<AlertsCubit>().setTab,
                  ),
                  const SizedBox(height: 12),
                  if (state.tab == AlertTab.active)
                    AlertTable(
                      alerts: activeAlerts,
                      loading: state.isLoading,
                    )
                  else
                    AlertList(
                      alerts: historyAlerts,
                      loading: state.isLoading,
                      error: state.errorMessage ?? '',
                      viewMode: state.viewMode,
                      onViewModeChanged: context.read<AlertsCubit>().setViewMode,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Alert> _applyFilters(
    List<Alert> alerts, {
    required AlertStatus? status,
    required MetricType? metric,
  }) {
    return alerts.where((alert) {
      final matchesStatus = status == null || alert.status == status;
      final matchesMetric = metric == null || alert.metric == metric;
      return matchesStatus && matchesMetric;
    }).toList(growable: false);
  }
}

class _AlertsTabBar extends StatelessWidget {
  final AlertTab tab;
  final ValueChanged<AlertTab> onChanged;

  const _AlertsTabBar({
    required this.tab,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _TabButton(
                label: 'Active Alerts',
                isActive: tab == AlertTab.active,
                onTap: () => onChanged(AlertTab.active),
              ),
            ),
            Expanded(
              child: _TabButton(
                label: 'History',
                isActive: tab == AlertTab.history,
                onTap: () => onChanged(AlertTab.history),
              ),
            ),
          ],
        ),
        Container(
          height: 1,
          color: const Color(0xFF2A2A2A),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isActive ? Colors.white : const Color(0xFF9CA3AF);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 2,
              width: 120,
              color: isActive ? Colors.white : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
