import 'dart:convert';

import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:client_supabase/client_supabase_auth.dart';
import 'package:dupra/gen/assets.gen.dart';
import 'package:flutter/services.dart';
import 'package:middleware/middleware.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Initializes Supabase, middleware, and app blocs. Call before `runApp`.
///
/// Order matches the app_bloc injector documentation.
Future<void> bootstrap() async {
  final appConfig = await _loadAppConfigFromAsset();

  await Supabase.initialize(
    url: appConfig.supabaseUrl,
    anonKey: appConfig.anonKey,
  );

  registerMiddleware(appConfig);
  _attachSupabaseAuthDioInterceptor();
  registerAppBlocDependencies();
}

void _attachSupabaseAuthDioInterceptor() {
  final dio = middlewareSl<IClientSupabase>().dio;
  final anon = middlewareSl<AppConfig>().anonKey;
  if (dio.interceptors.whereType<SupabaseAuthDioInterceptor>().isEmpty) {
    dio.interceptors.add(SupabaseAuthDioInterceptor(anonKey: anon));
  }
}

Future<AppConfig> _loadAppConfigFromAsset() async {
  final raw = await rootBundle.loadString(Assets.appConfig);
  final json = jsonDecode(raw) as Map<String, dynamic>;
  return AppConfig.fromJson(json);
}
