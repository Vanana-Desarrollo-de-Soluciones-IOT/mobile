import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/analytics/domain/model/queries/get_analytics_summary.query.dart';
import 'package:mobile/analytics/domain/services/analytics.query-service.dart';
import 'package:mobile/analytics/infrastructure/api/gateways/analytics.gateway.dart';
import 'package:mobile/analytics/interfaces/rest/resources/analytics_summary_resource.resource.dart';

class AnalyticsQueryServiceImpl implements AnalyticsQueryService {
  final AnalyticsGateway _gateway;

  AnalyticsQueryServiceImpl(this._gateway);

  @override
  Future<Either<Failure, List<AnalyticsSummaryResource>>> handleGetAnalyticsSummary(
    GetAnalyticsSummaryQuery query,
  ) async {
    try {
      final result = await _gateway.getAnalyticsSummary(timeRange: query.timeRange);
      return Right(result);
    } catch (e) {
      return Left(Failure(_mapError(e)));
    }
  }

  String _mapError(Object error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'An unexpected error occurred';
  }
}
