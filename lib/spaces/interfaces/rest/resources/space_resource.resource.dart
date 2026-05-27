class SpaceResource {
  final String id;
  final String name;
  final String location;
  final int deviceCount;
  final String status;

  const SpaceResource({
    required this.id,
    required this.name,
    required this.location,
    required this.deviceCount,
    required this.status,
  });

  factory SpaceResource.fromJson(Map<String, dynamic> json) {
    return SpaceResource(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      deviceCount: json['deviceCount'] as int,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
        'deviceCount': deviceCount,
        'status': status,
      };
}
