import 'package:dio/dio.dart';
import 'package:supabase/supabase.dart';

/// Sets PostgREST `Authorization: Bearer <user access token>` when logged in,
/// otherwise falls back to the anon key (public RLS paths).
///
/// Use the same application-wide [SupabaseClient] supplied to [middleware]
/// bootstrap (Flutter: [Supabase.instance.client] after [Supabase.initialize];
/// Jaspr/other: Dart [SupabaseClient] with persisted auth).
class SupabaseAuthDioInterceptor extends Interceptor {
  SupabaseAuthDioInterceptor({
    required this.supabaseClient,
    required this.anonKey,
  });

  final SupabaseClient supabaseClient;
  final String anonKey;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = supabaseClient.auth.currentSession?.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      options.headers['Authorization'] = 'Bearer $anonKey';
    }
    handler.next(options);
  }
}
