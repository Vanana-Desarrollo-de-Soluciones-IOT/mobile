import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/devices/domain/model/commands/delete_device.command.dart';
import 'package:mobile/devices/domain/model/commands/update_device_name.command.dart';
import 'package:mobile/devices/domain/model/commands/write_device_threshold.command.dart';
import 'package:mobile/devices/domain/model/queries/get_device_by_id.query.dart';
import 'package:mobile/devices/domain/model/queries/get_device_thresholds.query.dart';
import 'package:mobile/devices/domain/model/readmodels/device_threshold.read_model.dart';
import 'package:mobile/devices/domain/model/valueobjects/metric_threshold.valueobject.dart';
import 'package:mobile/devices/domain/model/valueobjects/device_id.valueobject.dart';
import 'package:mobile/devices/domain/model/valueobjects/device_name.valueobject.dart';
import 'package:mobile/devices/domain/services/device_threshold.command-service.dart';
import 'package:mobile/devices/domain/services/device_threshold.query-service.dart';
import 'package:mobile/devices/domain/services/devices.command-service.dart';
import 'package:mobile/devices/domain/services/devices.query-service.dart';
import 'package:mobile/devices/interfaces/pages/device_detail/device_detail_view_model.dart';
import 'package:mobile/devices/interfaces/rest/transform/device_detail_threshold_defaults_transform.dart';
import 'package:mobile/devices/interfaces/rest/transform/device_thresholds_transform.dart';

part 'device_detail_state.dart';

class DeviceDetailCubit extends Cubit<DeviceDetailState> {
  final DevicesQueryService _devicesQueryService;
  final DevicesCommandService _devicesCommandService;
  final DeviceThresholdQueryService _thresholdQueryService;
  final DeviceThresholdCommandService _thresholdCommandService;
  String? _currentDeviceId;

  DeviceDetailCubit(
    this._devicesQueryService,
    this._devicesCommandService,
    this._thresholdQueryService,
    this._thresholdCommandService,
  ) : super(const DeviceDetailState());

