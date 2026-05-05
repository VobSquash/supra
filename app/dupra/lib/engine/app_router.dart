import 'package:dupra/presentation/profile/profile_stub_page.dart';
import 'package:dupra/presentation/shell/main_shell_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
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
      GoRoute(
        path: '/profile-stub',
        name: 'profile-stub',
        builder: (context, state) => const ProfileStubPage(),
      ),
    ],
  );
}
