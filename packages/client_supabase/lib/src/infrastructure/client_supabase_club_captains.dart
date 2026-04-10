import 'package:dio/dio.dart';

import '../interfaces/i_client_supabase_club_captains.dart';
import '../models/club_captain_row.dart';
import '../models/supabase_config.dart';

class ClientSupabaseClubCaptains implements IClientSupabaseClubCaptains {
  ClientSupabaseClubCaptains({required SupabaseConfig config, required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<ClubCaptainRow>> getClubCaptains() async {
    final response = await _dio.get(
      '/league_captains',
      queryParameters: const <String, dynamic>{
        'order': 'club_name.asc',
      },
    );

    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Failed to load league_captains (HTTP $status)',
      );
    }

    final data = response.data;
    if (data is! List) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.unknown,
        error: 'Unexpected league_captains payload: expected a JSON array',
      );
    }

    return data.whereType<Map<String, dynamic>>().map(ClubCaptainRow.fromJson).toList(growable: false);
  }
}
