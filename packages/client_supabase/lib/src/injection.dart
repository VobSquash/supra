import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injectables/supabase_dio_factory.dart';
import 'injection.config.dart';
import 'models/supabase_config.dart';

/// Service locator for this package (mirrors the pattern in `games_integration_client`).
final clientSupabaseSl = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureClientSupabaseDependencies() {}

/// Registers [config] and [Dio], then runs generated [init] for any `@injectable` types.
///
/// Call once per process after you have a [SupabaseConfig] (from JSON, a file, etc.).
/// Re-calling replaces the previous [SupabaseConfig] and [Dio] registration.
void registerClientSupabase(SupabaseConfig config) {
  final sl = clientSupabaseSl;
  if (sl.isRegistered<SupabaseConfig>()) {
    sl.unregister<SupabaseConfig>();
  }
  if (sl.isRegistered<Dio>()) {
    sl.unregister<Dio>();
  }
  sl.registerSingleton<SupabaseConfig>(config);
  sl.registerLazySingleton<Dio>(() => createSupabaseDio(config));
  sl.init();
}
