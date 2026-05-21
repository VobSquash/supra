part of 'booking_heatmap_bloc.dart';

@freezed
class BookingHeatmapEvent with _$BookingHeatmapEvent {
  const factory BookingHeatmapEvent.loadMemberMonth({required DateTime anyDateInMonth}) =
      _LoadMemberMonth;

  const factory BookingHeatmapEvent.loadAdminDay({required DateTime forDay}) = _LoadAdminDay;
}
