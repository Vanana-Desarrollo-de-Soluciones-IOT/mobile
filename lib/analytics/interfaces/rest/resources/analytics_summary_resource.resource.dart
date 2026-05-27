class AnalyticsSummaryResource {
  final String id;
  final String metric;
  final double value;
  final String unit;
  final String timestamp;

  const AnalyticsSummaryResource({
    required this.id,
    required this.metric,
    required this.value,
    required this.unit,
    required this.timestamp,
  });

  factory AnalyticsSummaryResource.fromJson(Map<String, dynamic> json) {
    return AnalyticsSummaryResource(
      id: json['id'] as String,
      metric: json['metric'] as String,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'metric': metric,
        'value': value,
        'unit': unit,
        'timestamp': timestamp,
      };
}
