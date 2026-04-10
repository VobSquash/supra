import 'package:client_models/client_models.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/src/injection.config.dart';

import 'clients/client_configs.dart';

final middlewareSl = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureMiddlewareDependencies() {}

/// Registers the latest [appConfig], then initializes any injectable types.
///
/// This is intended to be the **sole** entrypoint for initializing and
/// accessing `client_*` packages.
void registerMiddleware(AppConfig appConfig) {
  ClientConfigs.appConfig = appConfig;

  if (!middlewareSl.isRegistered<AppConfig>()) {
    middlewareSl.registerSingleton<AppConfig>(appConfig);
  } else {
    middlewareSl.unregister<AppConfig>();
    middlewareSl.registerSingleton<AppConfig>(appConfig);
  }

  // [ClientConfigs], [ClientSupabase], and future facades come from
  // [MiddlewareInfrastructureModule] via generated [init].
  middlewareSl.init();
}

