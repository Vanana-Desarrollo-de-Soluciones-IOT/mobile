class AlertResponseResource {
  final String id;
  final String deviceId;
  final String? spaceId;
  final String? spaceName;
  final String? deviceName;
  final String metric;
  final String metricLabel;
  final String metricUnit;
  final num thresholdValue;
  final num actualValue;
  final String message;
  final String status;
  final String severity;
  final String occurredAt;
  final String? resolvedAt;
  final String createdAt;

  AlertResponseResource({
    required this.id,
    required this.deviceId,
    this.spaceId,
    this.spaceName,
    this.deviceName,
    required this.metric,
    required this.metricLabel,
    required this.metricUnit,
    required this.thresholdValue,
    required this.actualValue,
    required this.message,
    required this.status,
    required this.severity,
    required this.occurredAt,
    this.resolvedAt,
    required this.createdAt,
  });
}
