part of 'locations_bloc.dart';

@freezed
class LocationsEvent with _$LocationsEvent {
  const factory LocationsEvent.onLoadLocations() = OnLoadLocations;

  const factory LocationsEvent.onResetLocations() = OnResetLocations;
}
