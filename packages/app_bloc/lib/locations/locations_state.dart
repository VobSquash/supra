part of 'locations_bloc.dart';

@freezed
class LocationsState with _$LocationsState {
  const factory LocationsState({
    required List<LocationsItemDTO> locations,
    required BaseLoading status,
  }) = _LocationsState;

  factory LocationsState.initial() => LocationsState(
        locations: const [],
        status: BaseLoading.initial(),
      );
}
