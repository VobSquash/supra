import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart' show SupabaseConfig;
import 'package:middleware/src/mappers/app_config_mapper.dart';

/// Central place to derive downstream client configs from [AppConfig].
///
/// This mirrors the pattern in `packages/examples/middleware` where a single
/// `ClientConfigs` instance produces strongly-typed config objects consumed by
/// each client package.
class ClientConfigs {
  /// Static holder for the active [AppConfig]. Set during app bootstrap and
  /// update again if config is refreshed at runtime.
  static late AppConfig? _appConfig;

  static set appConfig(AppConfig config) {
    _appConfig = config;
  }

  AppConfig get currentAppConfig {
    final config = _appConfig;
    if (config == null) {
      throw StateError(
        'ClientConfigs.appConfig has not been set. '
        'Call registerMiddleware(AppConfig) first.',
      );
    }
    return config;
  }

  final AppConfigMapper _appConfigMapper = const AppConfigMapper();

  SupabaseConfig get supabaseConfig =>
      _appConfigMapper.toSupabaseConfig(currentAppConfig);
}

