import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/devices/domain/model/commands/create_organization.command.dart';
import 'package:mobile/devices/interfaces/rest/resources/organization_response.resource.dart';

abstract class OrganizationsCommandService {
  Future<Either<Failure, OrganizationResponseResource>> handleCreateOrganization(
    CreateOrganizationCommand command,
  );
}
