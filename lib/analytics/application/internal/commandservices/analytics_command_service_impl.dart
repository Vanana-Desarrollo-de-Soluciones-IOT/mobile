import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/analytics/domain/model/commands/refresh_analytics.command.dart';
import 'package:mobile/analytics/domain/services/analytics.command-service.dart';
import 'package:mobile/analytics/infrastructure/api/gateways/analytics.gateway.dart';
import 'package:mobile/analytics/interfaces/rest/resources/analytics_summary_resource.resource.dart';

class AnalyticsCommandServiceImpl implements AnalyticsCommandService {
  final AnalyticsGateway _gateway;

  AnalyticsCommandServiceImpl(this._gateway);

  @override
  Future<Either<Failure, AnalyticsSummaryResource>> handleRefreshAnalytics(
    RefreshAnalyticsCommand command,
  ) async {
    try {
      final result = await _gateway.refreshAnalytics(command.analyticsId.id);
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
