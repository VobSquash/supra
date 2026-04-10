import 'package:dio/dio.dart';

/// Writes `league_fixtures` via PostgREST with upsert on primary key `id`.
class SupabaseLeagueFixturesLoader {
  SupabaseLeagueFixturesLoader({required this.dio});

  final Dio dio;

  static const _preferUpsert = 'return=minimal,resolution=merge-duplicates';

  Future<void> upsertLeagueFixture(Map<String, dynamic> row) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/league_fixtures',
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
    _throwIfBad(response, 'league_fixtures');
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
