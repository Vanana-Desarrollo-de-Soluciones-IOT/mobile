class SpaceId {
  final String id;

  factory SpaceId(String id) {
    if (id.isEmpty) {
      throw ArgumentError('Space ID cannot be empty');
    }
    return SpaceId._(id);
  }

  const SpaceId._(this.id);

  @override
  String toString() => id;
}
