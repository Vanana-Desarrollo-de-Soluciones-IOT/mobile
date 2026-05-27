import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/spaces/domain/model/commands/refresh_spaces.command.dart';
import 'package:mobile/spaces/interfaces/rest/resources/space_resource.resource.dart';

abstract class SpacesCommandService {
  Future<Either<Failure, List<SpaceResource>>> handleRefreshSpaces(
    RefreshSpacesCommand command,
  );
}
