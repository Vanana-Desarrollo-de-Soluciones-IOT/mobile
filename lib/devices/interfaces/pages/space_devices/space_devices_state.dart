part of 'space_devices_cubit.dart';

class SpaceDevicesState {
  final bool isLoading;
  final String? errorMessage;
  final bool isGrid;
  final List<DeviceResponseResource> devices;

  const SpaceDevicesState({
    this.isLoading = false,
    this.errorMessage,
    this.isGrid = true,
    this.devices = const [],
  });

  SpaceDevicesState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isGrid,
    List<DeviceResponseResource>? devices,
  }) {
    return SpaceDevicesState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isGrid: isGrid ?? this.isGrid,
      devices: devices ?? this.devices,
    );
  }
}
