import 'dart:typed_data';

import 'package:client_models/client_models.dart';

/// Facade for user/profile read operations exposed by `middlewareSl`.
///
/// This is the stable surface `app_bloc` should depend on.
abstract class IUsersFacade {
  Future<List<BasicProfileDTO>> loadBasicProfiles();
  Future<List<BasicProfileDTO>> loadActiveBasicProfiles();
  Future<BasicProfileDTO?> loadProfileByVobGuid(String vobGuid);

  /// Ladder membership + profile + extension rows for a member (profile / member-details UI).
  /// Backed by `v_member_ladder_membership_with_profile`; transport lives on the ladders client.
  Future<List<MemberLadderMembershipWithProfileDTO>> loadMemberLadderMembership(String vobGuid);

  /// Inserts a new [profiles] row + [profile_extensions] (admin / elevated only; see session check).
  Future<BasicProfileDTO> createMemberProfileAsAdmin({required CreateMemberProfileDto dto});

  /// Signed-in user’s profile (Supabase `auth.uid()` row, with legacy email fallback).
  Future<BasicProfileDTO?> loadCurrentUserProfile();

  /// PATCH editable fields for the signed-in user. Requires RLS allowing self-service updates.
  Future<BasicProfileDTO> updateOwnProfile({required UpdateOwnProfileDto dto});

  /// Picks image client-side; uploads to Storage and updates [profiles.profile_picture_url].
  Future<BasicProfileDTO> uploadOwnProfilePicture({
    required Uint8List bytes,
    required String contentType,
  });

  /// Administrator / elevated: update member profile (+ extension) fields. Session-checked in facade.
  Future<BasicProfileDTO> updateMemberProfileAsAdmin({
    required String profileRowId,
    required String? vobGuid,
    String? extensionId,
    required UpdateAdminProfileDto dto,
  });
}
