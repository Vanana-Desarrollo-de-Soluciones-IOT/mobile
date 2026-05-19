import 'package:equatable/equatable.dart';
import '../../data/models/auth_models.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthUserEntity? user;
  final String? errorMessage;
  final bool termsAccepted;
  final String? registrationEmail;
  final String? registrationPassword;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.termsAccepted = false,
    this.registrationEmail,
    this.registrationPassword,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthUserEntity? user,
    String? errorMessage,
    bool? termsAccepted,
    String? registrationEmail,
    String? registrationPassword,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      registrationEmail: registrationEmail ?? this.registrationEmail,
      registrationPassword: registrationPassword ?? this.registrationPassword,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        errorMessage,
        termsAccepted,
        registrationEmail,
        registrationPassword,
      ];
}
