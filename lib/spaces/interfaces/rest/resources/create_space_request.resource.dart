class CreateSpaceRequestResource {
  final String name;

  const CreateSpaceRequestResource({required this.name});

  Map<String, dynamic> toJson() => {'name': name};
}
