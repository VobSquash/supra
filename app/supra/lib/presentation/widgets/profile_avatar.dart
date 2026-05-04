import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'zoomable_network_image_viewer.dart';

/// Circular avatar: network image when [imageUrl] is set, otherwise first initial of [displayName].
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.displayName,
    this.imageUrl,
    this.radius = 20,
    this.cacheKey,
    this.zoomOnTap = false,
  });

  final String displayName;
  final String? imageUrl;
  final double radius;
  final String? cacheKey;

  /// When true and an image URL is present, tapping opens [showZoomableNetworkImage].
  final bool zoomOnTap;

  static String initialsGlyph(String displayName) {
    final t = displayName.trim();
    if (t.isEmpty) return '?';
    return t.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final trimmed = imageUrl?.trim();

    final initialsStyle = radius >= 40
        ? Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700)
        : Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);

    if (trimmed != null && trimmed.isNotEmpty) {
      final key = cacheKey ?? trimmed;
      Widget avatar = CircleAvatar(
        radius: radius,
        backgroundColor: scheme.surfaceContainerHighest,
        foregroundImage: CachedNetworkImageProvider(
          trimmed,
          cacheKey: key,
        ),
      );
      if (zoomOnTap) {
        avatar = Tooltip(
          message: 'Tap to zoom',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => showZoomableNetworkImage(context, imageUrl: trimmed, cacheKey: key),
            child: avatar,
          ),
        );
      }
      return avatar;
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: scheme.surfaceContainerHighest,
      child: Text(
        initialsGlyph(displayName),
        style: initialsStyle,
      ),
    );
  }
}
