import 'package:dio/dio.dart';

/// Writes `locations` via PostgREST with upsert on primary key `id`.
///
/// Uses deterministic `id` from [mapParseLocationToSupabaseRow] so re-runs merge
/// the same row. Preferring `id` avoids PostgreSQL 42P10: partial unique indexes on
/// `vob_guid` do not satisfy `ON CONFLICT (vob_guid)` for PostgREST.
class SupabaseLocationLoader {
  SupabaseLocationLoader({required this.dio});

  final Dio dio;

  static const _preferUpsert = 'return=minimal,resolution=merge-duplicates';

  Future<void> upsertLocation(Map<String, dynamic> row) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/locations',
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
    _throwIfBad(response, 'locations');
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
