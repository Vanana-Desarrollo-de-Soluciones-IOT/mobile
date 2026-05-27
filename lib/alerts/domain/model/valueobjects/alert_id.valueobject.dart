class AlertId {
  final String id;

  factory AlertId(String id) {
    if (id.isEmpty) {
      throw ArgumentError('Alert ID cannot be empty');
    }
    return AlertId._(id);
  }

  const AlertId._(this.id);

  @override
  String toString() => id;
}
