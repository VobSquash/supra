part of '../member_profile_detail_page.dart';

String? _trimmedProfilePhoto(String? url) {
  final t = url?.trim();
  if (t == null || t.isEmpty) return null;
  return t;
}

/// Same halo avatar treatment as the profile header, without tap / camera badge.
class _MemberProfileHeaderAvatar extends StatelessWidget {
  const _MemberProfileHeaderAvatar({
    required this.displayName,
    required this.radius,
    this.imageUrl,
  });

  final String displayName;
  final double radius;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 8)),
          BoxShadow(color: scheme.primary.withValues(alpha: 0.15), spreadRadius: 3),
        ],
      ),
      child: DupraAvatar(
        radius: radius,
        displayName: displayName,
        imageUrl: _trimmedProfilePhoto(imageUrl),
      ),
    );
  }
}
