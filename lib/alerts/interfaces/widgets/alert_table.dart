import 'package:flutter/material.dart';

import '../../domain/model/valueobjects/alert.valueobject.dart';
import 'alert_severity_badge.dart';
import 'alert_status_badge.dart';

class AlertTable extends StatefulWidget {
  final List<Alert>? alerts;
  final bool loading;

  const AlertTable({
    super.key,
    this.alerts,
    this.loading = false,
  });

  @override
  State<AlertTable> createState() => _AlertTableState();
}

class _AlertTableState extends State<AlertTable> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alerts = widget.alerts;

    if (!widget.loading && (alerts == null || alerts.isEmpty)) {
      return const _EmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: false,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 850),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _HeaderRow(),
                if (alerts != null)
                  for (final alert in alerts)
                    _TableRow(alert: alert),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        border: Border(
          bottom: BorderSide(color: Color(0xFF2A2A2A)),
        ),
      ),
      child: const Row(
        children: [
          _HeaderCell(width: 180, label: 'DEVICE'),
          _HeaderCell(width: 100, label: 'SEVERITY'),
          _HeaderCell(flex: 1, label: 'SPACE'),
          _HeaderCell(width: 120, label: 'VARIABLE'),
          _HeaderCell(width: 110, label: 'TIME'),
          _HeaderCell(width: 110, label: 'STATUS'),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final double? width;
  final int? flex;
  final String label;

  const _HeaderCell({
    this.width,
    this.flex,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      style: const TextStyle(
        fontSize: 11.2,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.88,
        color: Color(0xFF9CA3AF),
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: text);
    }

    return Expanded(flex: flex ?? 1, child: text);
  }
}

class _TableRow extends StatelessWidget {
  final Alert alert;

  const _TableRow({
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF222222)),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(
              _displayDevice(alert),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13.6,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: AlertSeverityBadge(severity: alert.severity),
          ),
          Expanded(
            child: Text(
              alert.spaceName ?? '-',
              style: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 13.6,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              alert.metric.apiName,
              style: const TextStyle(
                color: Color(0xFFE5E7EB),
                fontWeight: FontWeight.w600,
                fontSize: 12.8,
              ),
            ),
          ),
          SizedBox(
            width: 110,
            child: Text(
              _formatTime(alert.occurredAt),
              style: const TextStyle(
                color: Color(0xFFE5E7EB),
                fontSize: 13.6,
              ),
            ),
          ),
          SizedBox(
            width: 110,
            child: AlertStatusBadge(status: alert.status),
          ),
        ],
      ),
    );
  }

  String _formatTime(String iso) {
    final parsed = DateTime.tryParse(iso);
    if (parsed == null) {
      return iso;
    }

    final local = parsed.toLocal();
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    final ss = local.second.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }

  String _displayDevice(Alert alert) {
    final name = (alert.deviceName ?? '').trim();
    if (name.isNotEmpty) {
      return name;
    }
    return _shortId(alert.id.value);
  }

  String _shortId(String value) {
    if (value.length <= 4) {
      return value;
    }
    return value.substring(value.length - 4);
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 36,
            color: Color(0xFF9CA3AF),
          ),
          SizedBox(height: 12),
          Text(
            'No alerts found',
            style: TextStyle(color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }
}
