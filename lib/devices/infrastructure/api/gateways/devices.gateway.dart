abstract class DevicesGateway {
  Future<int> getDeviceCountBySpace(String spaceId);

  Future<Map<String, dynamic>> getDevicesBySpaceRaw({
    required String spaceId,
    int page = 0,
    int size = 20,
  });
}
