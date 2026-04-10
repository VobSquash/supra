import 'package:client_models/client_models.dart';

abstract class ILeagueFixturesFacade {
  /// Fixtures from Supabase with venue labels and matched [ClubCaptainDTO] per legacy rules.
  Future<List<LeagueFixtureDto>> loadLeagueFixtures();
}
