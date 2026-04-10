import 'package:dio/dio.dart';

import '../interfaces/i_client_supabase_ladders.dart';
import '../models/ladder_entry_row.dart';
import '../models/supabase_config.dart';

class ClientSupabaseLadders implements IClientSupabaseLadders {
  ClientSupabaseLadders({required SupabaseConfig config, required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<LadderEntryRow>> getLadderMens() => _getTable('ladder_mens');

  @override
  Future<List<LadderEntryRow>> getLadderLadies() => _getTable('ladder_ladies');

  @override
  Future<List<LadderEntryRow>> getLadderMasters() => _getTable('ladder_masters');

  Future<List<LadderEntryRow>> _getTable(String table) async {
    final response = await _dio.get(
      '/$table',
      queryParameters: const <String, dynamic>{
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

    return data.whereType<Map<String, dynamic>>().map(LadderEntryRow.fromJson).toList(growable: false);
  }
}
