import 'package:flutter/material.dart';

class DeviceThresholdResource {
  final String label;
  final String value;
  final String unit;

  const DeviceThresholdResource({
    required this.label,
    required this.value,
    required this.unit,
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
  final List<DeviceThresholdResource> thresholds;

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
