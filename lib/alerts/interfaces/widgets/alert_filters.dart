import 'package:flutter/material.dart';

import '../../domain/model/valueobjects/alert_status.valueobject.dart';
import '../../domain/model/valueobjects/metric_type.valueobject.dart';

class AlertFilters extends StatelessWidget {
  final AlertStatus? selectedStatus;
  final MetricType? selectedMetric;
  final ValueChanged<AlertStatus?> onStatusChanged;
  final ValueChanged<MetricType?> onMetricChanged;

  const AlertFilters({
    super.key,
    this.selectedStatus,
    this.selectedMetric,
    required this.onStatusChanged,
    required this.onMetricChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 160,
          child: DropdownButtonFormField<AlertStatus?>(
            value: selectedStatus,
            decoration: _decoration('Status'),
            dropdownColor: const Color(0xFF1C1C1E),
            iconEnabledColor: const Color(0xFF9CA3AF),
            style: const TextStyle(
              color: Color(0xFFE5E7EB),
            ),
            items: [
              const DropdownMenuItem<AlertStatus?>(
                value: null,
                child: Text(
                  'All',
                  style: TextStyle(color: Color(0xFFE5E7EB)),
                ),
              ),
              ...AlertStatus.values.map(
                    (status) => DropdownMenuItem<AlertStatus?>(
                  value: status,
                  child: Text(
                    status.apiValue,
                    style: const TextStyle(
                      color: Color(0xFFE5E7EB),
                    ),
                  ),
                ),
              ),
            ],
            onChanged: onStatusChanged,
          ),
        ),
        SizedBox(
          width: 160,
          child: DropdownButtonFormField<MetricType?>(
            value: selectedMetric,
            decoration: _decoration('Metric'),
            dropdownColor: const Color(0xFF1C1C1E),
            iconEnabledColor: const Color(0xFF9CA3AF),
            style: const TextStyle(
              color: Color(0xFFE5E7EB),
            ),
            items: [
              const DropdownMenuItem<MetricType?>(
                value: null,
                child: Text(
                  'All',
                  style: TextStyle(color: Color(0xFFE5E7EB)),
                ),
              ),
              ...MetricType.values.map(
                    (metric) => DropdownMenuItem<MetricType?>(
                  value: metric,
                  child: Text(
                    metric.label,
                    style: const TextStyle(
                      color: Color(0xFFE5E7EB),
                    ),
                  ),
                ),
              ),
            ],
            onChanged: onMetricChanged,
          ),
        ),
      ],
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFF9CA3AF),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF2C2C2E),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF4B5563),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
    );
  }
}