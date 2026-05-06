import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Circular user avatar: caches [imageUrl] via [CachedNetworkImage], otherwise initials.
class DupraAvatar extends StatelessWidget {
  const DupraAvatar({
    required this.displayName,
    super.key,
    this.imageUrl,
    this.radius = 20,
    this.cacheKey,
    this.loading = false,
  });

  final String displayName;
  final String? imageUrl;

  /// Half of outer diameter.
  final double radius;

  /// Defaults to trimmed [imageUrl] when null.
  final String? cacheKey;

  /// When true, shows a centered progress indicator instead of image or initials.
  final bool loading;

  String _initialsGlyph(String displayName) {
    final t = displayName.trim();
    if (t.isEmpty) return '?';
    final first = Characters(t).first;
    if (first.isEmpty) return '?';
    return first.toUpperCase();
  }

  TextStyle? _initialsStyle(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return radius >= 26
        ? textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
        : textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final size = radius * 2;
    final bg = scheme.surfaceContainerHighest;
    final initials = _initialsGlyph(displayName);
    final initialsStyle = _initialsStyle(context);

    if (loading) {
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: SizedBox(
            width: (radius * 0.65).clamp(16.0, 28.0),
            height: (radius * 0.65).clamp(16.0, 28.0),
            child: CircularProgressIndicator(strokeWidth: 2, color: scheme.primary),
          ),
        ),
      );
    }

    final trimmed = imageUrl?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      final key = cacheKey ?? trimmed;
      return SizedBox(
        width: size,
        height: size,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: trimmed,
            width: size,
            height: size,
            fit: BoxFit.cover,
            cacheKey: key,
            fadeInDuration: const Duration(milliseconds: 150),
            placeholder: (_, __) => ColoredBox(
              color: bg,
              child: Center(
                child: SizedBox(
                  width: radius * 0.7,
                  height: radius * 0.7,
                  child: CircularProgressIndicator(strokeWidth: 2, color: scheme.primary),
                ),
              ),
            ),
            errorWidget: (_, __, ___) => ColoredBox(
              color: bg,
              child: Center(
                child: Text(initials, style: initialsStyle, textAlign: TextAlign.center),
              ),
            ),
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: bg,
      child: Text(initials, style: initialsStyle, textAlign: TextAlign.center),
    );
  }
}
