import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/spaces/domain/model/queries/get_spaces_by_organization.query.dart';
import 'package:mobile/spaces/domain/services/spaces.query-service.dart';
import 'package:mobile/spaces/infrastructure/api/gateways/spaces.gateway.dart';
import 'package:mobile/spaces/interfaces/rest/resources/space_response.resource.dart';

class SpacesQueryServiceImpl implements SpacesQueryService {
  final SpacesGateway _gateway;

  SpacesQueryServiceImpl(this._gateway);

  @override
  Future<Either<Failure, List<SpaceResponseResource>>> handleGetSpacesByOrganization(
    GetSpacesByOrganizationQuery query,
  ) async {
    try {
      final result = await _gateway.getSpacesByOrganization(
        organizationId: query.organizationId.value,
      );
      return Right(result);
    } catch (e) {
      return Left(Failure(_mapError(e)));
    }
  }

  String _mapError(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      switch (statusCode) {
        case 401:
          return 'Session expired. Please sign in again.';
        case 403:
          return 'Access denied.';
        case 404:
          return 'Not found.';
        case 500:
        case 502:
        case 503:
          return 'Server error. Please try again later.';
        default:
          return 'Network error. Please check your connection.';
      }
    }
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'An unexpected error occurred';
  }
}
