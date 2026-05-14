import 'package:app_bloc/app_bloc.dart';
import 'package:dupra/engine/app_router.dart';
import 'package:dupra/engine/go_router_refresh_stream.dart';
import 'package:dupra/engine/theme/dupra_theme.dart';
import 'package:dupra/engine/users_bloc_creator.dart';
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
  late final UsersBloc _usersBloc = createUsersBloc();
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
          if (curr.maybeWhen(unauthenticated: (_) => true, orElse: () => false)) {
            return true;
          }
          // Reload profile on every authenticated emission (including refreshed SessionSnapshot),
          // not only when crossing the logged-out → logged-in boundary — cold start / token refresh
          // can otherwise leave chrome stale if the first profile fetch failed quietly.
          return curr.maybeWhen(authenticated: (_) => true, orElse: () => false);
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
          debugShowCheckedModeBanner: false,
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
