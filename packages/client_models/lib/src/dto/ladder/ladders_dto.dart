import 'package:client_models/src/dto/export_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ladders_dto.freezed.dart';

@freezed
class LaddersListDTO with _$LaddersListDTO {
  const LaddersListDTO._();
  const factory LaddersListDTO({
    required List<LadderItemDTO>? ladies,
    required List<LadderItemDTO>? men,
    required List<LadderItemDTO>? masters,
    required bool showLadderBreakdown,
  }) = _LaddersListDTO;

  factory LaddersListDTO.empty() => const LaddersListDTO(ladies: [], men: [], masters: [], showLadderBreakdown: false);
}
