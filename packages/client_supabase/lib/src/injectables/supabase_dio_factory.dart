import 'package:dio/dio.dart';

import '../models/supabase_config.dart';

/// Builds a [Dio] pointed at PostgREST (`/rest/v1`) with Supabase headers.
Dio createSupabaseDio(SupabaseConfig config) {
  final baseUrl = restV1BaseUrl(config.supabaseUrl);
  return Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: <String, dynamic>{
        'apikey': config.anonKey,
        'Authorization': 'Bearer ${config.anonKey}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (_) => true,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
}

/// `https://…supabase.co` → `https://…supabase.co/rest/v1`
String restV1BaseUrl(String supabaseUrl) {
  final trimmed = supabaseUrl.trim().replaceAll(RegExp(r'/+$'), '');
  return '$trimmed/rest/v1';
}
