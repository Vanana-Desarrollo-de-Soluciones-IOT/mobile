import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../data/models/auth_models.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;

  AuthBloc({
    required this.registerUseCase,
    required this.loginUseCase,
  }) : super(const AuthState()) {
    on<TermsToggled>(_onTermsToggled);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<LoginSubmitted>(_onLoginSubmitted);
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
      (user) => emit(state.copyWith(status: AuthStatus.success, user: user)),
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
}
