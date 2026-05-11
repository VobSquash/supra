import 'package:dupra/gen/assets.gen.dart';
import 'package:flutter/material.dart';

/// Stretching VoB header image with a centered [avatar]; scrolls away with [SliverAppBar].
///
/// Used by profile (editable avatar) and member profile (read-only avatar).
class DupraProfileHeroSliver extends StatelessWidget {
  const DupraProfileHeroSliver({
    required this.expandedHeight,
    required this.avatar,
    super.key,
  });

  final double expandedHeight;
  final Widget avatar;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      stretch: true,
      expandedHeight: expandedHeight,
      toolbarHeight: 0,
      collapsedHeight: 0,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Assets.images.vobHeader.image(fit: BoxFit.cover),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Center(child: avatar),
            ),
          ],
        ),
      ),
    );
  }
}
