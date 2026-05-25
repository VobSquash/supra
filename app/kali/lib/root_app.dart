import 'dart:async';

import 'package:app_bloc/app_bloc.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:middleware/middleware.dart';

import 'components/admin_layout.dart';
import 'navigation/auth_route_guard.dart';
import 'pages/admin_bookings_page.dart';
import 'pages/bookings_page.dart';
import 'pages/fixtures_page.dart';
import 'pages/home.dart';
import 'pages/ladder_page.dart';
import 'pages/login_page.dart';
import 'pages/splash_page.dart';
import 'pages/users_page.dart';

/// Subscribes to [AuthBloc] so [Router.redirect] picks up login/logout without a Flutter GoRouter refresh stream.
class RootApp extends StatefulComponent {
  const RootApp({super.key});

  @override
  State<StatefulComponent> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  late final AuthBloc _bloc;
  StreamSubscription<AuthState>? _sub;
  var _generation = 0;

  @override
  void initState() {
    super.initState();
    _bloc = middlewareSl<AuthBloc>();
    _sub = _bloc.stream.listen((_) {
      if (!mounted) return;
      setState(() => _generation++);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return div(classes: 'main', [
      Router(
        key: Key('routes$_generation'),
        redirect: (ctx, rs) => redirectForAuth(_bloc.state, rs.location),
        routes: [
          Route(path: '/splash', builder: (_, __) => const SplashPage()),
          Route(path: '/login', builder: (_, __) => const LoginPage()),
          ShellRoute(
            builder: (ctx, rs, child) => Component.fragment([
              AdminLayout(child: child),
            ]),
            routes: [
              Route(path: '/', title: 'Home', builder: (_, __) => const Home()),
              Route(path: '/bookings', title: 'Bookings', builder: (_, __) => const BookingsPage()),
              Route(path: '/admin-bookings', title: 'Admin bookings', builder: (_, __) => const AdminBookingsPage()),
              Route(path: '/users', title: 'Users', builder: (_, __) => const UsersPage()),
              Route(path: '/fixtures', title: 'Fixtures', builder: (_, __) => const FixturesPage()),
              Route(path: '/ladder', title: 'Ladder', builder: (_, __) => const LadderPage()),
            ],
          ),
        ],
      ),
    ]);
  }
}
