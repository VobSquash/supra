import '../models/league_fixture_row.dart';

abstract class IClientSupabaseLeagueFixtures {
  /// [public.league_fixtures] — Parse `LeagueFixture`.
  Future<List<LeagueFixtureRow>> getLeagueFixtures();
}
