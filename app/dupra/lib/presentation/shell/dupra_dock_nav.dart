part of 'main_shell_page.dart';

enum _ShellDockMode { member, admin }

class _DupraDockNav extends StatelessWidget {
  const _DupraDockNav({
    required this.scheme,
    required this.mode,
    required this.selectedIndex,
    required this.profileTabIndex,
    required this.avatarDisplayName,
    required this.avatarImageUrl,
    required this.onTabChange,
  });

  final ColorScheme scheme;
  final _ShellDockMode mode;
  final int selectedIndex;
  final int profileTabIndex;
  final String avatarDisplayName;
  final String? avatarImageUrl;
  final ValueChanged<int> onTabChange;

  @override
  Widget build(BuildContext context) {
    final isAdmin = mode == _ShellDockMode.admin;
    final dockAccent = isAdmin ? DupraColors.warning : DupraColors.secondary;
    final barColor = Color.lerp(
      scheme.surfaceContainerHigh,
      DupraColors.warning,
      isAdmin ? 0.14 : 0,
    )!.withValues(alpha: 0.98);

    final gradientColors = isAdmin
        ? [
            DupraColors.warning.withValues(alpha: 0.22),
            DupraColors.warning,
            Color.lerp(DupraColors.warning, DupraColors.error, 0.32)!,
          ]
        : [
            DupraColors.secondary.withValues(alpha: 0.15),
            DupraColors.secondary,
            DupraColors.tertiary.withValues(alpha: 0.85),
          ];

    return Material(
      elevation: 12,
      shadowColor: Colors.black.withValues(alpha: 0.45),
      color: barColor,
      surfaceTintColor: scheme.surfaceTint,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 2, 2, 4),
              child: Row(
                children: [
                  Expanded(
                    child: _DockTab(
                      selected: selectedIndex == 0,
                      icon: Icons.home_outlined,
                      selectedIcon: Icons.home_rounded,
                      label: 'Home',
                      scheme: scheme,
                      accent: dockAccent,
                      onTap: () => onTabChange(0),
                    ),
                  ),
                  Expanded(
                    child: _DockTab(
                      selected: selectedIndex == 1,
                      icon: Icons.calendar_month_outlined,
                      selectedIcon: Icons.calendar_month_rounded,
                      label: 'Bookings',
                      scheme: scheme,
                      accent: dockAccent,
                      onTap: () => onTabChange(1),
                    ),
                  ),
                  Expanded(
                    child: isAdmin
                        ? _DockTab(
                            selected: selectedIndex == 2,
                            icon: Icons.people_outline_rounded,
                            selectedIcon: Icons.people_rounded,
                            label: 'Users',
                            scheme: scheme,
                            accent: dockAccent,
                            onTap: () => onTabChange(2),
                          )
                        : _DockTab(
                            selected: selectedIndex == 2,
                            icon: Icons.sports_tennis_outlined,
                            selectedIcon: Icons.sports_tennis_rounded,
                            label: 'Fixtures',
                            scheme: scheme,
                            accent: dockAccent,
                            onTap: () => onTabChange(2),
                          ),
                  ),
                  Expanded(
                    child: _DockTab(
                      selected: selectedIndex == 3,
                      icon: Icons.emoji_events_outlined,
                      selectedIcon: Icons.emoji_events_rounded,
                      label: isAdmin ? 'Ladder' : 'Ladders',
                      scheme: scheme,
                      accent: dockAccent,
                      onTap: () => onTabChange(3),
                    ),
                  ),
                  Expanded(
                    child: _DockProfileTab(
                      selected: selectedIndex == profileTabIndex,
                      displayName: avatarDisplayName,
                      imageUrl: avatarImageUrl,
                      scheme: scheme,
                      accent: dockAccent,
                      onTap: () => onTabChange(profileTabIndex),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DockTab extends StatelessWidget {
  const _DockTab({
    required this.selected,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.scheme,
    required this.accent,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final ColorScheme scheme;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? accent : scheme.onSurfaceVariant;
    final labelStyle = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(color: fg, fontWeight: FontWeight.w500);
    final showLabel = context.appAccessibilityVisibility;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: accent.withValues(alpha: 0.12),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: context.dupraScaled(48)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(selected ? selectedIcon : icon, size: context.dupraScaledIconSize(22), color: fg),
                  if (showLabel) ...[
                    SizedBox(height: context.dupraScaled(2)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.dupraScaled(2)),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          label,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                          style: labelStyle,
                        ),
                      ),
                    ),
                  ],
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    height: 2,
                    margin: EdgeInsets.only(top: showLabel ? 2 : 4),
                    decoration: BoxDecoration(
                      color: selected ? accent : Colors.transparent,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DockProfileTab extends StatelessWidget {
  const _DockProfileTab({
    required this.selected,
    required this.displayName,
    required this.imageUrl,
    required this.scheme,
    required this.accent,
    required this.onTap,
  });

  final bool selected;
  final String displayName;
  final String? imageUrl;
  final ColorScheme scheme;
  final Color accent;
  final VoidCallback onTap;

  static double _avatarRadiusFor(BuildContext context) =>
      context.dupraScaledIconSize(_avatarRadiusBase, max: 22);

  static const double _avatarRadiusBase = 14;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: 'Profile',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: accent.withValues(alpha: 0.12),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: context.dupraScaled(48)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? accent : scheme.outlineVariant.withValues(alpha: 0.35),
                        width: selected ? 2 : 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(1.5),
                    child: DupraAvatar(
                      displayName: displayName,
                      imageUrl: imageUrl,
                      radius: _DockProfileTab._avatarRadiusFor(context),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    height: 2,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: selected ? accent : Colors.transparent,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
