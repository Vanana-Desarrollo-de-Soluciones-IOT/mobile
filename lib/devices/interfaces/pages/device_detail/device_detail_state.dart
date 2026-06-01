part of 'device_detail_cubit.dart';

class DeviceDetailState {
  final bool isLoading;
  final bool isSavingThresholds;
  final bool deleted;
  final DeviceDetailViewModel? device;
  final String? errorMessage;

  const DeviceDetailState({
    this.isLoading = false,
    this.isSavingThresholds = false,
    this.deleted = false,
    this.device,
    this.errorMessage,
  });

  DeviceDetailState copyWith({
    bool? isLoading,
    bool? isSavingThresholds,
    bool? deleted,
    DeviceDetailViewModel? device,
    String? errorMessage,
  }) {
    return DeviceDetailState(
      isLoading: isLoading ?? this.isLoading,
      isSavingThresholds: isSavingThresholds ?? this.isSavingThresholds,
      deleted: deleted ?? this.deleted,
      device: device ?? this.device,
      errorMessage: errorMessage,
    );
  }
}
