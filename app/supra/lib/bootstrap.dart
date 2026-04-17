import 'dart:convert';

import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:client_supabase/client_supabase_auth.dart';
import 'package:flutter/services.dart';
import 'package:middleware/middleware.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> bootstrap() async {
  final appConfig = await _loadAppConfigFromAsset();

  await Supabase.initialize(
    url: appConfig.supabaseUrl,
    anonKey: appConfig.anonKey,
  );

  // Order matters (see packages/app_bloc/lib/injection.dart).
  registerMiddleware(appConfig);
  attachSupabaseAuthDioInterceptor();
  registerAppBlocDependencies();
}

/// Adds [SupabaseAuthDioInterceptor] to the shared Supabase REST client. Lives here
/// (not in `middleware`’s `injection.dart`) so VM `dart test` for packages that
/// import `middleware` does not pull `dart:ui` via `client_supabase_auth`.
void attachSupabaseAuthDioInterceptor() {
  final dio = middlewareSl<IClientSupabase>().dio;
  final anon = middlewareSl<AppConfig>().anonKey;
  if (dio.interceptors.whereType<SupabaseAuthDioInterceptor>().isEmpty) {
    dio.interceptors.add(SupabaseAuthDioInterceptor(anonKey: anon));
  }
}

Future<AppConfig> _loadAppConfigFromAsset() async {
  final raw = await rootBundle.loadString('app_config.json');
  final json = jsonDecode(raw) as Map<String, dynamic>;
  return AppConfig.fromJson(json);
}
