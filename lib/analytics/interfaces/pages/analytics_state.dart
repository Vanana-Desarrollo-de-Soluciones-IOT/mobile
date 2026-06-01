part of 'analytics_cubit.dart';

class AnalyticsSelectOption {
  final String id;
  final String name;

  const AnalyticsSelectOption({required this.id, required this.name});
}

class AnalyticsState {
  final bool isLoading;
  final String? errorMessage;
  final bool liveUnavailable;
  final String liveUnavailableMessage;

  final List<AnalyticsSelectOption> organizations;
  final List<AnalyticsSelectOption> spaces;
  final List<AnalyticsSelectOption> devices;

  final String? selectedOrgId;
  final String? selectedSpaceId;
  final String? selectedDeviceId;

  final String selectedPeriod;
  final String selectedMetric;

  final DashboardMetrics? liveData;
  final List<TrendPoint> trendDataPoints;

  final int secondsSinceUpdate;

  const AnalyticsState({
    this.isLoading = false,
    this.errorMessage,
    this.liveUnavailable = false,
    this.liveUnavailableMessage = '',
    this.organizations = const [],
    this.spaces = const [],
    this.devices = const [],
    this.selectedOrgId,
    this.selectedSpaceId,
    this.selectedDeviceId,
    this.selectedPeriod = 'LIVE',
    this.selectedMetric = 'aqiValue',
    this.liveData,
    this.trendDataPoints = const [],
    this.secondsSinceUpdate = 0,
  });

  bool get hasData => liveData != null || trendDataPoints.isNotEmpty;

  AnalyticsState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? liveUnavailable,
    String? liveUnavailableMessage,
    List<AnalyticsSelectOption>? organizations,
    List<AnalyticsSelectOption>? spaces,
    List<AnalyticsSelectOption>? devices,
    String? selectedOrgId,
    String? selectedSpaceId,
    bool clearSelectedSpaceId = false,
    String? selectedDeviceId,
    bool clearSelectedDeviceId = false,
    String? selectedPeriod,
    String? selectedMetric,
    DashboardMetrics? liveData,
    bool clearLiveData = false,
    List<TrendPoint>? trendDataPoints,
    int? secondsSinceUpdate,
  }) {
    return AnalyticsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      liveUnavailable: liveUnavailable ?? this.liveUnavailable,
      liveUnavailableMessage: liveUnavailableMessage ?? this.liveUnavailableMessage,
      organizations: organizations ?? this.organizations,
      spaces: spaces ?? this.spaces,
      devices: devices ?? this.devices,
      selectedOrgId: selectedOrgId ?? this.selectedOrgId,
      selectedSpaceId: clearSelectedSpaceId ? null : (selectedSpaceId ?? this.selectedSpaceId),
      selectedDeviceId: clearSelectedDeviceId ? null : (selectedDeviceId ?? this.selectedDeviceId),
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      selectedMetric: selectedMetric ?? this.selectedMetric,
      liveData: clearLiveData ? null : (liveData ?? this.liveData),
      trendDataPoints: trendDataPoints ?? this.trendDataPoints,
      secondsSinceUpdate: secondsSinceUpdate ?? this.secondsSinceUpdate,
    );
  }
}
