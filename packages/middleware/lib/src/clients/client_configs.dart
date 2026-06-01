import 'package:client_email/client_email.dart';
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

  EmailConfig? get emailConfig => EmailConfig.fromAppJson(currentAppConfig.toJson());

  /// Public base for HTML email images (Supabase `email-images` bucket).
  ///
  /// Uses [AppConfig.emailAssetBaseUrl] when set; otherwise derives from
  /// [AppConfig.supabaseUrl].
  String? get emailAssetBaseUrl {
    final explicit = currentAppConfig.emailAssetBaseUrl?.trim();
    if (explicit != null && explicit.isNotEmpty) {
      return _normalizePublicBaseUrl(explicit);
    }
    return _supabaseEmailAssetsBaseUrl(currentAppConfig.supabaseUrl);
  }

  static String? _supabaseEmailAssetsBaseUrl(String supabaseUrl) {
    final root = supabaseUrl.trim();
    if (root.isEmpty) return null;
    final withoutTrailing = root.endsWith('/') ? root.substring(0, root.length - 1) : root;
    return '$withoutTrailing/storage/v1/object/public/email-images/';
  }

  static String _normalizePublicBaseUrl(String url) {
    return url.endsWith('/') ? url : '$url/';
  }

  /// Public base for event banner images (Supabase `banner_events` bucket).
  String? get bannerEventsBaseUrl {
    final explicit = currentAppConfig.bannerEventsBaseUrl?.trim();
    if (explicit != null && explicit.isNotEmpty) {
      return _normalizePublicBaseUrl(explicit);
    }
    return _supabaseBannerEventsBaseUrl(currentAppConfig.supabaseUrl);
  }

  static String? _supabaseBannerEventsBaseUrl(String supabaseUrl) {
    final root = supabaseUrl.trim();
    if (root.isEmpty) return null;
    final withoutTrailing = root.endsWith('/') ? root.substring(0, root.length - 1) : root;
    return '$withoutTrailing/storage/v1/object/public/banner_events/';
  }
}

