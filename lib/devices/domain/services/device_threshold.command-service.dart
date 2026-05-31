import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/devices/domain/model/commands/write_device_threshold.command.dart';
import 'package:mobile/devices/domain/model/commands/remove_device_threshold.command.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_threshold.resource.dart';

abstract class DeviceThresholdCommandService {
  Future<Either<Failure, DeviceThresholdResource>> handleWriteThreshold(
    WriteDeviceThresholdCommand command,
  );

  Future<Either<Failure, void>> handleRemoveThreshold(
    RemoveDeviceThresholdCommand command,
  );
}