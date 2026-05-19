import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_models.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserEntity> signUp(RegisterRequestModel request);
  Future<AuthUserEntity> signIn(SignInRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthUserEntity> signUp(RegisterRequestModel request) async {
    try {
      final response = await apiClient.dio.post(
        '/api/v1/auth/sign-up',
        data: request.toJson(),
      );
      
      // Response gives sessionId: { "sessionId": "...", "message": "..." }
      // We will map this to AuthUserEntity with sessionId
      return AuthUserEntity(
        id: '', // Not provided yet
        email: request.email,
        sessionId: response.data['sessionId'],
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to sign up');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  @override
  Future<AuthUserEntity> signIn(SignInRequestModel request) async {
    try {
      final response = await apiClient.dio.post(
        '/api/v1/auth/sign-in',
        data: request.toJson(),
      );
      
      return AuthUserEntity.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to sign in');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }
}
