class AnalyticsId {
  final String id;

  factory AnalyticsId(String id) {
    if (id.isEmpty) {
      throw ArgumentError('Analytics ID cannot be empty');
    }
    return AnalyticsId._(id);
  }

  const AnalyticsId._(this.id);

  @override
  String toString() => id;
}
