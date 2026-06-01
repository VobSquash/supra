import 'package:app_bloc/app_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_models/client_models.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/widgets/zoomable_network_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _horizontalInset = 16.0;
const _bannerRadius = 24.0;
const _dotAreaHeight = 28.0;
const _bottomSpacing = 10.0;

/// Space reserved under the image for the bottom-only lift shadow.
const _shadowDrop = 12.0;

/// Soft off-white glow under banners on the dark home scaffold.
const _bannerLiftShadow = Color(0xFFF2F2EC);

/// Full-width paged carousel of upcoming-event banners from Supabase storage.
class DupraEventBannersStrip extends StatefulWidget {
  const DupraEventBannersStrip({super.key});

  @override
  State<DupraEventBannersStrip> createState() => _DupraEventBannersStripState();
}

class _DupraEventBannersStripState extends State<DupraEventBannersStrip> {
  PageController? _pageController;
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  double _bannerHeight(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width - (_horizontalInset * 2);
    return (width * 0.42).clamp(140.0, 200.0);
  }

  void _syncController(int bannerCount) {
    if (bannerCount == 0) {
      _pageController?.dispose();
      _pageController = null;
      _currentPage = 0;
      return;
    }

    _pageController ??= PageController();
    if (_currentPage >= bannerCount) {
      _currentPage = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_pageController?.hasClients ?? false) {
          _pageController!.jumpToPage(0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerEventsBloc, BannerEventsState>(
      buildWhen: (prev, curr) => prev.banners != curr.banners || prev.status != curr.status,
      builder: (context, state) {
        final bannerHeight = _bannerHeight(context);

        if (state.status.status == BaseLoadingStatus.loading && state.banners.isEmpty) {
          return SizedBox(
            height: bannerHeight + _dotAreaHeight + _bottomSpacing,
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        if (state.banners.isEmpty) {
          return const SizedBox.shrink();
        }

        _syncController(state.banners.length);

        final totalHeight = bannerHeight + _dotAreaHeight + _bottomSpacing;

        return SizedBox(
          height: totalHeight,
          child: Column(
            children: [
              SizedBox(
                height: bannerHeight,
                width: double.infinity,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: state.banners.length,
                  itemBuilder: (context, index) {
                    return _EventBannerPage(banner: state.banners[index], height: bannerHeight);
                  },
                ),
              ),
              _CarouselDots(count: state.banners.length, index: _currentPage),
              const SizedBox(height: _bottomSpacing),
            ],
          ),
        );
      },
    );
  }
}

class _EventBannerPage extends StatelessWidget {
  const _EventBannerPage({required this.banner, required this.height});

  final EventBannerDTO banner;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final imageHeight = height - _shadowDrop;

    return Semantics(
      button: true,
      label: 'Event banner ${banner.sortOrder}. Swipe for more. Tap to zoom.',
      child: Tooltip(
        message: 'Tap to zoom',
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalInset),
          child: SizedBox(
            height: height,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                //          Container(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(24),
                //     border: Border.all(color: Colors.white, width: 2),
                //   ),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(24),
                //     child: Assets.images.vobHeader.image(fit: BoxFit.cover),
                //   ),
                // ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: imageHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_bannerRadius),
                      child: Material(
                        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
                        child: InkWell(
                          onTap: () =>
                              showZoomableNetworkImage(context, imageUrl: banner.imageUrl, cacheKey: banner.objectName),
                          child: CachedNetworkImage(
                            imageUrl: banner.imageUrl,
                            cacheKey: banner.objectName,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            width: double.infinity,
                            height: imageHeight,
                            placeholder: (_, __) => Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: scheme.primary.withValues(alpha: 0.85),
                              ),
                            ),
                            errorWidget: (_, __, ___) => Center(
                              child: Icon(Icons.broken_image_outlined, color: scheme.onSurface.withValues(alpha: 0.5)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //const Positioned(left: 32, right: 32, bottom: 0, child: _BottomOnlyLiftShadow()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CarouselDots extends StatelessWidget {
  const _CarouselDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        height: _dotAreaHeight - 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(count, (i) {
            final active = i == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: active ? 10 : 8,
              height: active ? 10 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? DupraColors.secondary : _bannerLiftShadow.withValues(alpha: 0.72),
                border: Border.all(color: _bannerLiftShadow.withValues(alpha: active ? 0.9 : 0.45)),
                boxShadow: active
                    ? [BoxShadow(color: DupraColors.secondary.withValues(alpha: 0.45), blurRadius: 6)]
                    : null,
              ),
            );
          }),
        ),
      ),
    );
  }
}
