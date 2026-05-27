import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/alerts/domain/model/queries/get_alerts.query.dart';
import 'package:mobile/alerts/interfaces/rest/resources/alert_resource.resource.dart';

abstract class AlertsQueryService {
  Future<Either<Failure, List<AlertResource>>> handleGetAlerts(
    GetAlertsQuery query,
  );
}
