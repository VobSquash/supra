import 'package:dio/dio.dart';

/// Writes `settings` via PostgREST with upsert on primary key `id`.
class SupabaseSettingsLoader {
  SupabaseSettingsLoader({required this.dio});

  final Dio dio;

  static const _preferUpsert = 'return=minimal,resolution=merge-duplicates';

  Future<void> upsertSetting(Map<String, dynamic> row) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/settings',
      data: row,
      queryParameters: const <String, dynamic>{
        'on_conflict': 'id',
      },
      options: Options(
        headers: <String, dynamic>{
          'Prefer': _preferUpsert,
        },
      ),
    );
    _throwIfBad(response, 'settings');
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
