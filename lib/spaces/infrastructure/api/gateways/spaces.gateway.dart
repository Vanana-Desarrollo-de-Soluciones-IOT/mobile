import 'package:mobile/spaces/interfaces/rest/resources/space_resource.resource.dart';

abstract class SpacesGateway {
  Future<List<SpaceResource>> refreshSpaces({String? spaceId});

  Future<List<SpaceResource>> getSpaces({String? search});
}
