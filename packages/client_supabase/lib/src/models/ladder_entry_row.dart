import 'package:json_annotation/json_annotation.dart';

import 'ladder_entry.dart';

part 'ladder_entry_row.g.dart';

@JsonSerializable()
class LadderEntryRow implements ILadderEntry {
  const LadderEntryRow({
    required this.id,
    this.sortOrder,
    this.year,
    this.vobGuid,
    this.team,
    this.canBeChallenged,
    this.legacyObjectId,
  });

  factory LadderEntryRow.fromJson(Map<String, dynamic> json) => _$LadderEntryRowFromJson(json);

  @override
  final String id;

  @override
  @JsonKey(name: 'sort_order')
  final int? sortOrder;

  @override
  final int? year;

  @override
  @JsonKey(name: 'vob_guid')
  final String? vobGuid;

  @override
  final int? team;

  @override
  @JsonKey(name: 'can_be_challenged')
  final bool? canBeChallenged;

  @override
  @JsonKey(name: 'legacy_object_id')
  final String? legacyObjectId;

  Map<String, dynamic> toJson() => _$LadderEntryRowToJson(this);
}
