import 'package:client_supabase/client_supabase.dart';
import 'package:injectable/injectable.dart';

import 'clients/client_configs.dart';

/// Injectable bindings for middleware infrastructure: client configs and the
/// configured `client_*` facades (starting with Supabase).
///
/// This mirrors `packages/examples/middleware/lib/src/middleware_infrastructure_module.dart`,
/// adapted to this repo’s packages (no CMS/Res/Synapse/Firebase here). Add
/// more `@LazySingleton` providers as you introduce additional clients and
/// facades that `app_bloc` or the app should resolve from [middlewareSl].
@module
abstract class MiddlewareInfrastructureModule {
  @LazySingleton()
  ClientConfigs get clientConfigs => ClientConfigs();

  @LazySingleton()
  IClientSupabase clientSupabase(ClientConfigs clientConfigs) => ClientSupabase(config: clientConfigs.supabaseConfig);
}
