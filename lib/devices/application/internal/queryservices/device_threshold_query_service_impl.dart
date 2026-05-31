import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/devices/domain/model/queries/get_device_threshold_by_metric.query.dart';
import 'package:mobile/devices/domain/model/queries/get_device_thresholds.query.dart';
import 'package:mobile/devices/domain/services/device_threshold.query-service.dart';
import 'package:mobile/devices/infrastructure/api/gateways/device_thresholds.gateway.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_threshold.resource.dart';

class DeviceThresholdQueryServiceImpl implements DeviceThresholdQueryService {
  final DeviceThresholdsGateway _gateway;

  DeviceThresholdQueryServiceImpl(this._gateway);

  @override
  Future<Either<Failure, List<DeviceThresholdResource>>> handleGetDeviceThresholds(
    GetDeviceThresholdsQuery query,
  ) async {
    try {
      final result = await _gateway.getThresholdsByDevice(query.deviceId);
      return Right(result);
    } catch (e) {
      return Left(Failure(_mapError(e)));
    }
  }

  @override
  Future<Either<Failure, DeviceThresholdResource>> handleGetDeviceThresholdByMetric(
    GetDeviceThresholdByMetricQuery query,
  ) async {
    try {
      final result = await _gateway.getThresholdByMetric(
        query.deviceId,
        query.metric,
      );
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