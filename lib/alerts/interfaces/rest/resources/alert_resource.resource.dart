class AlertResource {
  final String id;
  final String title;
  final String description;
  final String severity;
  final bool acknowledged;
  final String timestamp;

  const AlertResource({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.acknowledged,
    required this.timestamp,
  });

  factory AlertResource.fromJson(Map<String, dynamic> json) {
    return AlertResource(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      severity: json['severity'] as String,
      acknowledged: json['acknowledged'] as bool,
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'severity': severity,
        'acknowledged': acknowledged,
        'timestamp': timestamp,
      };
}
