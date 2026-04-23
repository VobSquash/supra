import 'package:client_models/client_models.dart';

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

  /// Inserts [profiles] + [profile_extensions] and links [profiles.profile_extension_id].
  ///
  /// Requires PostgREST + RLS allowing the signed-in user to perform these writes (see
  /// `supabase/sql/profiles_admin_mutations.sql`).
  Future<ProfileFull> createMemberProfile({required CreateMemberProfileDto dto});

  /// PATCH member-editable columns on [profiles] and [profile_extensions].
  ///
  /// [profileRowId] is `profiles.id`. When [extensionId] is null, only the profile row is updated.
  /// Reload uses [vobGuid] when non-empty, otherwise [profileRowId] with [getByAuthUserId].
  Future<ProfileFull> patchMemberProfileFields({
    required String profileRowId,
    required String? vobGuid,
    String? extensionId,
    required UpdateOwnProfileDto dto,
  });

  /// PATCH member [profiles] + optional [profile_extensions] (admin / elevated; see RLS).
  Future<ProfileFull> patchProfileAdminFields({
    required String profileRowId,
    required String? vobGuid,
    String? extensionId,
    required UpdateAdminProfileDto dto,
  });
}

