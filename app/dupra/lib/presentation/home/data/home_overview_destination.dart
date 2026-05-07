import 'package:dupra/engine/member_shell_tab.dart';

/// Targets reachable from home overview tiles (shell tab vs pushed route).
sealed class HomeOverviewDestination {
  const HomeOverviewDestination();
}

final class HomeShellTabDestination extends HomeOverviewDestination {
  const HomeShellTabDestination(this.tab);

  final MemberShellTab tab;
}

final class HomePushRouteDestination extends HomeOverviewDestination {
  const HomePushRouteDestination(this.route);

  final HomePushRoute route;
}

/// Named routes stacked on top of the shell (`GoRoute.name` keys in `app_router.dart`).
enum HomePushRoute {
  users,
  calculator;

  String get namedRoute => switch (this) {
        HomePushRoute.users => 'users',
        HomePushRoute.calculator => 'calculator',
      };
}
