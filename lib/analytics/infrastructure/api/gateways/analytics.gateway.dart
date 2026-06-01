import 'package:mobile/analytics/interfaces/rest/resources/dashboard_metrics.resource.dart';
import 'package:mobile/analytics/interfaces/rest/resources/trends.resource.dart';

abstract class AnalyticsGateway {
  Future<DashboardMetricsResource> getDashboardMetrics({
    required String deviceId,
    String? period,
    String? startDate,
    String? endDate,
  });

  Future<TrendsResource> getTrends({
    required String deviceId,
    String? period,
    String? startDate,
    String? endDate,
  });
}
