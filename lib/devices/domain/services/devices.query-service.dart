import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/devices/domain/model/queries/get_devices_by_space.query.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_page_response.resource.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_response.resource.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_status_response.resource.dart';

abstract class DevicesQueryService {
  Future<Either<Failure, DevicePageResponseResource>> handleGetDevicesBySpace(
    GetDevicesBySpaceQuery query,
  );

  Future<Either<Failure, DeviceResponseResource>> handleGetDeviceById(String deviceId);

  Future<Either<Failure, DeviceStatusResponseResource>> handleGetDeviceStatus(String deviceId);
}
