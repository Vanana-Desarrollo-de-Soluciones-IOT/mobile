import 'package:mobile/devices/domain/model/valueobjects/metric_threshold.valueobject.dart';

class DeviceDetailThresholdResource {
  final MetricThreshold metric;
  final String label;
  final double value;
  final String unit;
  final bool enabled;

  const DeviceDetailThresholdResource({
    required this.metric,
    required this.label,
    required this.value,
    required this.unit,
    required this.enabled,
  });
}

class DeviceDetailResource {
  final String id;
  final String name;
  final String status;
  final bool isPoweredOn;
  final double connectivityDbm;
  final int uptimeHours;
  final double deviceHealthPercent;
  final int lastUpdateHours;
  final List<DeviceDetailThresholdResource> thresholds;

  const DeviceDetailResource({
    required this.id,
    required this.name,
    required this.status,
    required this.isPoweredOn,
    required this.connectivityDbm,
    required this.uptimeHours,
    required this.deviceHealthPercent,
    required this.lastUpdateHours,
    required this.thresholds,
  });
}
