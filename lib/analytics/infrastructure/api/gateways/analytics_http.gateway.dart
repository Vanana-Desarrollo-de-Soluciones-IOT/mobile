import 'package:dio/dio.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/analytics/infrastructure/api/gateways/analytics.gateway.dart';
import 'package:mobile/analytics/interfaces/rest/resources/dashboard_metrics.resource.dart';
import 'package:mobile/analytics/interfaces/rest/resources/trends.resource.dart';

class AnalyticsHttpGateway implements AnalyticsGateway {
  final Dio _dio;

  AnalyticsHttpGateway(this._dio);

  static const String _base = '${ApiConstants.apiPrefix}/analytics';

  @override
  Future<DashboardMetricsResource> getDashboardMetrics({
    required String deviceId,
    String? period,
    String? startDate,
    String? endDate,
  }) async {
    // Decide /live vs /historical, mirroring the web gateway.
    final isLive = period == null || period.toUpperCase() == 'LIVE';
    final endpoint = isLive ? 'live' : 'historical';

    final params = <String, dynamic>{};
    if (period != null && !isLive) params['period'] = period;
    if (startDate != null) params['startDate'] = startDate;
    if (endDate != null) params['endDate'] = endDate;

    final response = await _dio.get(
      '$_base/devices/$deviceId/$endpoint',
      queryParameters: params.isEmpty ? null : params,
    );
    return DashboardMetricsResource.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TrendsResource> getTrends({
    required String deviceId,
    String? period,
    String? startDate,
    String? endDate,
  }) async {
    final params = <String, dynamic>{};
    if (period != null) params['period'] = period;
    if (startDate != null) params['startDate'] = startDate;
    if (endDate != null) params['endDate'] = endDate;

    final response = await _dio.get(
      '$_base/devices/$deviceId/trends',
      queryParameters: params.isEmpty ? null : params,
    );
    return TrendsResource.fromJson(response.data as Map<String, dynamic>);
  }
}
