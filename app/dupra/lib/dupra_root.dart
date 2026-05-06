import 'package:app_bloc/app_bloc.dart';
import 'package:dupra/engine/app_router.dart';
import 'package:dupra/engine/go_router_refresh_stream.dart';
import 'package:dupra/engine/theme/dupra_theme.dart';
import 'package:dupra/presentation/widgets/glassic_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Holds the root [GoRouter], auth refresh listening, and [BlocProvider]s.
class DupraRoot extends StatefulWidget {
  const DupraRoot({super.key});

  @override
  State<DupraRoot> createState() => _DupraRootState();
}

class _DupraRootState extends State<DupraRoot> {
  late final AuthBloc _authBloc = appBlocSl<AuthBloc>();
  late final UsersBloc _usersBloc = appBlocSl<UsersBloc>();
  late final GoRouterRefreshStream _routerRefresh = GoRouterRefreshStream(_authBloc.stream);
  late final GoRouter _router = AppRouter.create(authBloc: _authBloc, refresh: _routerRefresh);

  @override
  void dispose() {
    _routerRefresh.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<UsersBloc>.value(value: _usersBloc),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prev, curr) {
          bool authed(AuthState s) =>
              s.maybeWhen(authenticated: (_) => true, orElse: () => false);
          return authed(curr) != authed(prev);
        },
        listener: (context, state) {
          state.maybeWhen(
            authenticated: (_) {
              context.read<UsersBloc>().add(const UsersEvent.loadCurrentUserProfile());
            },
            unauthenticated: (_) {
              context.read<UsersBloc>().add(const UsersEvent.reset());
            },
            orElse: () {},
          );
        },
        child: MaterialApp.router(
          title: 'Dupra',
          theme: DupraTheme.dark,
          routerConfig: _router,
          builder: (context, child) {
            return GlassicBackground(child: child ?? const SizedBox.shrink());
          },
        ),
      ),
    );
  }
}
