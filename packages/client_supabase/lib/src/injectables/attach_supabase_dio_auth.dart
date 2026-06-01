import 'package:dio/dio.dart';

import 'supabase_auth_dio_interceptor.dart';
import 'supabase_refresh_on_401_dio_interceptor.dart';

/// Attaches GoTrue-aware Dio interceptors for PostgREST (auth header + 401 refresh/retry).
///
/// Call from Flutter app bootstrap after [Supabase.initialize] and [Dio] registration.
/// Order: auth header on each request, then refresh-and-retry on 401.
void attachSupabaseDioAuthInterceptors(Dio dio, {required String anonKey}) {
  if (dio.interceptors.whereType<SupabaseAuthDioInterceptor>().isEmpty) {
    dio.interceptors.add(SupabaseAuthDioInterceptor(anonKey: anonKey));
  }
  if (dio.interceptors.whereType<SupabaseRefreshOn401Interceptor>().isEmpty) {
    dio.interceptors.add(SupabaseRefreshOn401Interceptor(dio: dio, anonKey: anonKey));
  }
}
