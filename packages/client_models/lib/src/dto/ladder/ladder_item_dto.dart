import 'package:client_models/client_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ladder_item_dto.freezed.dart';

@freezed
class LadderItemDTO with _$LadderItemDTO {
  const LadderItemDTO._();
  const factory LadderItemDTO({
    required String? objectId,
    required String? vobGuid,
    required int? order,
    required BasicProfileDTO? profile,
    required int? team,
    required bool? canBeChallenged,
  }) = _LadderItemDTO;

  factory LadderItemDTO.empty() => const LadderItemDTO(
        objectId: null,
        vobGuid: null,
        order: null,
        profile: null,
        team: null,
        canBeChallenged: null,
      );
}
