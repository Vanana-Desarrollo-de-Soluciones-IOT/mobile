part of 'device_detail_cubit.dart';

class DeviceDetailState {
  final bool isLoading;
  final DeviceDetailResource? device;
  final String? errorMessage;

  const DeviceDetailState({
    this.isLoading = false,
    this.device,
    this.errorMessage,
  });

  DeviceDetailState copyWith({
    bool? isLoading,
    DeviceDetailResource? device,
    String? errorMessage,
  }) {
    return DeviceDetailState(
      isLoading: isLoading ?? this.isLoading,
      device: device ?? this.device,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
