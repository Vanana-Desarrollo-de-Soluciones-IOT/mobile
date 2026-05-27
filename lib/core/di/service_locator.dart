import 'package:get_it/get_it.dart';
import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/iam/application/internal/commandservices/authentication_command_service_impl.dart';
import 'package:mobile/iam/application/internal/queryservices/authentication_query_service_impl.dart';
import 'package:mobile/iam/domain/services/authentication.command-service.dart';
import 'package:mobile/iam/domain/services/authentication.query-service.dart';
import 'package:mobile/iam/infrastructure/api/gateways/authentication.gateway.dart';
import 'package:mobile/iam/infrastructure/api/gateways/authentication_http.gateway.dart';
import 'package:mobile/iam/infrastructure/persistence/local/registration_session_local_storage.dart';
import 'package:mobile/iam/infrastructure/persistence/local/token_local_storage.dart';
import 'package:mobile/iam/interfaces/pages/confirm_registration/confirm_registration_cubit.dart';
import 'package:mobile/iam/interfaces/pages/dashboard/dashboard_cubit.dart';
import 'package:mobile/iam/interfaces/pages/login/login_cubit.dart';
import 'package:mobile/iam/interfaces/pages/register/register_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Core
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Infrastructure
  getIt.registerLazySingleton<TokenLocalStorage>(() => TokenLocalStorage());
  getIt.registerLazySingleton<RegistrationSessionLocalStorage>(
    () => RegistrationSessionLocalStorage(),
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

  // Interface Controllers (Cubits)
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(getIt<AuthenticationCommandService>()),
  );
  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(getIt<AuthenticationCommandService>()),
  );
  getIt.registerFactory<ConfirmRegistrationCubit>(
    () => ConfirmRegistrationCubit(
      getIt<AuthenticationCommandService>(),
      getIt<RegistrationSessionLocalStorage>(),
    ),
  );
  getIt.registerFactory<DashboardCubit>(
    () => DashboardCubit(
      getIt<AuthenticationCommandService>(),
      getIt<AuthenticationQueryService>(),
      getIt<TokenLocalStorage>(),
    ),
  );
}
