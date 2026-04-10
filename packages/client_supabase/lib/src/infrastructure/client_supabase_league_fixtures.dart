import 'package:dio/dio.dart';

import '../interfaces/i_client_supabase_league_fixtures.dart';
import '../models/league_fixture_row.dart';
import '../models/supabase_config.dart';

class ClientSupabaseLeagueFixtures implements IClientSupabaseLeagueFixtures {
  ClientSupabaseLeagueFixtures({required SupabaseConfig config, required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<LeagueFixtureRow>> getLeagueFixtures() async {
    final response = await _dio.get(
      '/league_fixtures',
      queryParameters: const <String, dynamic>{
        'order': 'game_date.asc',
      },
    );

    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Failed to load league_fixtures (HTTP $status)',
      );
    }

    final data = response.data;
    if (data is! List) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.unknown,
        error: 'Unexpected league_fixtures payload: expected a JSON array',
      );
    }

    return data.whereType<Map<String, dynamic>>().map(LeagueFixtureRow.fromJson).toList(growable: false);
  }
}
