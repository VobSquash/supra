// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'fees.freezed.dart';
part 'fees.g.dart';

@freezed
class FeesDTO with _$FeesDTO {
  const FeesDTO._();
  const factory FeesDTO({
    required List<FeesItemDTO> items,
  }) = _FeesDTO;

  factory FeesDTO.empty() => const FeesDTO(
        items: [],
      );
}

@freezed
class FeesItemDTO with _$FeesItemDTO {
  const FeesItemDTO._();
  const factory FeesItemDTO({
    @JsonKey(name: 'Cost') required double cost,
    @JsonKey(name: 'ProRataCost') double? proRataCost,
    @JsonKey(name: 'FeeType') required String feeType,
  }) = _FeesItemDTO;

  factory FeesItemDTO.empty() => const FeesItemDTO(
        cost: 0,
        proRataCost: 0,
        feeType: '',
      );
  factory FeesItemDTO.fromJson(Map<String, dynamic> json) =>
      _$FeesItemDTOFromJson(json);
}
