import '../models/profile_full.dart';

/// Profiles endpoints (profiles + embedded profile_extensions).
abstract class IClientSupabaseProfiles {
  /// Loads profiles and embeds their `profile_extensions` data.
  ///
  /// Requires PostgREST relationship `profiles -> profile_extensions` which is
  /// established via FK `profile_extensions.vob_guid -> profiles.vob_guid`.
  Future<List<ProfileFull>> getProfiles();

  /// Loads a single profile by its legacy GUID (`vob_guid`) and embeds its
  /// `profile_extensions` data.
  ///
  /// Returns `null` when not found.
  Future<ProfileFull?> getByVobGuid(String vobGuid);

  /// Loads a single profile by the Supabase auth user id (`profiles.id`).
  ///
  /// Returns `null` when not found.
  Future<ProfileFull?> getByAuthUserId(String authUserId);

  /// Loads a single profile by email.
  ///
  /// Returns `null` when not found.
  Future<ProfileFull?> getByEmail(String email);
}

