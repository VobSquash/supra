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
}
