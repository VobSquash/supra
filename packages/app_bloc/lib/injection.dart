import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/middleware.dart';

import 'injection.config.dart';

/// Same [GetIt] instance as [middlewareSl] — call [registerMiddleware] first,
/// then [registerAppBlocDependencies] before resolving [UsersBloc].
final appBlocSl = GetIt.instance;

/// Registers injectable types in this package (e.g. [UsersBloc]) on [GetIt].
///
/// **Order:** `registerMiddleware(appConfig)` → `registerAppBlocDependencies()`.
///
/// Uses a top-level initializer (not a [GetIt] extension) so this package does
/// not define a second `GetItInjectableX` extension that would collide with
/// `middleware` when both are imported in the app.
///
/// [IUsersFacade] / [ILocationsFacade] / [ISettingsFacade] / [ILaddersFacade] / [ILeagueFixturesFacade] / [IBookingsFacade] are provided by [registerMiddleware]; listed in
/// [ignoreUnregisteredTypes] only so this package’s codegen does not require
/// middleware to be analyzed as part of app_bloc’s graph.
@InjectableInit(
  initializerName: 'initAppBloc',
  preferRelativeImports: true,
  asExtension: false,
  ignoreUnregisteredTypes: [
    IUsersFacade,
    ILocationsFacade,
    ISettingsFacade,
    ILaddersFacade,
    ILeagueFixturesFacade,
    IBookingsFacade,
  ],
)
void configureAppBlocDependencies() {}

void registerAppBlocDependencies([GetIt? getIt]) {
  initAppBloc(getIt ?? appBlocSl);
}
