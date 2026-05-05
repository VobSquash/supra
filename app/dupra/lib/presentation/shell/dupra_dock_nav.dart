part of 'main_shell_page.dart';

class _DupraDockNav extends StatelessWidget {
  const _DupraDockNav({
    required this.scheme,
    required this.selectedIndex,
    required this.tabCount,
    required this.onTabChange,
  });

  final ColorScheme scheme;
  final int selectedIndex;
  final int tabCount;
  final ValueChanged<int> onTabChange;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      shadowColor: Colors.black.withValues(alpha: 0.45),
      color: scheme.surfaceContainerHigh.withValues(alpha: 0.98),
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
                gradient: LinearGradient(
                  colors: [
                    DupraColors.secondary.withValues(alpha: 0.15),
                    DupraColors.secondary,
                    DupraColors.tertiary.withValues(alpha: 0.85),
                  ],
                ),
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
                      onTap: () => onTabChange(1),
                    ),
                  ),
                  Expanded(
                    child: _DockTab(
                      selected: selectedIndex == 2,
                      icon: Icons.sports_tennis_outlined,
                      selectedIcon: Icons.sports_tennis_rounded,
                      label: 'Fixtures',
                      scheme: scheme,
                      onTap: () => onTabChange(2),
                    ),
                  ),
                  Expanded(
                    child: _DockTab(
                      selected: selectedIndex == 3,
                      icon: Icons.emoji_events_outlined,
                      selectedIcon: Icons.emoji_events_rounded,
                      label: 'Ladders',
                      scheme: scheme,
                      onTap: () => onTabChange(3),
                    ),
                  ),
                  if (tabCount >= 5)
                    Expanded(
                      child: _DockTab(
                        selected: selectedIndex == 4,
                        icon: Icons.admin_panel_settings_outlined,
                        selectedIcon: Icons.admin_panel_settings_rounded,
                        label: 'Admin',
                        scheme: scheme,
                        onTap: () => onTabChange(4),
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
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final ColorScheme scheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const accent = DupraColors.secondary;
    final fg = selected ? accent : scheme.onSurfaceVariant;
    final labelStyle = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(color: fg, fontWeight: FontWeight.w500);

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
              constraints: const BoxConstraints(minHeight: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(selected ? selectedIcon : icon, size: 22, color: fg),
                  const SizedBox(height: 2),
                  IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: labelStyle,
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          height: 2,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            color: selected ? accent : Colors.transparent,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
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
