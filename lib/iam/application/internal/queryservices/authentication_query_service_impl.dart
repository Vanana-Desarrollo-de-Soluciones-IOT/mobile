import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/failure.dart';
import 'package:mobile/iam/domain/model/queries/verify_token.query.dart';
import 'package:mobile/iam/domain/services/authentication.query-service.dart';
import 'package:mobile/iam/infrastructure/api/gateways/authentication.gateway.dart';
import 'package:mobile/iam/interfaces/rest/resources/token_verification_resource.resource.dart';

class AuthenticationQueryServiceImpl implements AuthenticationQueryService {
  final AuthenticationGateway _gateway;

  AuthenticationQueryServiceImpl(this._gateway);

  @override
  Future<Either<Failure, TokenVerificationResource>> handleVerifyToken(
    VerifyTokenQuery query,
  ) async {
    try {
      final result = await _gateway.verifyToken(query.accessToken.token);
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
