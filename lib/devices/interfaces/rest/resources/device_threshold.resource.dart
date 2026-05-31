import 'package:mobile/devices/domain/model/valueobjects/metric_threshold.valueobject.dart';

class DeviceThresholdResource {
  final String id;
  final String deviceId;
  final MetricThreshold metric;
  final String metricLabel;
  final String metricUnit;
  final double value;
  final bool enabled;
  final String? createdAt;
  final String? updatedAt;

  const DeviceThresholdResource({
    required this.id,
    required this.deviceId,
    required this.metric,
    required this.metricLabel,
    required this.metricUnit,
    required this.value,
    required this.enabled,
    this.createdAt,
    this.updatedAt,
  });

  factory DeviceThresholdResource.fromJson(Map<String, dynamic> json) {
    final metricStr = (json['metric'] ?? '').toString();
    final metric = MetricThreshold.fromString(metricStr) ?? MetricThreshold.pm25;

    return DeviceThresholdResource(
      id: json['id']?.toString() ?? '',
      deviceId: json['deviceId']?.toString() ?? '',
      metric: metric,
      metricLabel: (json['metricLabel'] ?? metric.label).toString(),
      metricUnit: (json['metricUnit'] ?? metric.unit).toString(),
      value: _parseDouble(json['value']),
      enabled: json['enabled'] == true,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
