import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_detail.resource.dart';

part 'device_detail_state.dart';

class DeviceDetailCubit extends Cubit<DeviceDetailState> {
  DeviceDetailCubit() : super(const DeviceDetailState());

  Future<void> loadDeviceDetail(String deviceId) async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(milliseconds: 300));

    final detail = DeviceDetailResource(
      id: deviceId,
      name: 'Clair-01',
      status: 'ONLINE',
      isPoweredOn: true,
      connectivityDbm: 60,
      uptimeHours: 101,
      deviceHealthPercent: 92,
      lastUpdateHours: 2,
      thresholds: const [
        DeviceThresholdResource(label: 'PM2.5', value: '60', unit: 'µg/m³'),
        DeviceThresholdResource(label: 'CO₂', value: '1000', unit: 'ppm'),
        DeviceThresholdResource(label: 'TEMP', value: '26', unit: '°C'),
        DeviceThresholdResource(label: 'HUMIDITY', value: '85', unit: '%'),
      ],
    );

    emit(state.copyWith(isLoading: false, device: detail));
  }
}
