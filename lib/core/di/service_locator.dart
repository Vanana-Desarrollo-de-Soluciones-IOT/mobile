import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/iam/application/internal/commandservices/authentication_command_service_impl.dart';
import 'package:mobile/iam/application/internal/queryservices/authentication_query_service_impl.dart';
import 'package:mobile/iam/domain/services/authentication.command-service.dart';
import 'package:mobile/iam/domain/services/authentication.query-service.dart';
import 'package:mobile/iam/infrastructure/api/gateways/authentication.gateway.dart';
import 'package:mobile/iam/infrastructure/api/gateways/authentication_http.gateway.dart';
import 'package:mobile/iam/infrastructure/oauth/google/google_id_token_provider.dart';
import 'package:mobile/iam/infrastructure/oauth/google/google_sign_in_id_token_provider.dart';
import 'package:mobile/iam/infrastructure/persistence/local/registration_session_local_storage.dart';
import 'package:mobile/iam/infrastructure/persistence/local/token_local_storage.dart';
import 'package:mobile/analytics/application/internal/commandservices/analytics_command_service_impl.dart';
import 'package:mobile/analytics/application/internal/queryservices/analytics_query_service_impl.dart';
import 'package:mobile/analytics/domain/services/analytics.command-service.dart';
import 'package:mobile/analytics/domain/services/analytics.query-service.dart';
import 'package:mobile/analytics/infrastructure/api/gateways/analytics.gateway.dart';
import 'package:mobile/analytics/infrastructure/api/gateways/analytics_http.gateway.dart';
import 'package:mobile/analytics/interfaces/pages/analytics_cubit.dart';
import 'package:mobile/alerts/application/internal/commandservices/alerts_command_service_impl.dart';
import 'package:mobile/alerts/application/internal/queryservices/alerts_query_service_impl.dart';
import 'package:mobile/alerts/domain/services/alerts.command-service.dart';
import 'package:mobile/alerts/domain/services/alerts.query-service.dart';
import 'package:mobile/alerts/infrastructure/api/gateways/alerts.gateway.dart';
import 'package:mobile/alerts/infrastructure/api/gateways/alerts_http.gateway.dart';
import 'package:mobile/alerts/interfaces/pages/alerts_cubit.dart';
import 'package:mobile/iam/interfaces/pages/confirm_registration/confirm_registration_cubit.dart';
import 'package:mobile/iam/interfaces/pages/login/login_cubit.dart';
import 'package:mobile/iam/interfaces/pages/register/register_cubit.dart';
import 'package:mobile/spaces/application/internal/commandservices/spaces_command_service_impl.dart';
import 'package:mobile/spaces/application/internal/queryservices/spaces_query_service_impl.dart';
import 'package:mobile/spaces/domain/services/spaces.command-service.dart';
import 'package:mobile/spaces/domain/services/spaces.query-service.dart';
import 'package:mobile/spaces/infrastructure/api/gateways/spaces.gateway.dart';
import 'package:mobile/spaces/infrastructure/api/gateways/spaces_http.gateway.dart';
import 'package:mobile/spaces/interfaces/pages/spaces_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Core
  getIt.registerLazySingleton<TokenLocalStorage>(() => TokenLocalStorage());
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(tokenStorage: getIt<TokenLocalStorage>()),
  );
  getIt.registerLazySingleton<RegistrationSessionLocalStorage>(
    () => RegistrationSessionLocalStorage(),
  );
  getIt.registerLazySingleton<GoogleSignIn>(
    () => GoogleSignIn(
      scopes: const ['email', 'profile', 'openid'],
      serverClientId: ApiConstants.googleServerClientId,
    ),
  );
  getIt.registerLazySingleton<GoogleIdTokenProvider>(
    () => GoogleSignInIdTokenProvider(getIt<GoogleSignIn>()),
  );
  getIt.registerLazySingleton<AuthenticationGateway>(
    () => AuthenticationHttpGateway(getIt<DioClient>().client),
  );

  // Application Services
  getIt.registerLazySingleton<AuthenticationCommandService>(
    () => AuthenticationCommandServiceImpl(
      getIt<AuthenticationGateway>(),
      getIt<TokenLocalStorage>(),
      getIt<RegistrationSessionLocalStorage>(),
    ),
  );

  getIt.registerLazySingleton<AuthenticationQueryService>(
    () => AuthenticationQueryServiceImpl(getIt<AuthenticationGateway>()),
  );

  // Analytics Context
  getIt.registerLazySingleton<AnalyticsGateway>(
    () => AnalyticsHttpGateway(getIt<DioClient>().client),
  );
  getIt.registerLazySingleton<AnalyticsCommandService>(
    () => AnalyticsCommandServiceImpl(getIt<AnalyticsGateway>()),
  );
  getIt.registerLazySingleton<AnalyticsQueryService>(
    () => AnalyticsQueryServiceImpl(getIt<AnalyticsGateway>()),
  );

  // Alerts Context
  getIt.registerLazySingleton<AlertsGateway>(
    () => AlertsHttpGateway(getIt<DioClient>().client),
  );
  getIt.registerLazySingleton<AlertsCommandService>(
    () => AlertsCommandServiceImpl(getIt<AlertsGateway>()),
  );
  getIt.registerLazySingleton<AlertsQueryService>(
    () => AlertsQueryServiceImpl(getIt<AlertsGateway>()),
  );

  // Spaces Context
  getIt.registerLazySingleton<SpacesGateway>(
    () => SpacesHttpGateway(getIt<DioClient>().client),
  );
  getIt.registerLazySingleton<SpacesCommandService>(
    () => SpacesCommandServiceImpl(getIt<SpacesGateway>()),
  );
  getIt.registerLazySingleton<SpacesQueryService>(
    () => SpacesQueryServiceImpl(getIt<SpacesGateway>()),
  );

  // Interface Controllers (Cubits)
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(
      getIt<AuthenticationCommandService>(),
      getIt<GoogleIdTokenProvider>(),
    ),
  );
  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(
      getIt<AuthenticationCommandService>(),
      getIt<GoogleIdTokenProvider>(),
    ),
  );
  getIt.registerFactory<ConfirmRegistrationCubit>(
    () => ConfirmRegistrationCubit(
      getIt<AuthenticationCommandService>(),
      getIt<RegistrationSessionLocalStorage>(),
    ),
  );

  getIt.registerFactory<AnalyticsCubit>(() => AnalyticsCubit());
  getIt.registerFactory<AlertsCubit>(() => AlertsCubit());
  getIt.registerFactory<SpacesCubit>(() => SpacesCubit());
}
