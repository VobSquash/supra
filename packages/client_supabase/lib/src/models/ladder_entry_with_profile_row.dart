import 'ladder_entry_row.dart';
import 'profile_full.dart';

/// One ladder row from PostgREST with embedded `profiles(*,profile_extensions(*))`.
class LadderEntryWithProfileRow {
  const LadderEntryWithProfileRow({
    required this.entry,
    this.profile,
  });

  final LadderEntryRow entry;
  final ProfileFull? profile;

  factory LadderEntryWithProfileRow.fromPostgrestJson(Map<String, dynamic> json) {
    final raw = json['profiles'];
    ProfileFull? profile;
    if (raw is Map<String, dynamic>) {
      profile = ProfileFull.fromPostgrestJson(raw);
    }
    return LadderEntryWithProfileRow(
      entry: LadderEntryRow.fromJson(json),
      profile: profile,
    );
  }
}
