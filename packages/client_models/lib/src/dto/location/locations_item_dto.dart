import 'package:freezed_annotation/freezed_annotation.dart';

part 'locations_item_dto.freezed.dart';

@freezed
class LocationsItemDTO with _$LocationsItemDTO {
  const LocationsItemDTO._();
  const factory LocationsItemDTO({
    required String? name,
    required String? prefix,
    required String? longitude,
    required String? latitude,
    required String? imageUrl,
    required String? vobGuid,
  }) = _LocationsItemDTO;

  factory LocationsItemDTO.empty() => LocationsItemDTO(
        name: null,
        prefix: null,
        longitude: null,
        latitude: null,
        imageUrl: null,
        vobGuid: null,
      );
}
