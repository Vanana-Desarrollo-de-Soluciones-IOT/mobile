import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['CLAIR_BACKEND_BASE_URL']!;

  static const String apiPrefix = '/api/v1';
  static const String authBase = '$apiPrefix/auth';
}
