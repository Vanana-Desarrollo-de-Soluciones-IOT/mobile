import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/devices/domain/model/queries/get_spaces_by_organization.query.dart';
import 'package:mobile/devices/interfaces/rest/resources/space_response.resource.dart';

abstract class SpacesQueryService {
  Future<Either<Failure, List<SpaceResponseResource>>> handleGetSpacesByOrganization(
    GetSpacesByOrganizationQuery query,
  );

  Future<Either<Failure, SpaceResponseResource>> handleGetSpaceById(String spaceId);
}
