import '../models/ladder_entry_row.dart';

abstract class IClientSupabaseLadders {
  /// [public.ladder_mens] — Parse `LadderMens`.
  Future<List<LadderEntryRow>> getLadderMens();

  /// [public.ladder_ladies] — Parse `LadderLadies`.
  Future<List<LadderEntryRow>> getLadderLadies();

  /// [public.ladder_masters] — Parse `LadderMasters`.
  Future<List<LadderEntryRow>> getLadderMasters();
}
