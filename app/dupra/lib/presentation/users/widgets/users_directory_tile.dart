part of '../users_page.dart';

class _UsersDirectoryTile extends StatelessWidget {
  const _UsersDirectoryTile({required this.profile, required this.onTap});

  final BasicProfileDTO profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ext = profile.extendedProfile;
    final t = ext?.membershipType;

    final name = profile.displayName.trim().isEmpty ? '(no name)' : profile.displayName.trim();
    final useAvatarIcon = (name, profile.profilePictureUrl, 42.0);
    final membershipSubtitle = t == null || t == MembershipTypeEnum.unknown ? 'Membership unknown' : t.friendlyName;
    return Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,

      child: GestureDetector(
        onTap: onTap,
        child: DupraIconRow(
          useAvatarIcon: useAvatarIcon,
          icon: Icons.person_outline_rounded,
          iconAccentColor: DupraColors.accentForUserDirectoryRow(name),
          leadingEdgeAccent: true,
          showIconBackground: false,
          contentPadding: context.dupraScaledEdgeInsetsSymmetric(horizontal: 14),
          trailing: IconButton(
            onPressed: onTap,
            icon: Icon(
              Icons.chevron_right_rounded,
              color: scheme.onSurfaceVariant,
              size: context.dupraScaledIconSize(24),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                membershipSubtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
