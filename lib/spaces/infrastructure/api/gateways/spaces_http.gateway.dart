import 'package:dio/dio.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/spaces/infrastructure/api/gateways/spaces.gateway.dart';
import 'package:mobile/spaces/interfaces/rest/resources/space_resource.resource.dart';

class SpacesHttpGateway implements SpacesGateway {
  final Dio _dio;

  SpacesHttpGateway(this._dio);

  @override
  Future<List<SpaceResource>> refreshSpaces({String? spaceId}) async {
    final response = await _dio.post(
      '${ApiConstants.apiPrefix}/spaces/refresh',
      queryParameters: spaceId != null ? {'spaceId': spaceId} : null,
    );
    final list = response.data as List<dynamic>;
    return list.map((e) => SpaceResource.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<SpaceResource>> getSpaces({String? search}) async {
    final response = await _dio.get(
      '${ApiConstants.apiPrefix}/spaces',
      queryParameters: search != null ? {'search': search} : null,
    );
    final list = response.data as List<dynamic>;
    return list.map((e) => SpaceResource.fromJson(e as Map<String, dynamic>)).toList();
  }
}
