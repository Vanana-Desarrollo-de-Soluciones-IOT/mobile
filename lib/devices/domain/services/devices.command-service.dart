import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/devices/domain/model/commands/claim_device_to_space.command.dart';
import 'package:mobile/devices/domain/model/commands/pair_device.command.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_pairing_resource.resource.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_response.resource.dart';

abstract class DevicesCommandService {
  Future<Either<Failure, DevicePairingResourceResource>> handlePairDevice(PairDeviceCommand command);

  Future<Either<Failure, DeviceResponseResource>> handleClaimDeviceToSpace(
    ClaimDeviceToSpaceCommand command,
  );

  Future<Either<Failure, void>> handleDeleteDevice(String deviceId);

  Future<Either<Failure, void>> handleUpdateDeviceName(String deviceId, String name);
}
