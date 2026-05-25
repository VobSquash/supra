import 'package:app_bloc/app_bloc.dart';

import 'kali_admin_eligibility.dart';
import 'nav_items.dart';

/// Maps current [AuthBloc] state + URL location to redirect target (`null` = no redirect).
String? redirectForAuth(AuthState auth, String location) {
  final path = normalizedRoutePath(location);

  if (auth is AuthInitial || auth is AuthLoading) {
    if (path == '/login' || path == '/splash') return null;
    return '/splash';
  }
  return auth.maybeWhen(
    authenticated: (_) {
      if (path == '/login' || path == '/splash') return '/';
      if (!kaliAuthIsAdminOrElevated(auth) && path == kaliAdminBookingsPath) {
        return '/bookings';
      }
      return null;
    },
    unauthenticated: (_) {
      // Keep login so the user sees errors / can retry without a redirect ping-pong.
      if (path == '/login') return null;
      // Splash is only for AuthInitial / loading; once we know there's no session, go sign in.
      if (path == '/splash') return '/login';
      return '/login';
    },
    orElse: () => null,
  );
}
