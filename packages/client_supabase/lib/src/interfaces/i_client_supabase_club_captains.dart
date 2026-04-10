import '../models/club_captain_row.dart';

abstract class IClientSupabaseClubCaptains {
  /// [public.league_captains] — Parse `LeagueCaptains`.
  Future<List<ClubCaptainRow>> getClubCaptains();
}
