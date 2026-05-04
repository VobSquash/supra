import 'package:app_bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bootstrap.dart';
import 'engine/route.dart';
import 'engine/theme/supra_theme.dart';
import 'shared/widgets/glassic_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();
  runApp(const SupraTestApp());
}

class SupraTestApp extends StatefulWidget {
  const SupraTestApp({super.key});

  @override
  State<SupraTestApp> createState() => _SupraTestAppState();
}

class _SupraTestAppState extends State<SupraTestApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) {
        final bloc = appBlocSl<AuthBloc>();
        bloc.add(const AuthEvent.checkRequested());
        return bloc;
      },
      child: BlocListener<AuthBloc, AuthState>(
        // Navigate on auth transitions. Do not require ModalRoute.settings.name: it is often
        // null for onGenerateRoute-built routes, which blocked redirect from login → home.
        listenWhen: (prev, curr) {
          if (curr is AuthAuthenticated && prev is! AuthAuthenticated) {
            return true;
          }
          // Log out can go authenticated → unauthenticated; failed sign-in / session check use
          // loading → unauthenticated — sync route to login in both cases when appropriate.
          if (curr is AuthUnauthenticated &&
              (prev is AuthAuthenticated || prev is AuthLoading)) {
            // Failed sign-in already happens on the login route; replacing the stack recreates
            // [LoginPage] and clears the email field. Skip when login is already on top.
            if (prev is AuthLoading) {
              final nav = _navigatorKey.currentState;
              if (nav != null) {
                String? topRouteName;
                nav.popUntil((route) {
                  topRouteName = route.settings.name;
                  return true;
                });
                if (topRouteName == RouteNames.login) {
                  return false;
                }
              }
            }
            return true;
          }
          return false;
        },
        listener: (context, state) {
          void navigate() {
            final nav = _navigatorKey.currentState;
            if (nav == null) return;
            state.whenOrNull(
              authenticated: (_) {
                nav.pushNamedAndRemoveUntil(RouteNames.initial, (_) => false);
              },
              unauthenticated: (_) {
                nav.pushNamedAndRemoveUntil(RouteNames.login, (_) => false);
              },
            );
          }

          WidgetsBinding.instance.addPostFrameCallback((_) => navigate());
        },
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'Supra',
          theme: SupraTheme.dark,
          initialRoute: RouteNames.login,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.generateRoute,
          builder: (context, child) {
            return GlassicBackground(child: child ?? const SizedBox.shrink());
          },
        ),
      ),
    );
  }
}
