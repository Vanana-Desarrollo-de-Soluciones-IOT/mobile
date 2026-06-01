import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/analytics/domain/model/queries/get_dashboard_metrics.query.dart';
import 'package:mobile/analytics/domain/model/queries/get_trends.query.dart';
import 'package:mobile/analytics/domain/model/valueobjects/dashboard_metrics.valueobject.dart';
import 'package:mobile/analytics/domain/model/valueobjects/trend_point.valueobject.dart';
import 'package:mobile/analytics/domain/services/analytics.query-service.dart';
import 'package:mobile/devices/domain/model/queries/get_devices_by_space.query.dart';
import 'package:mobile/devices/domain/model/queries/get_spaces_by_organization.query.dart';
import 'package:mobile/devices/domain/model/queries/get_user_organizations.query.dart';
import 'package:mobile/devices/domain/model/valueobjects/organization_id.valueobject.dart';
import 'package:mobile/devices/domain/model/valueobjects/space_id.valueobject.dart';
import 'package:mobile/devices/domain/services/devices.query-service.dart';
import 'package:mobile/devices/domain/services/organizations.query-service.dart';
import 'package:mobile/devices/domain/services/spaces.query-service.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final AnalyticsQueryService _analytics;
  final OrganizationsQueryService _organizations;
  final SpacesQueryService _spaces;
  final DevicesQueryService _devices;

  Timer? _pollTimer;
  Timer? _secondsTimer;

  AnalyticsCubit(
    this._analytics,
    this._organizations,
    this._spaces,
    this._devices,
  ) : super(const AnalyticsState());

  Future<void> load() async {
    _startSecondsCounter();
    await loadOrganizations();
  }

  Future<void> loadOrganizations() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _organizations.handleGetUserOrganizations(
      const GetUserOrganizationsQuery(),
    );
    await result.fold(
      (failure) async {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load organizations. Please try again.',
        ));
      },
      (orgs) async {
        final options = orgs
            .map((o) => AnalyticsSelectOption(id: o.id, name: o.name))
            .toList();
        emit(state.copyWith(organizations: options));
        if (options.isNotEmpty) {
          await selectOrganization(options.first.id);
        } else {
          emit(state.copyWith(isLoading: false));
        }
      },
    );
  }

  Future<void> selectOrganization(String orgId) async {
    _stopPolling();
    emit(state.copyWith(
      selectedOrgId: orgId,
      spaces: const [],
      devices: const [],
      clearSelectedSpaceId: true,
      clearSelectedDeviceId: true,
      clearLiveData: true,
      trendDataPoints: const [],
      liveUnavailable: false,
      liveUnavailableMessage: '',
      isLoading: true,
      clearError: true,
    ));

    final result = await _spaces.handleGetSpacesByOrganization(
      GetSpacesByOrganizationQuery(organizationId: OrganizationId(orgId)),
    );
    await result.fold(
      (failure) async {
        emit(state.copyWith(isLoading: false, errorMessage: 'Failed to load spaces.'));
      },
      (spaces) async {
        final options = spaces
            .map((s) => AnalyticsSelectOption(id: s.id, name: s.name))
            .toList();
        emit(state.copyWith(spaces: options));
        if (options.isNotEmpty) {
          await selectSpace(options.first.id);
        } else {
          emit(state.copyWith(isLoading: false));
        }
      },
    );
  }

  Future<void> selectSpace(String spaceId) async {
    _stopPolling();
    emit(state.copyWith(
      selectedSpaceId: spaceId,
      devices: const [],
      clearSelectedDeviceId: true,
      clearLiveData: true,
      trendDataPoints: const [],
      liveUnavailable: false,
      liveUnavailableMessage: '',
      isLoading: true,
      clearError: true,
    ));

    final result = await _devices.handleGetDevicesBySpace(
      GetDevicesBySpaceQuery(spaceId: SpaceId(spaceId), size: 100),
    );
    await result.fold(
      (failure) async {
        emit(state.copyWith(isLoading: false, errorMessage: 'Failed to load devices.'));
      },
      (page) async {
        final options = page.content
            .map((d) => AnalyticsSelectOption(id: d.id, name: d.name))
            .toList();
        emit(state.copyWith(devices: options));
        if (options.isNotEmpty) {
          await selectDevice(options.first.id);
        } else {
          emit(state.copyWith(isLoading: false));
        }
      },
    );
  }

  Future<void> selectDevice(String deviceId) async {
    _stopPolling();
    emit(state.copyWith(
      selectedDeviceId: deviceId,
      clearLiveData: true,
      trendDataPoints: const [],
      liveUnavailable: false,
      liveUnavailableMessage: '',
    ));
    await fetchData();
    _startPolling();
  }

  void selectPeriod(String period) {
    _stopPolling();
    emit(state.copyWith(selectedPeriod: period));
    fetchData();
    _startPolling();
  }

  void selectMetric(String metric) {
    emit(state.copyWith(selectedMetric: metric));
  }

  Future<void> fetchData() async {
    final deviceId = state.selectedDeviceId;
    if (deviceId == null) return;

    emit(state.copyWith(isLoading: true, clearError: true, liveUnavailable: false));

    final period = state.selectedPeriod;
    // Metrics: 'LIVE' / 'Day' / 'Week' / 'Month' (gateway routes live vs historical).
    final metricsFuture = _analytics.handleGetDashboardMetrics(
      GetDashboardMetricsQuery(deviceId: deviceId, period: period),
    );
    // Trends: LIVE falls back to DAY; otherwise uppercased period.
    final trendPeriod = period == 'LIVE' ? 'DAY' : period.toUpperCase();
    final trendsFuture = _analytics.handleGetTrends(
      GetTrendsQuery(deviceId: deviceId, period: trendPeriod),
    );

    final metricsResult = await metricsFuture;
    metricsResult.fold(
      (failure) {
        if (failure.statusCode == 404) {
          final deviceName = state.devices
              .firstWhere(
                (d) => d.id == deviceId,
                orElse: () => const AnalyticsSelectOption(id: '', name: 'Device'),
              )
              .name;
          final message = failure.message.replaceAll(deviceId, '"$deviceName"');
          emit(state.copyWith(
            clearLiveData: true,
            liveUnavailable: true,
            liveUnavailableMessage: message,
          ));
        } else {
          emit(state.copyWith(clearLiveData: true));
        }
      },
      (metrics) {
        emit(state.copyWith(liveData: metrics, secondsSinceUpdate: 0));
      },
    );

    final trendsResult = await trendsFuture;
    trendsResult.fold(
      (failure) => emit(state.copyWith(isLoading: false, trendDataPoints: const [])),
      (trends) => emit(state.copyWith(isLoading: false, trendDataPoints: trends)),
    );
  }

  void _startPolling() {
    _stopPolling();
    if (state.selectedDeviceId == null) return;
    // SSE live-stream is not consumed on mobile; poll instead.
    final interval = state.selectedPeriod == 'LIVE'
        ? const Duration(seconds: 5)
        : const Duration(seconds: 30);
    _pollTimer = Timer.periodic(interval, (_) => fetchData());
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  void _startSecondsCounter() {
    _secondsTimer?.cancel();
    _secondsTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.liveData == null) return;
      emit(state.copyWith(secondsSinceUpdate: state.secondsSinceUpdate + 1));
    });
  }

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    _secondsTimer?.cancel();
    return super.close();
  }
}
