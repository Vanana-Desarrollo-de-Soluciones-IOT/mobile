import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/alerts/domain/model/valueobjects/alert.valueobject.dart';
import 'package:mobile/alerts/domain/model/valueobjects/alert_status.valueobject.dart';
import 'package:mobile/alerts/domain/model/valueobjects/daily_alert_count.valueobject.dart';
import 'package:mobile/alerts/domain/model/valueobjects/metric_type.valueobject.dart';
import 'package:mobile/alerts/domain/services/alerts.query-service.dart';
import 'package:mobile/devices/domain/model/queries/get_spaces_by_organization.query.dart';
import 'package:mobile/devices/domain/model/queries/get_user_organizations.query.dart';
import 'package:mobile/devices/domain/model/valueobjects/organization_id.valueobject.dart';
import 'package:mobile/devices/domain/services/organizations.query-service.dart';
import 'package:mobile/devices/domain/services/spaces.query-service.dart';

import '../../domain/model/queries/get_alerts_by_space.query.dart';
import '../widgets/alert_list.dart';

part 'alerts_state.dart';

enum AlertTab {
  active,
  history,
}

class AlertsCubit extends Cubit<AlertsState> {
  final AlertsQueryService _queryService;
  final OrganizationsQueryService _organizations;
  final SpacesQueryService _spaces;

  AlertsCubit(
      this._queryService,
      this._organizations,
      this._spaces,
      ) : super(const AlertsState());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final orgsResult = await _organizations.handleGetUserOrganizations(
      const GetUserOrganizationsQuery(),
    );

    await orgsResult.fold(
          (failure) async {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
          (orgs) async {
        if (orgs.isEmpty) {
          emit(state.copyWith(isLoading: false));
          return;
        }

        final orgId = orgs.first.id;

        final spacesResult = await _spaces.handleGetSpacesByOrganization(
          GetSpacesByOrganizationQuery(organizationId: OrganizationId(orgId)),
        );

        await spacesResult.fold(
              (failure) async {
            emit(state.copyWith(isLoading: false, errorMessage: failure.message));
          },
              (spaceList) async {
            if (spaceList.isEmpty) {
              emit(state.copyWith(isLoading: false));
              return;
            }
            await loadAlerts(spaceId: spaceList.first.id);
          },
        );
      },
    );
  }

  Future<void> loadAlerts({
    required String spaceId,
    int days = 30,
    int size = 100,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final results = await Future.wait([
        _queryService.handleGetAlertsBySpace(
          GetAlertsBySpaceQuery(spaceId: spaceId, size: size),
        ),
        _queryService.handleGetDailySummaryBySpace(
          spaceId,
          days,
        ),
      ]);

      final alertsResult = results[0];
      final summaryResult = results[1];

      List<Alert> alerts = [];
      List<DailyAlertCount> dailySummary = [];
      String? errorMessage;

      alertsResult.fold(
            (failure) {
          errorMessage = failure.message;
        },
            (page) {
          alerts = (page as dynamic).content as List<Alert>;
        },
      );

      summaryResult.fold(
            (failure) {
          errorMessage ??= failure.message;
        },
            (summary) {
          dailySummary = summary as List<DailyAlertCount>;
        },
      );

      emit(state.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
        alerts: alerts,
        dailySummary: dailySummary,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        alerts: const [],
        dailySummary: const [],
      ));
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
