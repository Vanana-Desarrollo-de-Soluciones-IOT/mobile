import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/iam/domain/model/commands/initiate_registration.command.dart';
import 'package:mobile/iam/domain/model/valueobjects/email_address.valueobject.dart';
import 'package:mobile/iam/domain/model/valueobjects/password.valueobject.dart';
import 'package:mobile/iam/domain/services/authentication.command-service.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthenticationCommandService _commandService;

  RegisterCubit(this._commandService) : super(const RegisterState());

  Future<void> initiateRegistration({required String email, required String password}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final emailVo = EmailAddress(email);
      final passwordVo = Password(password);
      final command = InitiateRegistrationCommand(email: emailVo, password: passwordVo);

      final result = await _commandService.handleInitiateRegistration(command);

      result.fold(
        (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
        (resource) => emit(state.copyWith(isLoading: false, sessionId: resource.sessionId)),
      );
    } on ArgumentError catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message as String?));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
