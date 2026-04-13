import '../models/ladder_entry_with_profile_row.dart';
import '../models/member_ladder_membership_with_profile_row.dart';

abstract class IClientSupabaseLadders {
  /// [public.ladder_mens] — Parse `LadderMens`, with embedded profile (FK `vob_guid`).
  Future<List<LadderEntryWithProfileRow>> getLadderMens();

  /// [public.ladder_ladies] — Parse `LadderLadies`, with embedded profile.
  Future<List<LadderEntryWithProfileRow>> getLadderLadies();

  /// [public.ladder_masters] — Parse `LadderMasters`, with embedded profile.
  Future<List<LadderEntryWithProfileRow>> getLadderMasters();

  /// [public.v_member_ladder_membership_with_profile] — ladder slot + profile + extension.
  Future<List<MemberLadderMembershipWithProfileRow>> getMemberLadderMembershipWithProfile(
    String vobGuid,
  );
}
