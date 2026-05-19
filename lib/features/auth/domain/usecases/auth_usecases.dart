import 'package:fpdart/fpdart.dart';
import '../../data/models/auth_models.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<Either<String, AuthUserEntity>> call(RegisterRequestModel request) {
    return repository.signUp(request);
  }
}

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<Either<String, AuthUserEntity>> call(SignInRequestModel request) {
    return repository.signIn(request);
  }
}

class ConfirmRegistrationUseCase {
  final AuthRepository repository;

  ConfirmRegistrationUseCase({required this.repository});

  Future<Either<String, AuthUserEntity>> call(ConfirmRegistrationRequestModel request) {
    return repository.confirmRegistration(request);
  }
}
