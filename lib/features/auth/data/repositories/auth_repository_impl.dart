import 'package:fpdart/fpdart.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_models.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, AuthUserEntity>> signUp(RegisterRequestModel request) async {
    try {
      final result = await remoteDataSource.signUp(request);
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Future<Either<String, AuthUserEntity>> signIn(SignInRequestModel request) async {
    try {
      final result = await remoteDataSource.signIn(request);
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
