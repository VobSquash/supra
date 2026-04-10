import 'package:dio/dio.dart';

/// Writes `profile_extensions` and `profiles` via PostgREST with upsert on `vob_guid`.
class SupabaseProfileLoader {
  SupabaseProfileLoader({required this.dio});

  final Dio dio;

  static const _preferUpsert = 'return=minimal,resolution=merge-duplicates';

  Future<void> upsertExtension(Map<String, dynamic> row) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/profile_extensions',
      data: row,
      queryParameters: const <String, dynamic>{
        'on_conflict': 'vob_guid',
      },
      options: Options(
        headers: <String, dynamic>{
          'Prefer': _preferUpsert,
        },
      ),
    );
    _throwIfBad(response, 'profile_extensions');
  }

  Future<void> upsertProfile(Map<String, dynamic> row) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/profiles',
      data: row,
      queryParameters: const <String, dynamic>{
        'on_conflict': 'vob_guid',
      },
      options: Options(
        headers: <String, dynamic>{
          'Prefer': _preferUpsert,
        },
      ),
    );
    _throwIfBad(response, 'profiles');
  }

  void _throwIfBad(Response<dynamic> response, String table) {
    final code = response.statusCode ?? 0;
    if (code < 200 || code >= 300) {
      throw StateError(
        'Supabase $table write failed (HTTP $code): ${response.data}',
      );
    }
  }
}
