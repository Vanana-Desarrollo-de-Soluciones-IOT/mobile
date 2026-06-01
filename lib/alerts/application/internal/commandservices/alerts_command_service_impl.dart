import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/alerts/domain/model/commands/acknowledge_alert.command.dart';
import 'package:mobile/alerts/domain/model/commands/refresh_alerts.command.dart';
import 'package:mobile/alerts/domain/services/alerts.command-service.dart';
import 'package:mobile/alerts/infrastructure/api/gateways/alerts.gateway.dart';
import 'package:mobile/alerts/interfaces/rest/resources/alert_resource.resource.dart';

class AlertsCommandServiceImpl implements AlertsCommandService {
  final AlertsGateway _gateway;

  AlertsCommandServiceImpl(this._gateway);

  @override
  Future<Either<Failure, Unit>> handleAcknowledgeAlert(
    AcknowledgeAlertCommand command,
  ) async {
    try {
      await _gateway.acknowledgeAlert(command.alertId.value);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(_mapError(e)));
    }
  }

  @override
  Future<Either<Failure, List<AlertResource>>> handleRefreshAlerts(
    RefreshAlertsCommand command,
  ) async {
    try {
      final result = await _gateway.refreshAlerts(severity: command.severity);
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
