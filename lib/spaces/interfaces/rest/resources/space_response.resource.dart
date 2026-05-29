class SpaceResponseResource {
  final String id;
  final String name;
  final String organizationId;
  final String ownerUserId;
  final String createdAt;
  final String updatedAt;

  const SpaceResponseResource({
    required this.id,
    required this.name,
    required this.organizationId,
    required this.ownerUserId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SpaceResponseResource.fromJson(Map<String, dynamic> json) {
    return SpaceResponseResource(
      id: json['id'] as String,
      name: json['name'] as String,
      organizationId: json['organizationId'] as String,
      ownerUserId: json['ownerUserId'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }
}
