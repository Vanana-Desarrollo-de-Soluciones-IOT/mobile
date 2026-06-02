part of 'alerts_cubit.dart';

const _sentinel = Object();

class AlertsState {
  final bool isLoading;
  final String? errorMessage;
  final List<Alert> alerts;
  final List<DailyAlertCount> dailySummary;
  final AlertStatus? selectedStatus;
  final MetricType? selectedMetric;
  final AlertViewMode viewMode;
  final AlertTab tab;

  const AlertsState({
    this.isLoading = false,
    this.errorMessage,
    this.alerts = const [],
    this.dailySummary = const [],
    this.selectedStatus,
    this.selectedMetric,
    this.viewMode = AlertViewMode.list,
    this.tab = AlertTab.active,
  });

  AlertsState copyWith({
    bool? isLoading,
    Object? errorMessage = _sentinel,
    List<Alert>? alerts,
    List<DailyAlertCount>? dailySummary,
    Object? selectedStatus = _sentinel,
    Object? selectedMetric = _sentinel,
    AlertViewMode? viewMode,
    AlertTab? tab,
  }) {
    return AlertsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
      alerts: alerts ?? this.alerts,
      dailySummary: dailySummary ?? this.dailySummary,
      selectedStatus: selectedStatus == _sentinel
          ? this.selectedStatus
          : selectedStatus as AlertStatus?,
      selectedMetric: selectedMetric == _sentinel
          ? this.selectedMetric
          : selectedMetric as MetricType?,
      viewMode: viewMode ?? this.viewMode,
      tab: tab ?? this.tab,
    );
  }
}
