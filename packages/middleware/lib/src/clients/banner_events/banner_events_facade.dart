import 'package:client_models/client_models.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/src/clients/client_configs.dart';
import 'package:middleware/src/injection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'i_banner_events_facade.dart';

@LazySingleton(as: IBannerEventsFacade)
class BannerEventsFacade implements IBannerEventsFacade {
  static const _bucket = 'banner_events';

  static const _imageExtensions = {'.png', '.jpg', '.jpeg', '.webp', '.gif'};

  ClientConfigs get _configs => middlewareSl<ClientConfigs>();

  @override
  Future<List<EventBannerDTO>> loadEventBanners() async {
    // return [];
    final baseUrl = _configs.bannerEventsBaseUrl;
    if (baseUrl == null || baseUrl.isEmpty) {
      return const [];
    }

    final storage = Supabase.instance.client.storage.from(_bucket);
    final objects = await storage.list();

    final banners = <EventBannerDTO>[];
    for (final obj in objects) {
      final name = obj.name.trim();
      if (name.isEmpty || name.startsWith('.')) continue;
      if (!_isImageObjectName(name)) continue;

      final sortOrder = _numericSortOrder(name);
      if (sortOrder == null) continue;

      final publicUrl = storage.getPublicUrl(name);
      banners.add(EventBannerDTO(objectName: name, imageUrl: publicUrl, sortOrder: sortOrder));
    }

    banners.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return banners;
  }

  static bool _isImageObjectName(String name) {
    final lower = name.toLowerCase();
    return _imageExtensions.any(lower.endsWith);
  }

  /// Filename stem must be a positive integer (e.g. `1.png` → 1).
  static int? _numericSortOrder(String objectName) {
    final dot = objectName.lastIndexOf('.');
    final stem = dot > 0 ? objectName.substring(0, dot) : objectName;
    if (stem.isEmpty || !RegExp(r'^\d+$').hasMatch(stem)) return null;
    return int.tryParse(stem);
  }
}
