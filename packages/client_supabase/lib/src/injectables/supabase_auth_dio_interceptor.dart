import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Sets PostgREST `Authorization: Bearer <user access token>` when logged in,
/// otherwise falls back to the anon key (public RLS paths).
///
/// Requires [Supabase.initialize] before requests (typically from the Flutter app).
class SupabaseAuthDioInterceptor extends Interceptor {
  SupabaseAuthDioInterceptor({required this.anonKey});

  final String anonKey;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = Supabase.instance.client.auth.currentSession?.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      options.headers['Authorization'] = 'Bearer $anonKey';
    }
    handler.next(options);
  }
}
