import '../models/ladder_entry_with_profile_row.dart';
import '../models/ladder_entry_upsert.dart';
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

  /// Admin/elevated upsert path by [vob_guid] for ladder tables.
  Future<void> upsertLadderDivisionRows({
    required String table,
    required List<LadderEntryUpsert> rows,
  });

  /// Deletes all rows for [year] in [table], then inserts [rows] (full replace for that season).
  ///
  /// Matches a purge-and-resave model; requires admin DELETE + INSERT RLS on the ladder table.
  Future<void> replaceLadderDivisionForYear({
    required String table,
    required int year,
    required List<LadderEntryUpsert> rows,
  });

  /// Admin/elevated delete path by [vob_guid] for ladder tables.
  Future<void> deleteLadderDivisionMember({
    required String table,
    required String vobGuid,
  });
}
