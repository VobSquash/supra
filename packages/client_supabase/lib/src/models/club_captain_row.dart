import 'package:json_annotation/json_annotation.dart';

part 'club_captain_row.g.dart';

/// Supabase `league_captains` row (Parse `LeagueCaptains`).
@JsonSerializable()
class ClubCaptainRow {
  const ClubCaptainRow({
    required this.id,
    this.clubName,
    this.captainName,
    this.captainContactNo,
    this.isCatering,
    this.leagueTeam,
    this.clubLocationFk,
    this.ladderType,
    this.legacyObjectId,
  });

  factory ClubCaptainRow.fromJson(Map<String, dynamic> json) => _$ClubCaptainRowFromJson(json);

  final String id;

  @JsonKey(name: 'club_name')
  final String? clubName;

  @JsonKey(name: 'captain_name')
  final String? captainName;

  @JsonKey(name: 'captain_contact_no')
  final String? captainContactNo;

  @JsonKey(name: 'is_catering')
  final bool? isCatering;

  @JsonKey(name: 'league_team')
  final int? leagueTeam;

  @JsonKey(name: 'club_location_fk')
  final String? clubLocationFk;

  @JsonKey(name: 'ladder_type')
  final int? ladderType;

  @JsonKey(name: 'legacy_object_id')
  final String? legacyObjectId;

  Map<String, dynamic> toJson() => _$ClubCaptainRowToJson(this);
}
