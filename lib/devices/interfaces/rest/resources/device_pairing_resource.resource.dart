class DevicePairingResourceResource {
  final String deviceId;
  final String? claimToken;

  const DevicePairingResourceResource({
    required this.deviceId,
    required this.claimToken,
  });

  factory DevicePairingResourceResource.fromJson(Map<String, dynamic> json) {
    return DevicePairingResourceResource(
      deviceId: (json['deviceId'] ?? '').toString(),
      claimToken: json['claimToken']?.toString(),
    );
  }
}
