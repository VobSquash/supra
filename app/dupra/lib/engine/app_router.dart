import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dupra/engine/go_router_refresh_stream.dart';
import 'package:dupra/engine/shell_locations.dart';
import 'package:dupra/presentation/auth/login_page.dart';
import 'package:dupra/presentation/calculator/fridge_calculator_page.dart';
import 'package:dupra/presentation/profile/profile_stub_page.dart';
import 'package:dupra/presentation/shell/main_shell_page.dart';
import 'package:dupra/presentation/splash/splash_page.dart';
import 'package:dupra/presentation/users/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<void> _fadePage({
  required LocalKey key,
  required Widget child,
  Duration duration = const Duration(milliseconds: 280),
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: duration,
  );
}

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
          pageBuilder: (context, state) => _fadePage(
            key: state.pageKey,
            child: const SplashPage(),
            duration: const Duration(milliseconds: 200),
          ),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          pageBuilder: (context, state) => _fadePage(
            key: state.pageKey,
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          path: '/:suite/:tab',
          name: 'shell-tab',
          redirect: (context, state) {
            final suite = state.pathParameters['suite'] ?? '';
            final tab = state.pathParameters['tab'] ?? '';
            if (!ShellLocations.isValidSuite(suite) || !ShellLocations.isValidTab(suite, tab)) {
              return ShellLocations.defaultMember;
            }
            if (suite == 'a') {
              final profile = context.read<UsersBloc>().state.currentUserProfile;
              final typeStr = profile?.profileType?.trim();
              final profileOk = typeStr != null && typeStr.isNotEmpty && ProfileTypeEnum.get(typeStr).isAdminOrElevated;

              final auth = context.read<AuthBloc>().state;
              final sessionOk = auth.maybeWhen(
                authenticated: (snap) {
                  final id = snap.profileTypeId;
                  if (id == null) {
                    return false;
                  }
                  return ProfileTypeEnum.get(id).isAdminOrElevated;
                },
                orElse: () => false,
              );
              if (!profileOk && !sessionOk) {
                return ShellLocations.defaultMember;
              }
            }
            return null;
          },
          pageBuilder: (context, state) => _fadePage(
            key: const ValueKey<String>('dupra-main-shell'),
            child: const MainShellPage(),
          ),
        ),
        GoRoute(
          path: '/profile-stub',
          name: 'profile-stub',
          pageBuilder: (context, state) => _fadePage(
            key: state.pageKey,
            child: const ProfileStubPage(),
          ),
        ),
        GoRoute(
          path: '/users',
          name: 'users',
          pageBuilder: (context, state) => _fadePage(
            key: state.pageKey,
            child: const UsersPage(),
            duration: const Duration(milliseconds: 480),
          ),
        ),
        GoRoute(
          path: '/calculator',
          name: 'calculator',
          pageBuilder: (context, state) => _fadePage(
            key: state.pageKey,
            child: const FridgeCalculatorPage(),
            duration: const Duration(milliseconds: 480),
          ),
        ),
      ],
    );
  }

  /// Maps [AuthState] + path to a redirect location, or `null` to stay.
  ///
  /// **Unauthenticated users:** only `/login` is shown as-is. Any other location
  /// (shell tabs, deep links, bookmarks, `/users`, etc.) redirects to `/login`.
  /// That is separate from **admin** checks on `/a/...`, which run on the
  /// [shell-tab] route and only gate elevated roles — not whether you are signed in.
  static String? _redirectForAuth(AuthState auth, String location) {
    final onSplash = location == '/splash';
    final onLogin = location == '/login';

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
        if (onSplash || onLogin) return ShellLocations.defaultMember;
        if (location == '/') return ShellLocations.defaultMember;
        return null;
      },
      unauthenticated: (_) {
        if (onLogin) return null;
        return '/login';
      },
    );
  }
}
