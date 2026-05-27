import 'package:mobile/alerts/interfaces/rest/resources/alert_resource.resource.dart';

abstract class AlertsGateway {
  Future<void> acknowledgeAlert(String alertId);

  Future<List<AlertResource>> refreshAlerts({String? severity});

  Future<List<AlertResource>> getAlerts({String? severity, bool? acknowledged});
}
