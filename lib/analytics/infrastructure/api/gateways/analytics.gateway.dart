import 'package:mobile/analytics/interfaces/rest/resources/analytics_summary_resource.resource.dart';

abstract class AnalyticsGateway {
  Future<AnalyticsSummaryResource> refreshAnalytics(String analyticsId);

  Future<List<AnalyticsSummaryResource>> getAnalyticsSummary({String? timeRange});
}
