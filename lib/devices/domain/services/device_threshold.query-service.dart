import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/devices/domain/model/queries/get_device_thresholds.query.dart';
import 'package:mobile/devices/domain/model/queries/get_device_threshold_by_metric.query.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_threshold.resource.dart';

abstract class DeviceThresholdQueryService {
  Future<Either<Failure, List<DeviceThresholdResource>>> handleGetDeviceThresholds(
    GetDeviceThresholdsQuery query,
  );

  Future<Either<Failure, DeviceThresholdResource>> handleGetDeviceThresholdByMetric(
    GetDeviceThresholdByMetricQuery query,
  );
}