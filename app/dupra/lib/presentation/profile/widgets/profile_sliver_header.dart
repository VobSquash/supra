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
    return DupraProfileHeroSliver(
      expandedHeight: expandedHeight,
      avatar: _AvatarBlock(
        radius: avatarRadius,
        uploading: uploadingPhoto,
        profile: profile,
        snapshot: snapshot,
        onTap: onAvatarTap,
      ),
    );
  }
}
