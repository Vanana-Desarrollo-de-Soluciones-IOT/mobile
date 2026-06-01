import 'package:flutter/material.dart';
import 'package:mobile/devices/interfaces/rest/resources/device_detail.resource.dart';
import 'package:mobile/shared/interfaces/widgets/icons/clair_device_icon.dart';

class DeviceDetailHeader extends StatelessWidget {
  final DeviceDetailResource device;
  final VoidCallback? onPowerToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DeviceDetailHeader({
    super.key,
    required this.device,
    this.onPowerToggle,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 32),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      device.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF21D07A),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onPowerToggle,
                icon: const Icon(
                  Icons.power_settings_new,
                  size: 14,
                  color: Colors.black,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF21D07A),
                  minimumSize: const Size(28, 28),
                  maximumSize: const Size(28, 28),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 4),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white70),
                color: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit?.call();
                  } else if (value == 'delete') {
                    onDelete?.call();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18, color: Colors.white70),
                        const SizedBox(width: 12),
                        const Text('Edit', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                        const SizedBox(width: 12),
                        const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          ClairDeviceIcon(
            size: 140,
            color: Colors.white.withValues(alpha: 0.95),
          ),
        ],
      ),
    );
  }
}
