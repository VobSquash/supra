import 'package:dio/dio.dart';

import '../interfaces/i_client_supabase_profiles.dart';
import '../models/profile_full.dart';
import '../models/supabase_config.dart';

class ClientSupabaseProfiles implements IClientSupabaseProfiles {
  ClientSupabaseProfiles({required SupabaseConfig config, required Dio dio}) : _dio = dio;

  // Intentionally keep `config` in the constructor signature for future
  // expansion (e.g. schema selection, key switching), even if unused today.
  final Dio _dio;

  @override
  Future<List<ProfileFull>> getProfiles() async {
    final response = await _dio.get(
      '/profiles',
      queryParameters: const <String, dynamic>{'select': '*,profile_extensions(*)', 'order': 'email.asc'},
    );

    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Failed to load profiles (HTTP $status)',
      );
    }

    final data = response.data;
    if (data is! List) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.unknown,
        error: 'Unexpected profiles payload: expected a JSON array',
      );
    }

    return data.whereType<Map<String, dynamic>>().map(ProfileFull.fromPostgrestJson).toList(growable: false);
  }

  @override
  Future<ProfileFull?> getByVobGuid(String vobGuid) async {
    final normalized = _normalizeUuidLike(vobGuid);
    final candidates = <String>{vobGuid.trim(), ?normalized}.where((s) => s.isNotEmpty).toList(growable: false);

    for (final candidate in candidates) {
      final response = await _dio.get(
        '/profiles',
        queryParameters: <String, dynamic>{
          'select': '*,profile_extensions(*)',
          'vob_guid': 'eq.$candidate',
          'limit': 1,
        },
      );

      final status = response.statusCode ?? 0;
      if (status < 200 || status >= 300) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to load profile by vob_guid (HTTP $status)',
        );
      }

      final data = response.data;
      if (data is! List) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.unknown,
          error: 'Unexpected profile payload: expected a JSON array',
        );
      }

      if (data.isEmpty) {
        continue;
      }

      final row = data.first;
      if (row is! Map<String, dynamic>) {
        continue;
      }

      return ProfileFull.fromPostgrestJson(row);
    }

    return null;
  }
}

String? _normalizeUuidLike(String input) {
  final trimmed = input.trim().toLowerCase();
  if (trimmed.isEmpty) return null;

  // Already UUID-ish: accept.
  final uuidRegex = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$');
  if (uuidRegex.hasMatch(trimmed)) return trimmed;

  // Handle legacy normalized form: 32 hex chars (no hyphens).
  final hex32 = RegExp(r'^[0-9a-f]{32}$');
  if (!hex32.hasMatch(trimmed)) return null;

  return '${trimmed.substring(0, 8)}-'
      '${trimmed.substring(8, 12)}-'
      '${trimmed.substring(12, 16)}-'
      '${trimmed.substring(16, 20)}-'
      '${trimmed.substring(20)}';
}
