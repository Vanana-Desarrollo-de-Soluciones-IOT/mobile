import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/spaces/domain/model/commands/create_space.command.dart';
import 'package:mobile/spaces/domain/model/commands/delete_space.command.dart';
import 'package:mobile/spaces/domain/model/commands/update_space_name.command.dart';
import 'package:mobile/spaces/interfaces/rest/resources/space_response.resource.dart';

abstract class SpacesCommandService {
  Future<Either<Failure, SpaceResponseResource>> handleCreateSpace(
    CreateSpaceCommand command,
  );

  Future<Either<Failure, void>> handleDeleteSpace(
    DeleteSpaceCommand command,
  );

  Future<Either<Failure, void>> handleUpdateSpaceName(
    UpdateSpaceNameCommand command,
  );
}
