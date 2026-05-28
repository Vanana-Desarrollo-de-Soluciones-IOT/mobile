import 'package:mobile/devices/domain/model/commands/create_organization.command.dart';
import 'package:mobile/devices/interfaces/rest/resources/create_organization_request.resource.dart';

CreateOrganizationRequestResource toCreateOrganizationRequestResource(
  CreateOrganizationCommand command,
) {
  return CreateOrganizationRequestResource(name: command.name.value);
}
