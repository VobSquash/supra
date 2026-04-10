import 'package:dio/dio.dart';

/// Writes ladder rows to `public.ladder_mens` | `ladder_ladies` | `ladder_masters`.
class SupabaseLadderLoader {
  SupabaseLadderLoader({required this.dio});

  final Dio dio;

  static const _preferUpsert = 'return=minimal,resolution=merge-duplicates';

  /// [tableName] is Postgres table without schema, e.g. `ladder_mens`.
  Future<void> upsert(String tableName, Map<String, dynamic> row) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/$tableName',
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
    _throwIfBad(response, tableName);
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
