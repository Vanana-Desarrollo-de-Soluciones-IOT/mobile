import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/routing/app_router.dart';
import 'package:mobile/iam/infrastructure/auth_session.dart';
import 'package:mobile/iam/infrastructure/persistence/local/token_local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  setupServiceLocator();

  await _restoreSession();

  runApp(const MyApp());
}

Future<void> _restoreSession() async {
  final tokenStorage = getIt<TokenLocalStorage>();
  final token = await tokenStorage.getAccessToken();
  if (token == null || token.isEmpty) {
    AuthSession().setAuthenticated(false);
    return;
  }

  try {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    final response = await dio.get(
      '${ApiConstants.authBase}/verify',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    final data = response.data as Map<String, dynamic>;
    final isValid = data['isValid'] as bool? ?? false;

    if (isValid) {
      AuthSession().setAuthenticated(true);
    } else {
      await tokenStorage.clearAll();
      AuthSession().setAuthenticated(false);
    }
  } catch (_) {
    await tokenStorage.clearAll();
    AuthSession().setAuthenticated(false);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ClairCore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          onPrimary: Colors.black,
          surface: Color(0xFF121212),
          onSurface: Colors.white,
        ),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
