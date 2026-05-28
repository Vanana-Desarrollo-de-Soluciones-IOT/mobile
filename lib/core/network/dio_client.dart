import 'package:dio/dio.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/iam/infrastructure/auth_session.dart';
import 'package:mobile/iam/infrastructure/persistence/local/token_local_storage.dart';

class DioClient {
  late final Dio _dio;
  final TokenLocalStorage _tokenStorage;

  DioClient({required TokenLocalStorage tokenStorage}) : _tokenStorage = tokenStorage {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshed = await _attemptRefresh();
            if (refreshed) {
              final newToken = await _tokenStorage.getAccessToken();
              if (newToken != null && newToken.isNotEmpty) {
                error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                try {
                  final response = await _dio.fetch(error.requestOptions);
                  return handler.resolve(response);
                } catch (_) {
                  // fall through to propagate error
                }
              }
            }
            // Refresh failed or retry failed -> force logout
            await _tokenStorage.clearAll();
            AuthSession().setAuthenticated(false);
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> _attemptRefresh() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final response = await refreshDio.post(
        '${ApiConstants.authBase}/refresh',
        data: {'refreshToken': refreshToken},
      );

      final data = response.data as Map<String, dynamic>;
      final newAccess = data['token'] as String?;
      final newRefresh = data['refreshToken'] as String?;

      if (newAccess != null && newRefresh != null) {
        await _tokenStorage.saveTokens(
          accessToken: newAccess,
          refreshToken: newRefresh,
        );
        return true;
      }
    } catch (_) {
      // ignore refresh errors
    }
    return false;
  }

  Dio get client => _dio;
}
