import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../data/models/auth_models.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final ConfirmRegistrationUseCase confirmRegistrationUseCase;

  AuthBloc({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.confirmRegistrationUseCase,
  }) : super(const AuthState()) {
    on<TermsToggled>(_onTermsToggled);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<ConfirmRegistrationSubmitted>(_onConfirmRegistrationSubmitted);
  }

  void _onTermsToggled(TermsToggled event, Emitter<AuthState> emit) {
    emit(state.copyWith(termsAccepted: event.accepted));
  }

  Future<void> _onRegisterSubmitted(RegisterSubmitted event, Emitter<AuthState> emit) async {
    if (!state.termsAccepted) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: 'Debe aceptar los términos y condiciones',
      ));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    final request = RegisterRequestModel(email: event.email, password: event.password);
    final result = await registerUseCase(request);

    result.fold(
      (error) => emit(state.copyWith(status: AuthStatus.failure, errorMessage: error)),
      (user) {
        // Guardamos email y password temporalmente para el auto-login posterior
        emit(state.copyWith(
          status: AuthStatus.success,
          user: user,
          registrationEmail: event.email,
          registrationPassword: event.password,
        ));
      },
    );
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final request = SignInRequestModel(email: event.email, password: event.password);
    final result = await loginUseCase(request);

    result.fold(
      (error) => emit(state.copyWith(status: AuthStatus.failure, errorMessage: error)),
      (user) => emit(state.copyWith(status: AuthStatus.success, user: user)),
    );
  }

  Future<void> _onConfirmRegistrationSubmitted(ConfirmRegistrationSubmitted event, Emitter<AuthState> emit) async {
    if (state.user?.sessionId == null) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: 'Session ID not found'));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    final request = ConfirmRegistrationRequestModel(
      sessionId: state.user!.sessionId!,
      verificationCode: event.verificationCode,
    );
    final result = await confirmRegistrationUseCase(request);

    await result.fold(
      (error) async => emit(state.copyWith(status: AuthStatus.failure, errorMessage: error)),
      (user) async {
        // Si tenemos las credenciales guardadas, realizamos el login automático
        if (state.registrationEmail != null && state.registrationPassword != null) {
          final loginRequest = SignInRequestModel(
            email: state.registrationEmail!,
            password: state.registrationPassword!,
          );
          final loginResult = await loginUseCase(loginRequest);

          loginResult.fold(
            (error) => emit(state.copyWith(status: AuthStatus.failure, errorMessage: 'Confirmado, pero el login falló: $error')),
            (loggedInUser) => emit(state.copyWith(
              status: AuthStatus.success,
              user: loggedInUser,
              // Limpiamos las credenciales temporales
              registrationEmail: null,
              registrationPassword: null,
            )),
          );
        } else {
          emit(state.copyWith(status: AuthStatus.success, user: user));
        }
      },
    );
  }
}
