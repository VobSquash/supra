import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/bookings/bookings_test_page.dart';
import '../presentation/home/home_page.dart';
import '../presentation/ladders/ladders_test_page.dart';
import '../presentation/league_fixtures/league_fixtures_test_page.dart';
import '../presentation/locations/locations_test_page.dart';
import '../presentation/profile/profile_placeholder_page.dart';
import '../presentation/settings/settings_test_page.dart';
import '../presentation/users/profile_details_page.dart';
import '../presentation/users/users_test_page.dart';
import 'route_names.dart';

/// Named routes with a shared fade transition (see `example-files/router.dart`).
class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name ?? RouteNames.initial;
    final page = _pageForRoute(name, settings);

    return PageRouteBuilder<void>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;
        final opacityAnimation = animation.drive(
          Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: curve)),
        );
        return FadeTransition(opacity: opacityAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  static Widget _pageForRoute(String route, RouteSettings settings) {
    switch (route) {
      case RouteNames.initial:
        return const SupraHomePage();

      case RouteNames.users:
        return BlocProvider<UsersBloc>(
          create: (_) => appBlocSl<UsersBloc>(),
          child: const UsersTestPage(),
        );

      case RouteNames.locations:
        return BlocProvider<LocationsBloc>(
          create: (_) => appBlocSl<LocationsBloc>(),
          child: const LocationsTestPage(),
        );

      case RouteNames.settings:
        return BlocProvider<SettingsBloc>(
          create: (_) => appBlocSl<SettingsBloc>(),
          child: const SettingsTestPage(),
        );

      case RouteNames.ladders:
        return BlocProvider<LaddersBloc>(
          create: (_) => appBlocSl<LaddersBloc>(),
          child: const LaddersTestPage(),
        );

      case RouteNames.leagueFixtures:
        return BlocProvider<LeagueFixturesBloc>(
          create: (_) => appBlocSl<LeagueFixturesBloc>(),
          child: const LeagueFixturesTestPage(),
        );

      case RouteNames.bookings:
        return BlocProvider<BookingsBloc>(
          create: (_) => appBlocSl<BookingsBloc>(),
          child: const BookingsTestPage(),
        );

      case RouteNames.profile:
        return const ProfilePlaceholderPage();

      case RouteNames.profileDetails:
        final profile = settings.arguments;
        if (profile is! BasicProfileDTO) {
          return const Scaffold(
            body: Center(child: Text('Missing or invalid profile argument.')),
          );
        }
        return ProfileDetailsPage(profile: profile);

      default:
        return const SupraHomePage();
    }
  }
}
