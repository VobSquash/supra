import 'package:freezed_annotation/freezed_annotation.dart';

part 'ladder_team_breakdown.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class BreakdownTeamsDTO with _$BreakdownTeamsDTO {
  const BreakdownTeamsDTO._();
  const factory BreakdownTeamsDTO({
    required String? objectId,
    required List<BreakdownItemDTO>? mensteams,
    required List<BreakdownItemDTO>? ladiesTeams,
    required List<BreakdownItemDTO>? mastersTeams,
  }) = _BreakdownTeamsDTO;

  factory BreakdownTeamsDTO.empty() => const BreakdownTeamsDTO(
        objectId: null,
        mensteams: null,
        ladiesTeams: null,
        mastersTeams: null,
      );
  factory BreakdownTeamsDTO.fromJson(Map<String, dynamic> json) =>
      BreakdownTeamsDTO(
        objectId: json['objectId'],
        mensteams: json['LeagueTeams'] != null
            ? List<BreakdownItemDTO>.from(json['LeagueTeams']
                .map((item) => BreakdownItemDTO.fromJson(item)))
            : null,
        ladiesTeams: json['LeagueLadiesTeams'] != null
            ? List<BreakdownItemDTO>.from(json['LeagueLadiesTeams']
                .map((item) => BreakdownItemDTO.fromJson(item)))
            : null,
        mastersTeams: json['LeagueMastersTeams'] != null
            ? List<BreakdownItemDTO>.from(json['LeagueMastersTeams']
                .map((item) => BreakdownItemDTO.fromJson(item)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'LeagueTeams': mensteams?.map((item) => item.toJson()).toList(),
        'LeagueLadiesTeams': ladiesTeams?.map((item) => item.toJson()).toList(),
        'LeagueMastersTeams':
            mastersTeams?.map((item) => item.toJson()).toList(),
      };
}

@Freezed(fromJson: false, toJson: false)
class BreakdownItemDTO with _$BreakdownItemDTO {
  const BreakdownItemDTO._();
  const factory BreakdownItemDTO(
      {required int? teamMemberCount,
      required int? teamNumber}) = _BreakdownItemDTO;

  factory BreakdownItemDTO.empty() => const BreakdownItemDTO(
        teamMemberCount: null,
        teamNumber: null,
      );
  factory BreakdownItemDTO.fromJson(Map<String, dynamic> json) =>
      BreakdownItemDTO(
        teamMemberCount: json['TeamMemberCount'],
        teamNumber: json['TeamNumber'],
      );
  Map<String, dynamic> toJson() => {
        'TeamMemberCount': teamMemberCount,
        'TeamNumber': teamNumber,
      };
}
