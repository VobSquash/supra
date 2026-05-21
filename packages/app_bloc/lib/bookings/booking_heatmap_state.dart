part of 'booking_heatmap_bloc.dart';

enum BookingHeatmapMode { member, admin }

@freezed
class BookingHeatmapState with _$BookingHeatmapState {
  const factory BookingHeatmapState({
    required BaseLoading status,
    required BookingHeatmapMode mode,
    BookingHeatmapMemberMonth? memberMonth,
    BookingHeatmapMemberRolling4Week? memberRolling4Week,
    BookingHeatmapAdminDayGrid? adminDayGrid,
  }) = _BookingHeatmapState;

  factory BookingHeatmapState.initial() => BookingHeatmapState(
        status: BaseLoading.initial(),
        mode: BookingHeatmapMode.member,
        memberMonth: null,
        memberRolling4Week: null,
        adminDayGrid: null,
      );
}
