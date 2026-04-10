import 'package:dio/dio.dart';

import '../interfaces/i_client_supabase_ladders.dart';
import '../models/ladder_entry_with_profile_row.dart';
import '../models/supabase_config.dart';

class ClientSupabaseLadders implements IClientSupabaseLadders {
  ClientSupabaseLadders({required SupabaseConfig config, required Dio dio}) : _dio = dio;

  final Dio _dio;

  /// PostgREST embed via FK [vob_guid] → [profiles.vob_guid].
  static const _selectWithProfile = '*,profiles(*,profile_extensions(*))';

  @override
  Future<List<LadderEntryWithProfileRow>> getLadderMens() => _getTable('ladder_mens');

  @override
  Future<List<LadderEntryWithProfileRow>> getLadderLadies() => _getTable('ladder_ladies');

  @override
  Future<List<LadderEntryWithProfileRow>> getLadderMasters() => _getTable('ladder_masters');

  Future<List<LadderEntryWithProfileRow>> _getTable(String table) async {
    final response = await _dio.get(
      '/$table',
      queryParameters: const <String, dynamic>{
        'select': _selectWithProfile,
        'order': 'sort_order.asc',
      },
    );

    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Failed to load $table (HTTP $status)',
      );
    }

    final data = response.data;
    if (data is! List) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.unknown,
        error: 'Unexpected $table payload: expected a JSON array',
      );
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(LadderEntryWithProfileRow.fromPostgrestJson)
        .toList(growable: false);
  }
}
