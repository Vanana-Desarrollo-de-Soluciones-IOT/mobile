import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/spaces/domain/model/commands/refresh_spaces.command.dart';
import 'package:mobile/spaces/domain/services/spaces.command-service.dart';
import 'package:mobile/spaces/infrastructure/api/gateways/spaces.gateway.dart';
import 'package:mobile/spaces/interfaces/rest/resources/space_resource.resource.dart';

class SpacesCommandServiceImpl implements SpacesCommandService {
  final SpacesGateway _gateway;

  SpacesCommandServiceImpl(this._gateway);

  @override
  Future<Either<Failure, List<SpaceResource>>> handleRefreshSpaces(
    RefreshSpacesCommand command,
  ) async {
    try {
      final result = await _gateway.refreshSpaces(spaceId: command.spaceId?.id);
      return Right(result);
    } catch (e) {
      return Left(Failure(_mapError(e)));
    }
  }

  String _mapError(Object error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'An unexpected error occurred';
  }
}
