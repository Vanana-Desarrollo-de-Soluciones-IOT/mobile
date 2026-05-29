import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/devices/domain/model/queries/get_devices_by_space.query.dart';
import 'package:mobile/devices/domain/services/devices.query-service.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_response.resource.dart';
import 'package:mobile/spaces/domain/model/valueobjects/space_id.valueobject.dart';

part 'space_devices_state.dart';

class SpaceDevicesCubit extends Cubit<SpaceDevicesState> {
  final DevicesQueryService _queryService;

  SpaceDevicesCubit(this._queryService) : super(const SpaceDevicesState());

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
}
