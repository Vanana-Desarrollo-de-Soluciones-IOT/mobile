import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/alerts/domain/model/commands/acknowledge_alert.command.dart';
import 'package:mobile/alerts/domain/model/commands/refresh_alerts.command.dart';
import 'package:mobile/alerts/interfaces/rest/resources/alert_resource.resource.dart';

abstract class AlertsCommandService {
  Future<Either<Failure, Unit>> handleAcknowledgeAlert(
    AcknowledgeAlertCommand command,
  );

  Future<Either<Failure, List<AlertResource>>> handleRefreshAlerts(
    RefreshAlertsCommand command,
  );
}
