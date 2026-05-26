import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/iam/infrastructure/persistence/local/token_local_storage.dart';
import 'package:mobile/iam/interfaces/pages/confirm_registration/confirm_registration_cubit.dart';
import 'package:mobile/iam/interfaces/pages/confirm_registration/confirm_registration_screen.dart';
import 'package:mobile/iam/interfaces/pages/dashboard/dashboard_cubit.dart';
import 'package:mobile/iam/interfaces/pages/dashboard/dashboard_screen.dart';
import 'package:mobile/iam/interfaces/pages/login/login_cubit.dart';
import 'package:mobile/iam/interfaces/pages/login/login_screen.dart';
import 'package:mobile/iam/interfaces/pages/register/register_cubit.dart';
import 'package:mobile/iam/interfaces/pages/register/register_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _tokenStorage = getIt<TokenLocalStorage>();

  static GoRouter get router => GoRouter(
        navigatorKey: _rootNavigatorKey,
        redirect: (context, state) async {
          final isAuthenticated = await _tokenStorage.hasToken();
          final isAuthRoute = state.matchedLocation == '/login' ||
              state.matchedLocation == '/register' ||
              state.matchedLocation == '/confirm-registration';

          if (!isAuthenticated && !isAuthRoute) {
            return '/login';
          }

          if (isAuthenticated && isAuthRoute) {
            return '/dashboard';
          }

          return null;
        },
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => BlocProvider(
              create: (_) => getIt<LoginCubit>(),
              child: const LoginScreen(),
            ),
          ),
          GoRoute(
            path: '/register',
            builder: (context, state) => BlocProvider(
              create: (_) => getIt<RegisterCubit>(),
              child: const RegisterScreen(),
            ),
          ),
          GoRoute(
            path: '/confirm-registration',
            builder: (context, state) {
              final sessionId = state.extra as String?;
              return BlocProvider(
                create: (_) => getIt<ConfirmRegistrationCubit>(),
                child: ConfirmRegistrationScreen(sessionId: sessionId),
              );
            },
          ),
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => BlocProvider(
              create: (_) => getIt<DashboardCubit>(),
              child: const DashboardScreen(),
            ),
          ),
        ],
      );
}
