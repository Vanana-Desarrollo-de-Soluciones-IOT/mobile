import 'package:fpdart/fpdart.dart';
import '../../data/models/auth_models.dart';

abstract class AuthRepository {
  Future<Either<String, AuthUserEntity>> signUp(RegisterRequestModel request);
  Future<Either<String, AuthUserEntity>> signIn(SignInRequestModel request);
  Future<Either<String, AuthUserEntity>> confirmRegistration(ConfirmRegistrationRequestModel request);
}
