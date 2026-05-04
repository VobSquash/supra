import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Fullscreen pinch-zoom for a cached network image (e.g. profile photos).
Future<void> showZoomableNetworkImage(
  BuildContext context, {
  required String imageUrl,
  String? cacheKey,
}) async {
  final trimmed = imageUrl.trim();
  if (trimmed.isEmpty) return;

  await Navigator.of(context).push<void>(
    PageRouteBuilder<void>(
      opaque: false,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return _ZoomableNetworkImagePage(
          imageUrl: trimmed,
          cacheKey: cacheKey ?? trimmed,
        );
      },
      transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}

class _ZoomableNetworkImagePage extends StatelessWidget {
  const _ZoomableNetworkImagePage({
    required this.imageUrl,
    required this.cacheKey,
  });

  final String imageUrl;
  final String cacheKey;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.35,
                maxScale: 6,
                boundaryMargin: const EdgeInsets.all(160),
                panEnabled: true,
                clipBehavior: Clip.none,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  cacheKey: cacheKey,
                  fit: BoxFit.contain,
                  width: size.width,
                  height: size.height,
                  placeholder: (context, url) => SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                  errorWidget: (context, url, error) => Padding(
                    padding: const EdgeInsets.all(24),
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 56,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton.filledTonal(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.45),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'Close',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