  Future<void> loadDeviceDetail(String deviceId) async {
    _currentDeviceId = deviceId;
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final deviceResult = await _devicesQueryService.handleGetDeviceById(
      GetDeviceByIdQuery(deviceId: DeviceId(deviceId)),
    );
    await deviceResult.fold(
      (failure) async {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (device) async {
        final thresholds = await _loadThresholds(deviceId);

        final detail = DeviceDetailViewModel(
          id: device.id,
          name: device.name.isNotEmpty ? device.name : 'Device',
          status: device.status,
          isPoweredOn: device.status.toUpperCase() == 'ONLINE',
          connectivityDbm: _readDouble(device.configuration, ['connectivityDbm'], 60),
          uptimeHours: _readInt(device.configuration, ['uptimeHours'], 101),
          deviceHealthPercent: _readDouble(device.configuration, ['deviceHealthPercent'], 92),
          lastUpdateHours: _calculateLastUpdateHours(device.lastSeenAt),
          thresholds: thresholds,
        );

        emit(state.copyWith(isLoading: false, device: detail, errorMessage: null));
      },
    );
  }

  Future<bool> saveThresholds({
    required String deviceId,
    required List<DeviceDetailThresholdViewModel> thresholds,
  }) async {
    if (thresholds.isEmpty) {
      emit(state.copyWith(errorMessage: 'No thresholds to save.'));
      return false;
    }

    emit(state.copyWith(isSavingThresholds: true, errorMessage: null));

    final existingResult = await _thresholdQueryService.handleGetDeviceThresholds(
      GetDeviceThresholdsQuery(deviceId: deviceId),
    );

    final existingMetrics = existingResult.fold(
      (_) => <MetricThreshold>{},
      (items) => items.map((e) => e.metric).toSet(),
    );

    for (final threshold in thresholds) {
      final intent = existingMetrics.contains(threshold.metric)
          ? DeviceThresholdWriteIntent.update
          : DeviceThresholdWriteIntent.create;

      final command = toWriteDeviceThresholdCommand(
        deviceId: deviceId,
        metric: threshold.metric,
        value: threshold.value,
        enabled: threshold.enabled,
        intent: intent,
      );

      final saveResult = await _thresholdCommandService.handleWriteThreshold(command);
      final failedMessage = saveResult.fold((failure) => failure.message, (_) => null);

      if (failedMessage != null) {
        emit(state.copyWith(isSavingThresholds: false, errorMessage: failedMessage));
        return false;
      }
    }

    await loadDeviceDetail(deviceId);
    emit(state.copyWith(isSavingThresholds: false, errorMessage: null));
    return true;
  }

  Future<List<DeviceDetailThresholdViewModel>> _loadThresholds(String deviceId) async {
    final query = GetDeviceThresholdsQuery(deviceId: deviceId);
    final result = await _thresholdQueryService.handleGetDeviceThresholds(query);

    return result.fold(
      (_) => buildDefaultDeviceDetailThresholdResources(),
      (items) => _mergeWithDefaults(items),
    );
  }

  List<DeviceDetailThresholdViewModel> _mergeWithDefaults(List<DeviceThresholdReadModel> backendItems) {
    final map = <MetricThreshold, DeviceDetailThresholdViewModel>{
      for (final t in buildDefaultDeviceDetailThresholdResources()) t.metric: t,
    };

    for (final item in backendItems) {
      map[item.metric] = DeviceDetailThresholdViewModel(
        metric: item.metric,
        label: item.metricLabel.isNotEmpty ? item.metricLabel : _labelFor(item.metric),
        value: item.value,
        unit: item.metricUnit.isNotEmpty ? item.metricUnit : item.metric.unit,
        enabled: item.enabled,
      );
    }

    return MetricThreshold.values
        .where(map.containsKey)
        .map((metric) => map[metric]!)
        .toList();
  }

  String _labelFor(MetricThreshold metric) {
    switch (metric) {
      case MetricThreshold.pm25:
        return 'PM2.5';
      case MetricThreshold.co2:
        return 'CO₂';
      case MetricThreshold.temperature:
        return 'TEMP';
      case MetricThreshold.humidity:
        return 'HUMIDITY';
    }
  }

  double _readDouble(Map<String, String> config, List<String> keys, double fallback) {
    for (final key in keys) {
      final raw = config[key];
      final parsed = raw != null ? double.tryParse(raw) : null;
      if (parsed != null) return parsed;
    }
    return fallback;
  }

  int _readInt(Map<String, String> config, List<String> keys, int fallback) {
    for (final key in keys) {
      final raw = config[key];
      final parsed = raw != null ? int.tryParse(raw) : null;
      if (parsed != null) return parsed;
    }
    return fallback;
  }

  int _calculateLastUpdateHours(DateTime? lastSeenAt) {
    if (lastSeenAt == null) return 2;
    final diff = DateTime.now().difference(lastSeenAt).inHours;
    if (diff < 0) return 0;
    return diff;
  }

  Future<void> updateDeviceName(String deviceId, String name) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final result = await _devicesCommandService.handleUpdateDeviceName(
        UpdateDeviceNameCommand(
          deviceId: DeviceId(deviceId),
          name: DeviceName(name),
        ),
      );
      result.fold(
        (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
        (_) async {
          if (_currentDeviceId != null) {
            await loadDeviceDetail(_currentDeviceId!);
          }
        },
      );
    } on ArgumentError catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message as String?));
    }
  }

  Future<void> deleteDevice(String deviceId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final result = await _devicesCommandService.handleDeleteDevice(
        DeleteDeviceCommand(deviceId: DeviceId(deviceId)),
      );
      result.fold(
        (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
        (_) => emit(state.copyWith(isLoading: false, deleted: true)),
      );
    } on ArgumentError catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message as String?));
    }
  }
}
