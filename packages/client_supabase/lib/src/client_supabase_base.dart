import 'package:dio/dio.dart';

import 'injection.dart';
import 'interfaces/i_client_supabase.dart';
import 'infrastructure/client_supabase_bookings.dart';
import 'infrastructure/client_supabase_club_captains.dart';
import 'infrastructure/client_supabase_ladders.dart';
import 'infrastructure/client_supabase_league_fixtures.dart';
import 'infrastructure/client_supabase_locations.dart';
import 'infrastructure/client_supabase_profiles.dart';
import 'infrastructure/client_supabase_settings.dart';
import 'interfaces/i_client_supabase_bookings.dart';
import 'interfaces/i_client_supabase_club_captains.dart';
import 'interfaces/i_client_supabase_ladders.dart';
import 'interfaces/i_client_supabase_league_fixtures.dart';
import 'interfaces/i_client_supabase_locations.dart';
import 'interfaces/i_client_supabase_profiles.dart';
import 'interfaces/i_client_supabase_settings.dart';
import 'models/supabase_config.dart';

/// Supabase REST client: supplies [config], registers DI, and exposes a configured [dio].
///
/// ```dart
/// final config = await SupabaseConfig.fromJsonFile('supabase.json');
/// final client = ClientSupabase(config: config);
/// final response = await client.dio.get('/profiles');
/// ```
class ClientSupabase implements IClientSupabase {
  ClientSupabase({
    required this.config,
  }) {
    registerClientSupabase(config);
  }

  @override
  final SupabaseConfig config;

  @override
  Dio get dio => clientSupabaseSl<Dio>();

  @override
  IClientSupabaseProfiles get profiles {
    return ClientSupabaseProfiles(
      config: config,
      dio: dio,
    );
  }

  @override
  IClientSupabaseLocations get locations {
    return ClientSupabaseLocations(
      config: config,
      dio: dio,
    );
  }

  @override
  IClientSupabaseSettings get settings {
    return ClientSupabaseSettings(
      config: config,
      dio: dio,
    );
  }

  @override
  IClientSupabaseLadders get ladders {
    return ClientSupabaseLadders(
      config: config,
      dio: dio,
    );
  }

  @override
  IClientSupabaseClubCaptains get clubCaptains {
    return ClientSupabaseClubCaptains(
      config: config,
      dio: dio,
    );
  }

  @override
  IClientSupabaseLeagueFixtures get leagueFixtures {
    return ClientSupabaseLeagueFixtures(
      config: config,
      dio: dio,
    );
  }

  @override
  IClientSupabaseBookings get bookings {
    return ClientSupabaseBookings(
      config: config,
      dio: dio,
    );
  }
}
