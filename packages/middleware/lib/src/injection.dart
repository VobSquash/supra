import 'package:client_models/client_models.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/src/injection.config.dart';
import 'package:supabase/supabase.dart';

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
/// [supabaseClient] must be supplied by the host app (Flutter: `Supabase.instance.client`
/// after `Supabase.initialize`; Jaspr/other: a configured `SupabaseClient`). VM-only CLI
/// code that never touches auth does not require it unless [AuthRepository] is resolved.
///
/// This is intended to be the **sole** entrypoint for initializing and
/// accessing `client_*` packages.
void registerMiddleware(
  AppConfig appConfig, {
  SupabaseClient? supabaseClient,
}) {
  ClientConfigs.appConfig = appConfig;

  if (!middlewareSl.isRegistered<AppConfig>()) {
    middlewareSl.registerSingleton<AppConfig>(appConfig);
  } else {
    middlewareSl.unregister<AppConfig>();
    middlewareSl.registerSingleton<AppConfig>(appConfig);
  }

  if (supabaseClient != null) {
    if (middlewareSl.isRegistered<SupabaseClient>()) {
      middlewareSl.unregister<SupabaseClient>();
    }
    middlewareSl.registerSingleton<SupabaseClient>(supabaseClient);
  }

  // [ClientConfigs], [ClientSupabase], and future facades come from
  // [MiddlewareInfrastructureModule] via generated [init].
  middlewareSl.init();
}
