import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/analytics/domain/model/queries/get_analytics_summary.query.dart';
import 'package:mobile/analytics/interfaces/rest/resources/analytics_summary_resource.resource.dart';

abstract class AnalyticsQueryService {
  Future<Either<Failure, List<AnalyticsSummaryResource>>> handleGetAnalyticsSummary(
    GetAnalyticsSummaryQuery query,
  );
}
