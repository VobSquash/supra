import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';

import 'supabase_club_captain_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<ClubCaptainRow, ClubCaptainDTO>(
    fields: [
      Field('ladderType', custom: SupabaseClubCaptainMapper.mapLadderType),
    ],
  ),
])
class SupabaseClubCaptainMapper extends $SupabaseClubCaptainMapper {
  const SupabaseClubCaptainMapper() : super();

  static LadderTypeEnum? mapLadderType(ClubCaptainRow r) =>
      ladderTypeEnumFromIndex(r.ladderType);
}
