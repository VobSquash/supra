import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:client_models/client_models.dart';

import 'ladder_entry_with_profile.dart';
import 'supabase_ladder_item_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<LadderEntryWithProfile, LadderItemDTO>(
    fields: [
      Field('objectId', custom: SupabaseLadderItemMapper.mapObjectId),
      Field('vobGuid', custom: SupabaseLadderItemMapper.mapVobGuid),
      Field('order', custom: SupabaseLadderItemMapper.mapOrder),
      Field('profile', custom: SupabaseLadderItemMapper.mapProfile),
      Field('team', custom: SupabaseLadderItemMapper.mapTeam),
      Field('canBeChallenged', custom: SupabaseLadderItemMapper.mapCanBeChallenged),
    ],
  ),
])
class SupabaseLadderItemMapper extends $SupabaseLadderItemMapper {
  const SupabaseLadderItemMapper() : super();

  static String? mapObjectId(LadderEntryWithProfile w) => w.entry.legacyObjectId;

  static String? mapVobGuid(LadderEntryWithProfile w) => w.entry.vobGuid;

  static int? mapOrder(LadderEntryWithProfile w) => w.entry.sortOrder;

  static BasicProfileDTO? mapProfile(LadderEntryWithProfile w) => w.profile;

  static int? mapTeam(LadderEntryWithProfile w) => w.entry.team;

  static bool? mapCanBeChallenged(LadderEntryWithProfile w) => w.entry.canBeChallenged;
}
