import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class RegisterSubmitted extends AuthEvent {
  final String email;
  final String password;

  const RegisterSubmitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class TermsToggled extends AuthEvent {
  final bool accepted;

  const TermsToggled(this.accepted);

  @override
  List<Object> get props => [accepted];
}

class ConfirmRegistrationSubmitted extends AuthEvent {
  final String verificationCode;

  const ConfirmRegistrationSubmitted({required this.verificationCode});

  @override
  List<Object> get props => [verificationCode];
}
