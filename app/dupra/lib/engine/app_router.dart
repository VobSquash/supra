import 'package:app_bloc/app_bloc.dart';
import 'package:dupra/engine/go_router_refresh_stream.dart';
import 'package:dupra/presentation/auth/login_page.dart';
import 'package:dupra/presentation/calculator/fridge_calculator_page.dart';
import 'package:dupra/presentation/profile/profile_stub_page.dart';
import 'package:dupra/presentation/shell/main_shell_page.dart';
import 'package:dupra/presentation/splash/splash_page.dart';
import 'package:dupra/presentation/users/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRouter {
  /// Auth-aware router; [refresh] must be disposed with [GoRouter.dispose].
  static GoRouter create({required AuthBloc authBloc, required GoRouterRefreshStream refresh}) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: refresh,
      redirect: (context, state) {
        final auth = context.read<AuthBloc>().state;
        return _redirectForAuth(auth, state.matchedLocation);
      },
      routes: [
        GoRoute(
          path: '/splash',
          name: 'splash',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const SplashPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 200),
          ),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const LoginPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 280),
          ),
        ),
        GoRoute(
          path: '/',
          name: 'shell',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const MainShellPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 280),
          ),
        ),
        GoRoute(path: '/profile-stub', name: 'profile-stub', builder: (context, state) => const ProfileStubPage()),
        GoRoute(
          path: '/users',
          name: 'users',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const UsersPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 480),
          ),
        ),
        GoRoute(
          path: '/calculator',
          name: 'calculator',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const FridgeCalculatorPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 480),
          ),
        ),
        //builder: (context, state) => const UsersPage(),),
      ],
    );
  }

  /// Maps [AuthState] + path to a redirect location, or `null` to stay.
  static String? _redirectForAuth(AuthState auth, String location) {
    final onSplash = location == '/splash';
    final onLogin = location == '/login';
    final protected = location == '/' || location.startsWith('/profile');

    return auth.map(
      initial: (_) {
        if (onLogin) return null;
        return onSplash ? null : '/splash';
      },
      loading: (_) {
        if (onLogin) return null;
        return onSplash ? null : '/splash';
      },
      authenticated: (_) {
        if (onSplash || onLogin) return '/';
        return null;
      },
      unauthenticated: (_) {
        if (protected) return '/login';
        if (onSplash) return '/login';
        return null;
      },
    );
  }
}
