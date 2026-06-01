part of 'banner_events_bloc.dart';

@freezed
class BannerEventsEvent with _$BannerEventsEvent {
  const factory BannerEventsEvent.onLoadEventBanners() = OnLoadEventBanners;

  const factory BannerEventsEvent.onResetEventBanners() = OnResetEventBanners;
}
