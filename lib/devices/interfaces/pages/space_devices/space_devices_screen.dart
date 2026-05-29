import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/devices/interfaces/pages/space_devices/space_devices_cubit.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_response.resource.dart';
import 'package:mobile/devices/interfaces/widgets/claim_device_form.dart';
import 'package:mobile/devices/interfaces/widgets/pair_device_form.dart';
import 'package:mobile/shared/interfaces/widgets/clair_name.dart';

class SpaceDevicesScreen extends StatefulWidget {
  final String spaceId;
  final String? spaceName;

  const SpaceDevicesScreen({
    super.key,
    required this.spaceId,
    this.spaceName,
  });

  @override
  State<SpaceDevicesScreen> createState() => _SpaceDevicesScreenState();
}

class _SpaceDevicesScreenState extends State<SpaceDevicesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SpaceDevicesCubit>().loadDevices(spaceId: widget.spaceId);
  }

  Future<void> _openClaimDeviceSheet(BuildContext context) async {
    final cubit = context.read<SpaceDevicesCubit>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 16 + MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: BlocBuilder<SpaceDevicesCubit, SpaceDevicesState>(
              builder: (context, state) {
                return ClaimDeviceForm(
                  isLoading: state.isLoading,
                  onSubmit: (token) async {
                    final claimed = await cubit.claimDeviceToSpace(
                      claimToken: token,
                      spaceId: widget.spaceId,
                    );
                    if (claimed != null && context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _openPairDeviceSheet(BuildContext context) async {
    final cubit = context.read<SpaceDevicesCubit>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 16 + MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: BlocBuilder<SpaceDevicesCubit, SpaceDevicesState>(
              builder: (context, state) {
                return PairDeviceForm(
                  isLoading: state.isLoading,
                  onSubmit: (hardwareId) async {
                    final pairing = await cubit.pairDevice(hardwareId: hardwareId);
                    if (!context.mounted) return;

                    if (pairing != null) {
                      Navigator.of(context).pop();
                      await showDialog<void>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Pairing started'),
                            content: Text(
                              pairing.claimToken == null || pairing.claimToken!.isEmpty
                                  ? 'No claim token returned.'
                                  : 'Claim token: ${pairing.claimToken}',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.spaceName ?? 'Space';

    return SafeArea(
      child: BlocBuilder<SpaceDevicesCubit, SpaceDevicesState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const ClairName(height: 18),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Notifications',
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none, color: Colors.white70),
                    ),
                    const SizedBox(width: 6),
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(0xFF2A2A2A),
                      child: Icon(Icons.person, size: 16, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
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
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Add device',
                      onPressed: state.isLoading ? null : () => _openClaimDeviceSheet(context),
                      icon: const Icon(Icons.add, color: Colors.black),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF21D07A),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      tooltip: 'Pair device',
                      onPressed: state.isLoading ? null : () => _openPairDeviceSheet(context),
                      icon: const Icon(Icons.wifi_tethering_outlined, color: Colors.white70),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _LayoutToggle(
                  isGrid: state.isGrid,
                  onGrid: () => context.read<SpaceDevicesCubit>().setLayoutGrid(true),
                  onList: () => context.read<SpaceDevicesCubit>().setLayoutGrid(false),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state.isLoading && state.devices.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.errorMessage != null && state.devices.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              state.errorMessage!,
                              style: const TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      if (state.devices.isEmpty) {
                        return const Center(
                          child: Text(
                            'No devices yet',
                            style: TextStyle(color: Colors.white54),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () => context.read<SpaceDevicesCubit>().loadDevices(
                              spaceId: widget.spaceId,
                            ),
                        child: state.isGrid
                            ? GridView.builder(
                                padding: const EdgeInsets.only(top: 2),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  // Slightly wider than tall to match the design.
                                  childAspectRatio: 1.12,
                                ),
                                itemCount: state.devices.length,
                                itemBuilder: (context, index) {
                                  return _DeviceCard(device: state.devices[index]);
                                },
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.only(top: 2),
                                itemCount: state.devices.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  return _DeviceListTile(device: state.devices[index]);
                                },
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LayoutToggle extends StatelessWidget {
  final bool isGrid;
  final VoidCallback onGrid;
  final VoidCallback onList;

  const _LayoutToggle({
    required this.isGrid,
    required this.onGrid,
    required this.onList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TogglePill(
              isSelected: isGrid,
              icon: Icons.grid_view,
              label: 'Grid',
              onTap: onGrid,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TogglePill(
              isSelected: !isGrid,
              icon: Icons.format_list_bulleted,
              label: 'List',
              onTap: onList,
            ),
          ),
        ],
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  final bool isSelected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _TogglePill({
    required this.isSelected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: isSelected ? 0.20 : 0.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: Colors.white70),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final DeviceResponseResource device;

  const _DeviceCard({required this.device});

  @override
  Widget build(BuildContext context) {
    final label = _chipLabel(device);
    final updatedLabel = _updatedLabel(device);
    // Backend status is often OFFLINE until presence pings arrive;
    // show a "recently seen" dot to match the UI expectations.
    final isOnline = device.status.toUpperCase() == 'ONLINE';
    final isRecentlySeen = device.lastSeenAt != null &&
        DateTime.now().difference(device.lastSeenAt!).inMinutes < 2;
    final isPoweredOn = isOnline || isRecentlySeen;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.signal_cellular_alt, size: 18, color: Colors.white.withValues(alpha: 0.85)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  device.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _PowerStatusBadge(isOn: isPoweredOn),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.white.withValues(alpha: 0.55)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  updatedLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.50),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PowerStatusBadge extends StatelessWidget {
  final bool isOn;

  const _PowerStatusBadge({required this.isOn});

  @override
  Widget build(BuildContext context) {
    final bg = isOn ? const Color(0xFF21D07A) : Colors.white.withValues(alpha: 0.10);
    // In the design, the green power button reads as a filled green dot with a dark icon.
    final fg = isOn ? Colors.black : Colors.white70;
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.power_settings_new, size: 10.5, color: fg),
    );
  }
}

class _DeviceListTile extends StatelessWidget {
  final DeviceResponseResource device;

  const _DeviceListTile({required this.device});

  @override
  Widget build(BuildContext context) {
    final isOnline = device.status.toUpperCase() == 'ONLINE';
    final isRecentlySeen = device.lastSeenAt != null &&
        DateTime.now().difference(device.lastSeenAt!).inMinutes < 2;
    final isPoweredOn = isOnline || isRecentlySeen;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          _PowerStatusBadge(isOn: isPoweredOn),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _updatedLabel(device),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              _chipLabel(device),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _chipLabel(DeviceResponseResource device) {
  if (device.serialNumber.isNotEmpty) return device.serialNumber;
  if (device.hardwareId.isNotEmpty) return device.hardwareId;
  return 'DEVICE';
}

String _updatedLabel(DeviceResponseResource device) {
  final ts = device.lastSeenAt ?? device.updatedAt ?? device.createdAt;
  if (ts == null) return 'Updated recently';
  final diff = DateTime.now().difference(ts);

  if (diff.inSeconds < 10) return 'Updated just now';
  if (diff.inMinutes < 1) return 'Updated ${diff.inSeconds} seconds ago';
  if (diff.inHours < 1) return 'Updated ${diff.inMinutes} minutes ago';
  if (diff.inDays < 1) return 'Updated ${diff.inHours} hours ago';
  return 'Updated ${diff.inDays} days ago';
}
