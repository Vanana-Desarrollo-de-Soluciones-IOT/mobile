import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/alerts/domain/model/queries/get_alerts.query.dart';
import 'package:mobile/alerts/domain/model/queries/get_alerts_daily_summary.query.dart';
import 'package:mobile/alerts/domain/model/valueobjects/alert.valueobject.dart';
import 'package:mobile/alerts/domain/model/valueobjects/alert_status.valueobject.dart';
import 'package:mobile/alerts/domain/model/valueobjects/daily_alert_count.valueobject.dart';
import 'package:mobile/alerts/domain/model/valueobjects/metric_type.valueobject.dart';
import 'package:mobile/alerts/domain/services/alerts.query-service.dart';
import 'package:mobile/alerts/interfaces/widgets/alert_list.dart';

part 'alerts_state.dart';

enum AlertTab {
  active,
  history,
}

class AlertsCubit extends Cubit<AlertsState> {
  final AlertsQueryService _queryService;

  AlertsCubit(this._queryService) : super(const AlertsState());

  Future<void> loadAlerts({int days = 30, int size = 50}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final alertsResult = await _queryService.handleGetAlerts(
        GetAlertsQuery(size: size),
      );
      final summaryResult = await _queryService.handleGetDailySummary(
        GetAlertDailySummaryQuery(days: days),
      );

      String? errorMessage;
      var alerts = state.alerts;
      var dailySummary = state.dailySummary;

      alertsResult.fold(
        (failure) => errorMessage = failure.message,
        (page) => alerts = page.content,
      );
      summaryResult.fold(
        (failure) => errorMessage ??= failure.message,
        (summary) => dailySummary = summary,
      );

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: errorMessage,
          alerts: alerts,
          dailySummary: dailySummary,
        ),
      );
    } on ArgumentError catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.message as String?,
        ),
      );
    }
  }

  void setStatusFilter(AlertStatus? status) {
    emit(state.copyWith(selectedStatus: status));
  }

  void setMetricFilter(MetricType? metric) {
    emit(state.copyWith(selectedMetric: metric));
  }

  void setViewMode(AlertViewMode viewMode) {
    emit(state.copyWith(viewMode: viewMode));
  }

  void setTab(AlertTab tab) {
    emit(state.copyWith(tab: tab));
  }
}
