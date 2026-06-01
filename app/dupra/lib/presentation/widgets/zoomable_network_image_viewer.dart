import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/// Fullscreen view: pinch to zoom and drag to pan. Tap close or swipe down to dismiss.
Future<void> showZoomableNetworkImage(
  BuildContext context, {
  required String imageUrl,
  String? cacheKey,
}) async {
  final trimmed = imageUrl.trim();
  if (trimmed.isEmpty) return;

  await Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (ctx) => _ZoomableNetworkImagePage(
        imageUrl: trimmed,
        cacheKey: cacheKey ?? trimmed,
      ),
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
    final provider = CachedNetworkImageProvider(imageUrl, cacheKey: cacheKey);

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.94),
      body: SafeArea(
        child: Stack(
          children: [
            PhotoView(
              imageProvider: provider,
              initialScale: PhotoViewComputedScale.contained,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.contained * 4,
              backgroundDecoration: const BoxDecoration(color: Colors.transparent),
              loadingBuilder: (context, event) => const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white70,
                ),
              ),
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  size: 56,
                  color: Colors.white70,
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
