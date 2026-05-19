import 'package:get_it/get_it.dart';
import '../core/network/api_client.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/auth_usecases.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Core
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => RegisterUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => LoginUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => ConfirmRegistrationUseCase(repository: getIt()));

  // BLoC
  getIt.registerFactory(
    () => AuthBloc(
      registerUseCase: getIt(),
      loginUseCase: getIt(),
      confirmRegistrationUseCase: getIt(),
    ),
  );
}
