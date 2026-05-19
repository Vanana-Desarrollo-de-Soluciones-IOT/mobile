class RegisterRequestModel {
  final String email;
  final String password;

  RegisterRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class SignInRequestModel {
  final String email;
  final String password;

  SignInRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class AuthUserEntity {
  final String id;
  final String email;
  final String? token;
  final String? refreshToken;
  final String? sessionId; // used for registration initiation

  AuthUserEntity({
    required this.id,
    required this.email,
    this.token,
    this.refreshToken,
    this.sessionId,
  });

  factory AuthUserEntity.fromJson(Map<String, dynamic> json) {
    return AuthUserEntity(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      token: json['token'],
      refreshToken: json['refreshToken'],
      sessionId: json['sessionId'],
    );
  }
}
