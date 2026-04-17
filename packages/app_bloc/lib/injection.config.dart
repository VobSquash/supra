// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auth/auth.dart' as _i662;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:middleware/middleware_clients.dart' as _i554;

import 'auth/auth_bloc.dart' as _i20;
import 'bookings/bookings_bloc.dart' as _i1037;
import 'ladders/ladders_bloc.dart' as _i558;
import 'league_fixtures/league_fixtures_bloc.dart' as _i407;
import 'locations/locations_bloc.dart' as _i57;
import 'settings/settings_bloc.dart' as _i287;
import 'users/users_bloc.dart' as _i48;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt initAppBloc(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.factory<_i558.LaddersBloc>(
    () => _i558.LaddersBloc(gh<_i554.ILaddersFacade>()),
  );
  gh.factory<_i48.UsersBloc>(() => _i48.UsersBloc(gh<_i554.IUsersFacade>()));
  gh.lazySingleton<_i20.AuthBloc>(() => _i20.AuthBloc(gh<_i662.AuthService>()));
  gh.factory<_i57.LocationsBloc>(
    () => _i57.LocationsBloc(gh<_i554.ILocationsFacade>()),
  );
  gh.factory<_i287.SettingsBloc>(
    () => _i287.SettingsBloc(gh<_i554.ISettingsFacade>()),
  );
  gh.factory<_i1037.BookingsBloc>(
    () => _i1037.BookingsBloc(gh<_i554.IBookingsFacade>()),
  );
  gh.factory<_i407.LeagueFixturesBloc>(
    () => _i407.LeagueFixturesBloc(gh<_i554.ILeagueFixturesFacade>()),
  );
  return getIt;
}
