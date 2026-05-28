import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/devices/domain/model/commands/create_organization.command.dart';
import 'package:mobile/devices/domain/services/organizations.command-service.dart';
import 'package:mobile/devices/infrastructure/api/gateways/organizations.gateway.dart';
import 'package:mobile/devices/interfaces/rest/resources/organization_response.resource.dart';
import 'package:mobile/devices/interfaces/rest/transform/organizations_transform.dart';

class OrganizationsCommandServiceImpl implements OrganizationsCommandService {
  final OrganizationsGateway _gateway;

  OrganizationsCommandServiceImpl(this._gateway);

  @override
  Future<Either<Failure, OrganizationResponseResource>> handleCreateOrganization(
    CreateOrganizationCommand command,
  ) async {
    try {
      final resource = toCreateOrganizationRequestResource(command);
      final result = await _gateway.createOrganization(resource);
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
