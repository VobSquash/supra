import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_banner_dto.freezed.dart';

/// A public banner image from the `banner_events` storage bucket.
@freezed
class EventBannerDTO with _$EventBannerDTO {
  const factory EventBannerDTO({
    /// Storage object name (e.g. `1.png`) — stable cache key.
    required String objectName,
    /// Public HTTPS URL for [CachedNetworkImage].
    required String imageUrl,
    /// Parsed from the numeric filename stem (1, 2, 3, …).
    required int sortOrder,
  }) = _EventBannerDTO;
}
