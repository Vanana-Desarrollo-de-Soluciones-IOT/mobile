import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/model/valueobjects/daily_alert_count.valueobject.dart';

class AlertDailyChart extends StatelessWidget {
  final List<DailyAlertCount>? data;

  const AlertDailyChart({
    super.key,
    this.data,
  });

  static const int _daysToShow = 30;

  @override
  Widget build(BuildContext context) {
    final bars = _buildChartBars();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Last 30 days',
            style: TextStyle(
              fontSize: 14.4,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE5E7EB),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _GridPainter(),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: bars
                          .map(
                            (bar) => Expanded(
                              child: _ChartBar(
                                heightPct: bar.heightPct,
                                color: bar.color,
                                maxHeight: constraints.maxHeight,
                              ),
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFF2A2A2A)),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 11.2,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                Text(
                  '30 days ago',
                  style: TextStyle(
                    fontSize: 11.2,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<_ChartBarData> _buildChartBars() {
    final days = _buildLastNDays(_daysToShow);
    final countsByDate = <String, int>{
      for (final entry in (data ?? const <DailyAlertCount>[]))
        entry.date: entry.count,
    };

    final series = days
        .map(
          (isoDate) => _ChartPoint(
            date: isoDate,
            count: countsByDate[isoDate] ?? 0,
          ),
        )
        .toList(growable: false);

    final maxCount = math.max(
      series.map((d) => d.count).fold<int>(0, math.max),
      1,
    );

    return series
        .map(
          (d) {
            final rawHeight = (d.count / maxCount) * 100.0;

            final double heightPct =
            d.count == 0
                ? 2.0
                : math.max(rawHeight, 6.0).toDouble();

            return _ChartBarData(
              label: d.date.substring(5),
              heightPct: heightPct,
              color: _barColor(d.count),
            );
          },
        )
        .toList(growable: false);
  }

  List<String> _buildLastNDays(int days) {
    final out = <String>[];
    final today = DateTime.now();

    for (var i = 0; i < days; i++) {
      final d = DateTime(today.year, today.month, today.day).subtract(
        Duration(days: i),
      );
      out.add(_formatLocalIsoDate(d));
    }

    return out;
  }

  String _formatLocalIsoDate(DateTime d) {
    final yyyy = d.year.toString().padLeft(4, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '$yyyy-$mm-$dd';
  }

  Color _barColor(int count) {
    if (count <= 3) {
      return const Color(0xFF10B981);
    }
    if (count <= 7) {
      return const Color(0xFFF59E0B);
    }
    return const Color(0xFFEF4444);
  }
}

class _ChartPoint {
  final String date;
  final int count;

  const _ChartPoint({
    required this.date,
    required this.count,
  });
}

class _ChartBarData {
  final String label;
  final double heightPct;
  final Color color;

  const _ChartBarData({
    required this.label,
    required this.heightPct,
    required this.color,
  });
}

class _ChartBar extends StatelessWidget {
  final double heightPct;
  final Color color;
  final double maxHeight;

  const _ChartBar({
    required this.heightPct,
    required this.color,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final height = maxHeight * (heightPct / 100);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: height,
          constraints: const BoxConstraints(minWidth: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x0FFFFFFF)
      ..strokeWidth = 1;

    const spacing = 28.0;
    for (double y = size.height; y >= 0; y -= spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

