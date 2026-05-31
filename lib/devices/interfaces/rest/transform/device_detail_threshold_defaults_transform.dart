import 'package:mobile/devices/domain/model/valueobjects/metric_threshold.valueobject.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_detail.resource.dart';

List<DeviceDetailThresholdResource> buildDefaultDeviceDetailThresholdResources() {
  return const [
    DeviceDetailThresholdResource(
      metric: MetricThreshold.pm25,
      label: 'PM2.5',
      value: 60,
      unit: 'µg/m³',
      enabled: true,
    ),
    DeviceDetailThresholdResource(
      metric: MetricThreshold.co2,
      label: 'CO₂',
      value: 1000,
      unit: 'ppm',
      enabled: true,
    ),
    DeviceDetailThresholdResource(
      metric: MetricThreshold.temperature,
      label: 'TEMP',
      value: 28.7,
      unit: '°C',
      enabled: true,
    ),
    DeviceDetailThresholdResource(
      metric: MetricThreshold.humidity,
      label: 'HUMIDITY',
      value: 80,
      unit: '%',
      enabled: true,
    ),
  ];
}
