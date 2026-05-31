import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/devices/domain/model/commands/claim_device_to_space.command.dart';
import 'package:mobile/devices/domain/model/commands/pair_device.command.dart';
import 'package:mobile/devices/domain/services/devices.command-service.dart';
import 'package:mobile/devices/infrastructure/api/gateways/devices.gateway.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_pairing_resource.resource.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_response.resource.dart';
import 'package:mobile/devices/interfaces/rest/transform/devices_transform.dart';

class DevicesCommandServiceImpl implements DevicesCommandService {
  final DevicesGateway _gateway;

  DevicesCommandServiceImpl(this._gateway);

  @override
  Future<Either<Failure, DevicePairingResourceResource>> handlePairDevice(
    PairDeviceCommand command,
  ) async {
    try {
      final req = toPairDeviceRequestResource(command);
      final raw = await _gateway.pairDeviceRaw(requestBody: req.toJson());
      return Right(DevicePairingResourceResource.fromJson(raw));
    } catch (e) {
      return Left(Failure(_mapError(e)));
    }
  }

  @override
  Future<Either<Failure, DeviceResponseResource>> handleClaimDeviceToSpace(
    ClaimDeviceToSpaceCommand command,
  ) async {
    try {
      final req = toClaimDeviceRequestResource(command);
      final raw = await _gateway.claimDeviceRaw(requestBody: req.toJson());
      return Right(DeviceResponseResource.fromJson(raw));
    } catch (e) {
      return Left(Failure(_mapError(e)));
    }
  }

  @override
  Future<Either<Failure, void>> handleDeleteDevice(String deviceId) async {
    try {
      await _gateway.deleteDeviceRaw(deviceId);
      return const Right(null);
    } catch (e) {
      return Left(Failure(_mapError(e)));
    }
  }

  @override
  Future<Either<Failure, void>> handleUpdateDeviceName(String deviceId, String name) async {
    try {
      await _gateway.updateDeviceNameRaw(deviceId, {'name': name});
      return const Right(null);
    } catch (e) {
      return Left(Failure(_mapError(e)));
    }
  }

  String _mapError(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      switch (statusCode) {
        case 400:
          return 'Invalid request.';
        case 401:
          return 'Session expired. Please sign in again.';
        case 403:
          return 'Access denied.';
        case 404:
          return 'Not found.';
        case 409:
          return 'Conflict.';
        case 500:
        case 502:
        case 503:
          return 'Server error. Please try again later.';
        default:
          return 'Network error. Please check your connection.';
      }
    }
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'An unexpected error occurred';
  }
}
