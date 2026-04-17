// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auth/auth.dart' as _i662;
import 'package:client_supabase/client_supabase.dart' as _i680;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:session_storage/session_storage.dart' as _i698;

import 'auth/app_auth_service.dart' as _i512;
import 'auth/middleware_auth_repository.dart' as _i404;
import 'clients/bookings/bookings_facade.dart' as _i992;
import 'clients/bookings/i_bookings_facade.dart' as _i743;
import 'clients/client_configs.dart' as _i692;
import 'clients/ladder/i_ladders_facade.dart' as _i686;
import 'clients/ladder/ladders_facade.dart' as _i432;
import 'clients/league_fixtures/i_league_fixtures_facade.dart' as _i1055;
import 'clients/league_fixtures/league_fixtures_facade.dart' as _i99;
import 'clients/locations/i_locations_facade.dart' as _i787;
import 'clients/locations/locations_facade.dart' as _i922;
import 'clients/settings/i_settings_facade.dart' as _i122;
import 'clients/settings/settings_facade.dart' as _i814;
import 'clients/users/i_users_facade.dart' as _i856;
import 'clients/users/users_facade.dart' as _i710;
import 'middleware_infrastructure_module.dart' as _i86;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final middlewareInfrastructureModule = _$MiddlewareInfrastructureModule();
    gh.lazySingleton<_i692.ClientConfigs>(
      () => middlewareInfrastructureModule.clientConfigs,
    );
    gh.lazySingleton<_i698.SessionStore>(
      () => middlewareInfrastructureModule.sessionStore(),
    );
    gh.lazySingleton<_i787.ILocationsFacade>(() => _i922.LocationsFacade());
    gh.lazySingleton<_i1055.ILeagueFixturesFacade>(
      () => _i99.LeagueFixturesFacade(),
    );
    gh.lazySingleton<_i662.AuthRepository>(
      () => _i404.MiddlewareAuthRepository(),
    );
    gh.lazySingleton<_i743.IBookingsFacade>(() => _i992.BookingsFacade());
    gh.lazySingleton<_i122.ISettingsFacade>(() => _i814.SettingsFacade());
    gh.lazySingleton<_i856.IUsersFacade>(() => _i710.UsersFacade());
    gh.lazySingleton<_i686.ILaddersFacade>(() => _i432.LaddersFacade());
    gh.lazySingleton<_i680.IClientSupabase>(
      () => middlewareInfrastructureModule.clientSupabase(
        gh<_i692.ClientConfigs>(),
      ),
    );
    gh.lazySingleton<_i662.AuthService>(
      () => _i512.AppAuthService(
        gh<_i662.AuthRepository>(),
        gh<_i698.SessionStore>(),
        gh<_i680.IClientSupabase>(),
      ),
    );
    return this;
  }
}

class _$MiddlewareInfrastructureModule
    extends _i86.MiddlewareInfrastructureModule {}
