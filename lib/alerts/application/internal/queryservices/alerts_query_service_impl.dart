import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/alerts/domain/model/queries/get_alerts.query.dart';
import 'package:mobile/alerts/domain/services/alerts.query-service.dart';
import 'package:mobile/alerts/infrastructure/api/gateways/alerts.gateway.dart';
import 'package:mobile/alerts/interfaces/rest/resources/alert_resource.resource.dart';

class AlertsQueryServiceImpl implements AlertsQueryService {
  final AlertsGateway _gateway;

  AlertsQueryServiceImpl(this._gateway);

  @override
  Future<Either<Failure, List<AlertResource>>> handleGetAlerts(
    GetAlertsQuery query,
  ) async {
    try {
      final result = await _gateway.getAlerts(
        severity: query.severity,
        acknowledged: query.acknowledged,
      );
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
