import 'package:client_models/src/dto/export_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'locations_dto.freezed.dart';

@freezed
class LocationsDTO with _$LocationsDTO {
  const LocationsDTO._();
  const factory LocationsDTO({required List<LocationsItemDTO>? locations}) = _LocationsDTO;

  factory LocationsDTO.empty() => LocationsDTO(locations: null);
}
