import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/devices/domain/model/commands/claim_device_to_space.command.dart';
import 'package:mobile/devices/domain/model/commands/pair_device.command.dart';
import 'package:mobile/devices/domain/model/queries/get_devices_by_space.query.dart';
import 'package:mobile/devices/domain/model/valueobjects/claim_token.valueobject.dart';
import 'package:mobile/devices/domain/model/valueobjects/hardware_id.valueobject.dart';
import 'package:mobile/devices/domain/services/devices.command-service.dart';
import 'package:mobile/devices/domain/services/devices.query-service.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_response.resource.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_pairing_resource.resource.dart';
import 'package:mobile/spaces/domain/model/valueobjects/space_id.valueobject.dart';

part 'space_devices_state.dart';

class SpaceDevicesCubit extends Cubit<SpaceDevicesState> {
  final DevicesQueryService _queryService;
  final DevicesCommandService _commandService;

  SpaceDevicesCubit(this._queryService, this._commandService) : super(const SpaceDevicesState());

  Future<void> loadDevices({required String spaceId}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final query = GetDevicesBySpaceQuery(spaceId: SpaceId(spaceId), page: 0, size: 100);
      final result = await _queryService.handleGetDevicesBySpace(query);
      result.fold(
        (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
        (page) => emit(state.copyWith(isLoading: false, devices: page.content)),
      );
    } on ArgumentError catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message as String?));
    }
  }

  void setLayoutGrid(bool isGrid) {
    if (state.isGrid == isGrid) return;
    emit(state.copyWith(isGrid: isGrid));
  }

  Future<DevicePairingResourceResource?> pairDevice({required String hardwareId}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final command = PairDeviceCommand(hardwareId: HardwareId(hardwareId));
      final result = await _commandService.handlePairDevice(command);
      return result.fold(
        (failure) {
          emit(state.copyWith(isLoading: false, errorMessage: failure.message));
          return null;
        },
        (resource) {
          emit(state.copyWith(isLoading: false));
          return resource;
        },
      );
    } on ArgumentError catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message as String?));
      return null;
    }
  }

  Future<DeviceResponseResource?> claimDeviceToSpace({
    required String claimToken,
    required String spaceId,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final command = ClaimDeviceToSpaceCommand(
        claimToken: ClaimToken(claimToken),
        spaceId: SpaceId(spaceId),
      );
      final result = await _commandService.handleClaimDeviceToSpace(command);
      return await result.fold(
        (failure) async {
          emit(state.copyWith(isLoading: false, errorMessage: failure.message));
          return null;
        },
        (resource) async {
          await loadDevices(spaceId: spaceId);
          return resource;
        },
      );
    } on ArgumentError catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message as String?));
      return null;
    }
  }
}
