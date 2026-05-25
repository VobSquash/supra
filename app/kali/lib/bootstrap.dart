import 'dart:convert';

import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:client_supabase/client_supabase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:middleware/middleware.dart';
import 'package:supabase/supabase.dart';

import 'auth/browser_gotrue_storage.dart';
import 'auth/supabase_web_session_persistence.dart';

/// Loads [AppConfig], registers shared DI (same middleware + app_blocs as Dupra),
/// wires Supabase Dart client + Dio auth interceptor, then triggers cold auth restore.
///
/// Loads `app_config.json` relative to [`Uri.base`] (served from `web/` via Jaspr dev/build).
Future<void> bootstrapKali() async {
  final appConfig = await _loadAppConfig();
  final supabaseClient = SupabaseClient(
    appConfig.supabaseUrl.trim(),
    appConfig.anonKey.trim(),
    authOptions: AuthClientOptions(
      autoRefreshToken: true,
      authFlowType: AuthFlowType.pkce,
      pkceAsyncStorage: BrowserGotrueStorage(),
    ),
  );

  final sessionPersistKey = supabaseFlutterWebPersistKey(appConfig.supabaseUrl);
  listenPersistSupabaseSession(supabaseClient, sessionPersistKey);
  await restoreSupabaseSessionFromBrowser(supabaseClient, sessionPersistKey);

  registerMiddleware(appConfig, supabaseClient: supabaseClient);
  _attachSupabaseAuthDioInterceptor(appConfig.anonKey);
  registerAppBlocDependencies();

  middlewareSl<AuthBloc>().add(const AuthEvent.checkRequested());
}

void _attachSupabaseAuthDioInterceptor(String anonKey) {
  final dio = middlewareSl<IClientSupabase>().dio;
  final client = middlewareSl<SupabaseClient>();
  if (dio.interceptors.whereType<SupabaseAuthDioInterceptor>().isEmpty) {
    dio.interceptors.add(
      SupabaseAuthDioInterceptor(
        supabaseClient: client,
        anonKey: anonKey.trim(),
      ),
    );
  }
}

Future<AppConfig> _loadAppConfig() async {
  final uri = Uri.base.resolve('app_config.json');
  final response = await http.get(uri);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw StateError(
      'Failed loading app_config.json (${response.statusCode}) from $uri '
      '(copy Dupra\'s JSON into web/app_config.json for local dev).',
    );
  }
  final decoded = jsonDecode(response.body);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('app_config.json must decode to a JSON object');
  }
  return AppConfig.fromJson(decoded);
}
