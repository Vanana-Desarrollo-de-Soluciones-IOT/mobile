import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/spaces/domain/model/queries/get_spaces.query.dart';
import 'package:mobile/spaces/interfaces/rest/resources/space_resource.resource.dart';

abstract class SpacesQueryService {
  Future<Either<Failure, List<SpaceResource>>> handleGetSpaces(
    GetSpacesQuery query,
  );
}
