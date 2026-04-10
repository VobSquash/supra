import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';

/// Joins a [LadderEntryRow] with the resolved [BasicProfileDTO] for AutoMappr.
class LadderEntryWithProfile {
  const LadderEntryWithProfile({
    required this.entry,
    this.profile,
  });

  final LadderEntryRow entry;
  final BasicProfileDTO? profile;
}
