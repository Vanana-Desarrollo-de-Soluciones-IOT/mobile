class OrganizationResponseResource {
  final String id;
  final String name;
  final String ownerUserId;
  final String createdAt;
  final String updatedAt;

  const OrganizationResponseResource({
    required this.id,
    required this.name,
    required this.ownerUserId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrganizationResponseResource.fromJson(Map<String, dynamic> json) {
    return OrganizationResponseResource(
      id: json['id'] as String,
      name: json['name'] as String,
      ownerUserId: json['ownerUserId'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }
}
