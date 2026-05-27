import 'package:dio/dio.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/analytics/infrastructure/api/gateways/analytics.gateway.dart';
import 'package:mobile/analytics/interfaces/rest/resources/analytics_summary_resource.resource.dart';

class AnalyticsHttpGateway implements AnalyticsGateway {
  final Dio _dio;

  AnalyticsHttpGateway(this._dio);

  @override
  Future<AnalyticsSummaryResource> refreshAnalytics(String analyticsId) async {
    final response = await _dio.post(
      '${ApiConstants.apiPrefix}/analytics/$analyticsId/refresh',
    );
    return AnalyticsSummaryResource.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<AnalyticsSummaryResource>> getAnalyticsSummary({String? timeRange}) async {
    final response = await _dio.get(
      '${ApiConstants.apiPrefix}/analytics/summary',
      queryParameters: timeRange != null ? {'timeRange': timeRange} : null,
    );
    final list = response.data as List<dynamic>;
    return list.map((e) => AnalyticsSummaryResource.fromJson(e as Map<String, dynamic>)).toList();
  }
}
