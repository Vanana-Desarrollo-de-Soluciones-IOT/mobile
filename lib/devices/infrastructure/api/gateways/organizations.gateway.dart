import 'package:mobile/devices/interfaces/rest/resources/create_organization_request.resource.dart';
import 'package:mobile/devices/interfaces/rest/resources/organization_response.resource.dart';

abstract class OrganizationsGateway {
  Future<OrganizationResponseResource> createOrganization(
    CreateOrganizationRequestResource resource,
  );

  Future<List<OrganizationResponseResource>> getUserOrganizations();
}
