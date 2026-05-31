import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/devices/domain/model/queries/get_devices_by_space.query.dart';
import 'package:mobile/devices/domain/services/devices.query-service.dart';
import 'package:mobile/devices/infrastructure/api/gateways/devices.gateway.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_page_response.resource.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_response.resource.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_status_response.resource.dart';

class DevicesQueryServiceImpl implements DevicesQueryService {
  final DevicesGateway _gateway;

  DevicesQueryServiceImpl(this._gateway);

  @override
  Future<Either<Failure, DevicePageResponseResource>> handleGetDevicesBySpace(
    GetDevicesBySpaceQuery query,
  ) async {
    try {
      final raw = await _gateway.getDevicesBySpaceRaw(
        spaceId: query.spaceId.value,
        page: query.page,
        size: query.size,
      );
      return Right(DevicePageResponseResource.fromJson(raw));
    } catch (e) {
      return Left(Failure(_mapError(e)));
    }
  }

  @override
  Future<Either<Failure, DeviceResponseResource>> handleGetDeviceById(String deviceId) async {
    try {
      final raw = await _gateway.getDeviceByIdRaw(deviceId);
      return Right(DeviceResponseResource.fromJson(raw));
    } catch (e) {
      return Left(Failure(_mapError(e)));
    }
  }

  @override
  Future<Either<Failure, DeviceStatusResponseResource>> handleGetDeviceStatus(String deviceId) async {
    try {
      final raw = await _gateway.getDeviceStatusRaw(deviceId);
      return Right(DeviceStatusResponseResource.fromJson(raw));
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
