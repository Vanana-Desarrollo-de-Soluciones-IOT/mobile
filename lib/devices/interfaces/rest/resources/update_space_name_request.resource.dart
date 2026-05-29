class UpdateSpaceNameRequestResource {
  final String name;

  const UpdateSpaceNameRequestResource({required this.name});

  Map<String, dynamic> toJson() => {'name': name};
}
