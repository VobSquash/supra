import 'package:client_models/client_models.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/widgets/dupra_icon_row.dart';
import 'package:flutter/material.dart';

class UsersDirectoryTile extends StatelessWidget {
  const UsersDirectoryTile({
    required this.profile,
    required this.onTap,
    this.highlightInactiveSubtitle = false,
    super.key,
  });

  final BasicProfileDTO profile;
  final VoidCallback onTap;
  final bool highlightInactiveSubtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ext = profile.extendedProfile;
    final t = ext?.membershipType;

    final name = profile.displayName.trim().isEmpty ? '(no name)' : profile.displayName.trim();
    final inactive = !(profile.isActive ?? false);
    final useAvatarIcon = (name, profile.profilePictureUrl, 42.0);
    var membershipSubtitle =
        t == null || t == MembershipTypeEnum.unknown ? 'Membership unknown' : t.friendlyName;
    if (highlightInactiveSubtitle && inactive) {
      membershipSubtitle = 'Inactive · $membershipSubtitle';
    }

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
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          trailing: IconButton(
            onPressed: onTap,
            icon: Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(name, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 21)),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  membershipSubtitle,
                  style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
