part of '../profile_stub_page.dart';

/// Stretching header image with centered avatar; scrolls away with [SliverAppBar].
class _ProfileSliverAppBar extends StatelessWidget {
  const _ProfileSliverAppBar({
    required this.expandedHeight,
    required this.avatarRadius,
    required this.profile,
    required this.snapshot,
    required this.uploadingPhoto,
    required this.onAvatarTap,
  });

  final double expandedHeight;
  final double avatarRadius;
  final BasicProfileDTO? profile;
  final SessionSnapshot? snapshot;
  final bool uploadingPhoto;
  final VoidCallback? onAvatarTap;

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
              child: Center(
                child: _AvatarBlock(
                  radius: avatarRadius,
                  uploading: uploadingPhoto,
                  profile: profile,
                  snapshot: snapshot,
                  onTap: onAvatarTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
