import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/analytics/domain/model/commands/refresh_analytics.command.dart';
import 'package:mobile/analytics/interfaces/rest/resources/analytics_summary_resource.resource.dart';

abstract class AnalyticsCommandService {
  Future<Either<Failure, AnalyticsSummaryResource>> handleRefreshAnalytics(
    RefreshAnalyticsCommand command,
  );
}
