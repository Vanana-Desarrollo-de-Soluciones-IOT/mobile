import 'package:dio/dio.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/alerts/infrastructure/api/gateways/alerts.gateway.dart';
import 'package:mobile/alerts/interfaces/rest/resources/alert_resource.resource.dart';

class AlertsHttpGateway implements AlertsGateway {
  final Dio _dio;

  AlertsHttpGateway(this._dio);

  @override
  Future<void> acknowledgeAlert(String alertId) async {
    await _dio.post('${ApiConstants.apiPrefix}/alerts/$alertId/acknowledge');
  }

  @override
  Future<List<AlertResource>> refreshAlerts({String? severity}) async {
    final response = await _dio.get(
      '${ApiConstants.apiPrefix}/alerts/refresh',
      queryParameters: severity != null ? {'severity': severity} : null,
    );
    final list = response.data as List<dynamic>;
    return list.map((e) => AlertResource.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<AlertResource>> getAlerts({String? severity, bool? acknowledged}) async {
    final queryParameters = <String, dynamic>{};
    if (severity != null) queryParameters['severity'] = severity;
    if (acknowledged != null) queryParameters['acknowledged'] = acknowledged;

    final response = await _dio.get(
      '${ApiConstants.apiPrefix}/alerts',
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );
    final list = response.data as List<dynamic>;
    return list.map((e) => AlertResource.fromJson(e as Map<String, dynamic>)).toList();
  }
}
