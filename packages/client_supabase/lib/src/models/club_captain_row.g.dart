// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_captain_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClubCaptainRow _$ClubCaptainRowFromJson(Map<String, dynamic> json) =>
    ClubCaptainRow(
      id: json['id'] as String,
      clubName: json['club_name'] as String?,
      captainName: json['captain_name'] as String?,
      captainContactNo: json['captain_contact_no'] as String?,
      isCatering: json['is_catering'] as bool?,
      leagueTeam: (json['league_team'] as num?)?.toInt(),
      clubLocationFk: json['club_location_fk'] as String?,
      ladderType: (json['ladder_type'] as num?)?.toInt(),
      legacyObjectId: json['legacy_object_id'] as String?,
    );

Map<String, dynamic> _$ClubCaptainRowToJson(ClubCaptainRow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'club_name': instance.clubName,
      'captain_name': instance.captainName,
      'captain_contact_no': instance.captainContactNo,
      'is_catering': instance.isCatering,
      'league_team': instance.leagueTeam,
      'club_location_fk': instance.clubLocationFk,
      'ladder_type': instance.ladderType,
      'legacy_object_id': instance.legacyObjectId,
    };
