import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/devices/interfaces/pages/device_detail/device_detail_cubit.dart';
import 'package:mobile/devices/interfaces/widgets/device_detail_header.dart';
import 'package:mobile/devices/interfaces/widgets/device_detail_metrics_grid.dart';
import 'package:mobile/devices/interfaces/widgets/device_thresholds_section.dart';
import 'package:mobile/shared/interfaces/widgets/widgets.dart';

class DeviceDetailScreen extends StatefulWidget {
  final String deviceId;

  const DeviceDetailScreen({
    super.key,
    required this.deviceId,
  });

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DeviceDetailCubit>().loadDeviceDetail(widget.deviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ClairAppBar(),
      body: SafeArea(
        child: BlocBuilder<DeviceDetailCubit, DeviceDetailState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final device = state.device;
            if (device == null) {
              return const Center(
                child: Text(
                  'Device not found',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                            return;
                          }
                          context.go('/spaces');
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DeviceDetailHeader(
                    device: device,
                    onPowerToggle: () {},
                    onMenuTap: () {},
                  ),
                  const SizedBox(height: 20),
                  DeviceDetailMetricsGrid(device: device),
                  const SizedBox(height: 28),
                  DeviceThresholdsSection(
                    thresholds: device.thresholds,
                    onEditTap: () {},
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
