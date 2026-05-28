import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/devices/domain/model/queries/get_user_organizations.query.dart';
import 'package:mobile/devices/domain/services/organizations.query-service.dart';
import 'package:mobile/devices/infrastructure/api/gateways/organizations.gateway.dart';
import 'package:mobile/devices/interfaces/rest/resources/organization_response.resource.dart';

class OrganizationsQueryServiceImpl implements OrganizationsQueryService {
  final OrganizationsGateway _gateway;

  OrganizationsQueryServiceImpl(this._gateway);

  @override
  Future<Either<Failure, List<OrganizationResponseResource>>> handleGetUserOrganizations(
    GetUserOrganizationsQuery query,
  ) async {
    try {
      final result = await _gateway.getUserOrganizations();
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
