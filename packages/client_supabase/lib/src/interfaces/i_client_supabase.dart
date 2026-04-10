import 'package:dio/dio.dart';

import '../models/supabase_config.dart';
import 'i_client_supabase_bookings.dart';
import 'i_client_supabase_club_captains.dart';
import 'i_client_supabase_ladders.dart';
import 'i_client_supabase_league_fixtures.dart';
import 'i_client_supabase_locations.dart';
import 'i_client_supabase_profiles.dart';
import 'i_client_supabase_settings.dart';

/// Entry contract for the Supabase client facade.
abstract class IClientSupabase {
  SupabaseConfig get config;

  /// DIO instance configured for `.../rest/v1` with Supabase headers.
  Dio get dio;

  /// Profiles endpoints.
  IClientSupabaseProfiles get profiles;

  /// Locations endpoints.
  IClientSupabaseLocations get locations;

  /// Key-value settings (Parse `Settings` parity).
  IClientSupabaseSettings get settings;

  /// Ladder entries (`LadderMens` / `LadderLadies` / `LadderMasters` parity).
  IClientSupabaseLadders get ladders;

  /// League / club captains (`LeagueCaptains` parity).
  IClientSupabaseClubCaptains get clubCaptains;

  /// League fixtures (`LeagueFixture` parity).
  IClientSupabaseLeagueFixtures get leagueFixtures;

  /// Court bookings (`Bookings` parity).
  IClientSupabaseBookings get bookings;
}
