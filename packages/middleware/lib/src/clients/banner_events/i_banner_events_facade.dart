import 'package:client_models/client_models.dart';

/// Lists upcoming-event banner images from the `banner_events` storage bucket.
abstract class IBannerEventsFacade {
  Future<List<EventBannerDTO>> loadEventBanners();
}
