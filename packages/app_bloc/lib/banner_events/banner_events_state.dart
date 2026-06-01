part of 'banner_events_bloc.dart';

@freezed
class BannerEventsState with _$BannerEventsState {
  const factory BannerEventsState({
    required List<EventBannerDTO> banners,
    required BaseLoading status,
  }) = _BannerEventsState;

  factory BannerEventsState.initial() => BannerEventsState(
        banners: const [],
        status: BaseLoading.initial(),
      );
}
