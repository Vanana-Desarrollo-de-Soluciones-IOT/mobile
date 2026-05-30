import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/devices/domain/model/queries/get_user_organizations.query.dart';
import 'package:mobile/devices/interfaces/rest/resources/organization_response.resource.dart';

abstract class OrganizationsQueryService {
  Future<Either<Failure, List<OrganizationResponseResource>>> handleGetUserOrganizations(
    GetUserOrganizationsQuery query,
  );

  Future<Either<Failure, OrganizationResponseResource>> handleGetOrganizationById(String organizationId);
}
