part of 'register_cubit.dart';

class RegisterState {
  final bool isLoading;
  final String? errorMessage;
  final String? sessionId;

  const RegisterState({
    this.isLoading = false,
    this.errorMessage,
    this.sessionId,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? sessionId,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      sessionId: sessionId ?? this.sessionId,
    );
  }
}
