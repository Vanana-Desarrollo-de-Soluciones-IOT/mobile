part of 'device_detail_cubit.dart';

class DeviceDetailState {
  final bool isLoading;
  final bool isSavingThresholds;
  final DeviceDetailResource? device;
  final String? errorMessage;

  const DeviceDetailState({
    this.isLoading = false,
    this.isSavingThresholds = false,
    this.device,
    this.errorMessage,
  });

  DeviceDetailState copyWith({
    bool? isLoading,
    bool? isSavingThresholds,
    DeviceDetailResource? device,
    String? errorMessage,
  }) {
    return DeviceDetailState(
      isLoading: isLoading ?? this.isLoading,
      isSavingThresholds: isSavingThresholds ?? this.isSavingThresholds,
      device: device ?? this.device,
      errorMessage: errorMessage,
    );
  }
}
