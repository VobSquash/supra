import 'dart:math' as math;

import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supra/gen/assets.gen.dart';

import '../../engine/route.dart';
import '../../engine/theme/supra_colors.dart';
import '../bookings/bookings_test_page.dart';
import '../league_fixtures/league_fixtures_test_page.dart';
import '../locations/locations_test_page.dart';

/// Display name until auth supplies a real name.
const String _kWelcomeNamePlaceholder = 'member';

/// Primary shell: logo + welcome only on Home; other tabs are full-bleed under the status bar.
class SupraHomePage extends StatefulWidget {
  const SupraHomePage({super.key});

  @override
  State<SupraHomePage> createState() => _SupraHomePageState();
}

class _SupraHomePageState extends State<SupraHomePage> with SingleTickerProviderStateMixin {
  static const int _tabHome = 0;
  static const int _tabBookings = 1;

  static const Duration _tabAnimationDuration = Duration(milliseconds: 600);

  /// Matches [AppBar.toolbarHeight] for the home app bar.
  static const double _kHomeAppBarToolbarHeight = 94;

  /// Height of [AppBar.bottom] ([_HomeWelcomeBar]) on the home app bar.
  static const double _kHomeWelcomeBarHeight = 72;

  int _selectedTab = _tabHome;

  late final PageController _pageController;

  late final AnimationController _homeAppBarAnimationController;
  late final CurvedAnimation _homeAppBarCurve;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedTab);
    _homeAppBarAnimationController = AnimationController(vsync: this, duration: _tabAnimationDuration, value: 1);
    _homeAppBarCurve = CurvedAnimation(
      parent: _homeAppBarAnimationController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _homeAppBarCurve.dispose();
    _homeAppBarAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _syncHomeAppBarAnimation() {
    if (_selectedTab == _tabHome) {
      _homeAppBarAnimationController.forward();
    } else {
      _homeAppBarAnimationController.reverse();
    }
  }

  void _onPageChangedBySwipe(int index) {
    if (index == _selectedTab) return;
    setState(() => _selectedTab = index);
    _syncHomeAppBarAnimation();
  }

  void _goToTab(int index) {
    if (index == _selectedTab) return;
    setState(() => _selectedTab = index);
    _syncHomeAppBarAnimation();
    _pageController.animateToPage(index, duration: _tabAnimationDuration, curve: Curves.easeOutCubic);
  }

  void _openRoute(String name) {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(name);
  }

  Future<void> _confirmAndLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Log out')),
        ],
      ),
    );

    if (!mounted || shouldLogout != true) return;
    context.read<AuthBloc>().add(const AuthEvent.signOutRequested());
  }

  @override
  Widget build(BuildContext context) {
    final welcomeName = context.watch<AuthBloc>().state.maybeWhen(
      authenticated: (snap) => snap.displayName ?? snap.email?.split('@').first ?? _kWelcomeNamePlaceholder,
      orElse: () => _kWelcomeNamePlaceholder,
    );
    final scheme = Theme.of(context).colorScheme;
    final topPad = MediaQuery.paddingOf(context).top;
    final homeAppBarFullHeight = topPad + _kHomeAppBarToolbarHeight + _kHomeWelcomeBarHeight;

    final homeAppBar = AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 16,
      toolbarHeight: _kHomeAppBarToolbarHeight,
      title: const _SupraAppBarTitle(),
      // Keep actions minimal: the profile control is very wide (~160px); extra actions overflow off-screen on phones.
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 10),
          child: Tooltip(
            message: 'Profile',
            child: _ProfileAppBarButton(onPressed: () => Navigator.of(context).pushNamed(RouteNames.profile)),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(_kHomeWelcomeBarHeight),
        child: Builder(
          builder: (context) => _HomeWelcomeBar(
            welcomeName: welcomeName,
            onOpenMenu: () => Scaffold.of(context).openDrawer(),
            onLogout: _confirmAndLogout,
          ),
        ),
      ),
    );

    return Scaffold(
      extendBody: true,
      drawer: _HomeDrawer(onNavigate: _openRoute),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizeTransition(
            sizeFactor: _homeAppBarCurve,
            axis: Axis.vertical,
            axisAlignment: -1,
            child: SizedBox(height: homeAppBarFullHeight, child: homeAppBar),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: _homeAppBarCurve,
              builder: (context, child) {
                final t = _homeAppBarCurve.value;
                final barH = homeAppBarFullHeight * t;
                final extraTop = math.max(0.0, topPad - barH);
                return Padding(
                  padding: EdgeInsets.only(top: extraTop),
                  child: child!,
                );
              },
              child: SafeArea(
                top: false,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChangedBySwipe,
                  children: [
                    _HomeOverview(
                      onOpenBookings: () => _goToTab(_tabBookings),
                      onOpenAdminBookings: () => Navigator.of(context).pushNamed(RouteNames.adminBookings),
                      onOpenMembers: () => Navigator.of(context).pushNamed(RouteNames.users),
                      onOpenLadders: () => Navigator.of(context).pushNamed(RouteNames.ladders),
                      onOpenFridgeCalculator: () => Navigator.of(context).pushNamed(RouteNames.fridgeCalculator),
                    ),
                    BlocProvider<BookingsBloc>(
                      create: (_) => appBlocSl<BookingsBloc>(),
                      child: const BookingsTestPage(nested: true),
                    ),
                    BlocProvider<LeagueFixturesBloc>(
                      create: (_) => appBlocSl<LeagueFixturesBloc>(),
                      child: const LeagueFixturesTestPage(nested: true),
                    ),
                    BlocProvider<LocationsBloc>(
                      create: (_) => appBlocSl<LocationsBloc>(),
                      child: const LocationsTestPage(nested: true),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _SupraDockNav(scheme: scheme, selectedIndex: _selectedTab, onTabChange: _goToTab),
    );
  }
}

/// Full-width dock bar (no third-party nav): teal accent line, equal segments, animated selection.
class _SupraDockNav extends StatelessWidget {
  const _SupraDockNav({required this.scheme, required this.selectedIndex, required this.onTabChange});

  final ColorScheme scheme;
  final int selectedIndex;
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
                    SupraColors.secondary.withValues(alpha: 0.15),
                    SupraColors.secondary,
                    SupraColors.tertiary.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 2, 2, 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      icon: Icons.emoji_events_outlined,
                      selectedIcon: Icons.emoji_events_rounded,
                      label: 'Fixtures',
                      scheme: scheme,
                      onTap: () => onTabChange(2),
                    ),
                  ),
                  Expanded(
                    child: _DockTab(
                      selected: selectedIndex == 3,
                      icon: Icons.place_outlined,
                      selectedIcon: Icons.place_rounded,
                      label: 'Locations',
                      scheme: scheme,
                      semanticLabel: 'Locations tab',
                      onTap: () => onTabChange(3),
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
    this.semanticLabel,
  });

  final bool selected;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final ColorScheme scheme;
  final VoidCallback onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final accent = SupraColors.secondary;
    final fg = selected ? accent : scheme.onSurfaceVariant;
    final textScaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.25);
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      color: fg,
      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      letterSpacing: selected ? 0.15 : 0,
    );

    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel ?? label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: accent.withValues(alpha: 0.12),
          highlightColor: accent.withValues(alpha: 0.06),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            constraints: const BoxConstraints(minHeight: 48),
            decoration: BoxDecoration(
              color: selected ? accent.withValues(alpha: 0.14) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: selected ? accent.withValues(alpha: 0.35) : Colors.transparent, width: 1),
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: textScaler),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(selected ? selectedIcon : icon, size: 22, color: fg),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: labelStyle,
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

/// Second row under the logo: menu + welcome + log out. Lives in [AppBar.bottom].
class _HomeWelcomeBar extends StatelessWidget {
  const _HomeWelcomeBar({required this.welcomeName, required this.onOpenMenu, required this.onLogout});

  final String welcomeName;
  final VoidCallback onOpenMenu;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.primary.withValues(alpha: 0.18),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              tooltip: 'Menu',
              onPressed: onOpenMenu,
              style: IconButton.styleFrom(
                minimumSize: const Size(kMinInteractiveDimension, kMinInteractiveDimension),
                padding: const EdgeInsets.all(12),
              ),
              icon: const Icon(Icons.menu_rounded),
            ),
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  'Welcome, $welcomeName',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            TextButton.icon(
              icon: Icon(Icons.logout, size: 20, color: scheme.primary),
              label: Text(
                'Log out',
                style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600),
              ),
              onPressed: onLogout,
            ),
          ],
        ),
      ),
    );
  }
}

class _SupraAppBarTitle extends StatelessWidget {
  const _SupraAppBarTitle();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Semantics(
        label: 'Supra',
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 60, maxWidth: 220),
          child: Assets.images.homeDarkMode.image(fit: BoxFit.cover, alignment: Alignment.centerLeft),
        ),
      ),
    );
  }
}

/// Large circular profile control for the home [AppBar] (easy to spot / tap).
class _ProfileAppBarButton extends StatelessWidget {
  const _ProfileAppBarButton({required this.onPressed});

  final VoidCallback onPressed;

  static const double _diameter = 160;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.primary.withValues(alpha: 0.18),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: _diameter,
          height: _diameter,
          child: Center(child: Icon(Icons.person_rounded, size: 45, color: scheme.primary)),
        ),
      ),
    );
  }
}

class _HomeOverview extends StatelessWidget {
  const _HomeOverview({
    required this.onOpenBookings,
    required this.onOpenAdminBookings,
    required this.onOpenMembers,
    required this.onOpenLadders,
    required this.onOpenFridgeCalculator,
  });

  final VoidCallback onOpenBookings;
  final VoidCallback onOpenAdminBookings;
  final VoidCallback onOpenMembers;
  final VoidCallback onOpenLadders;
  final VoidCallback onOpenFridgeCalculator;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottomPad = MediaQuery.paddingOf(context).bottom + 88;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [scheme.surfaceContainerLow.withValues(alpha: 0.35), SupraColors.scaffoldBackground],
        ),
      ),
      child: ListView(
        padding: EdgeInsets.fromLTRB(0, 8, 0, bottomPad),
        children: [
          _HomeSection(
            title: 'Overview',
            cardAccent: SupraColors.tertiary,
            items: const [
              _HomeSectionItem(
                title: 'Courts first',
                subtitle:
                    'Reserve courts, follow fixtures, and browse locations from the bar below. '
                    'Members and ladders are one tap away.',
                icon: Icons.sports_tennis_rounded,
                accentColor: SupraColors.tertiary,
                showDivider: false,
              ),
            ],
          ),
          _HomeSection(
            title: 'Quick actions',
            cardAccent: SupraColors.secondary,
            items: [
              _HomeSectionItem(
                title: 'Book a court',
                subtitle: 'Day-by-day grid — pick a slot and confirm.',
                icon: Icons.event_available_rounded,
                accentColor: SupraColors.secondary,
                onTap: onOpenBookings,
                leadingEdgeAccent: true,
              ),
              _HomeSectionItem(
                title: 'Members',
                subtitle: 'Directory & profiles',
                icon: Icons.groups_outlined,
                accentColor: SupraColors.success,
                leadingEdgeAccent: true,
                onTap: onOpenMembers,
              ),
              _HomeSectionItem(
                title: 'Ladders',
                subtitle: 'Order & rankings',
                icon: Icons.view_list_outlined,
                accentColor: SupraColors.warning,
                onTap: onOpenLadders,
                leadingEdgeAccent: true,
              ),
              _HomeSectionItem(
                title: 'Calculator',
                subtitle: 'Fridge calculator',
                icon: Icons.local_drink_outlined,
                accentColor: SupraColors.calculator,
                onTap: onOpenFridgeCalculator,
                leadingEdgeAccent: true,
                showDivider: false,
              ),
            ],
          ),
          _HomeSection(
            title: 'Admin',
            cardAccent: SupraColors.primary,
            items: [
              _HomeSectionItem(
                title: 'Admin bookings (test)',
                subtitle: 'Harness for group / fixture flows',
                icon: Icons.admin_panel_settings_outlined,
                accentColor: SupraColors.error,
                onTap: onOpenAdminBookings,
                trailing: Icon(Icons.open_in_new_rounded, size: 22, color: SupraColors.textSecondary),
                showDivider: false,
              ),
            ],
          ),
          Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: const _OverviewNavHint()),
        ],
      ),
    );
  }
}

class _HomeSectionItem {
  const _HomeSectionItem({
    required this.title,
    this.subtitle,
    required this.icon,
    this.accentColor = SupraColors.secondary,
    this.onTap,
    this.showDivider = true,
    this.leadingEdgeAccent = false,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onTap;
  final bool showDivider;
  final bool leadingEdgeAccent;
  final Widget? trailing;
}

/// Section layout aligned with legacy `VobSection`: header + bordered card of tappable rows.
class _HomeSection extends StatelessWidget {
  const _HomeSection({required this.title, required this.items, this.cardAccent});

  final String title;
  final List<_HomeSectionItem> items;
  final Color? cardAccent;

  static const double _cardRadius = 16;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final titleStyle = textTheme.bodyLarge?.copyWith(
      color: scheme.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.5,
    );

    final baseCard = scheme.surfaceContainerHighest.withValues(alpha: 0.55);
    final accent = cardAccent;
    final cardColor = accent == null ? baseCard : Color.alphaBlend(accent.withValues(alpha: 0.1), baseCard);
    final borderColor = accent == null
        ? scheme.onSurface.withValues(alpha: 0.1)
        : Color.alphaBlend(accent.withValues(alpha: 0.4), scheme.onSurface.withValues(alpha: 0.08));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: Text(title, style: titleStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_cardRadius),
                side: BorderSide(color: borderColor),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    _HomeSectionItemTile(item: items[i], index: i, itemCount: items.length, cardRadius: _cardRadius),
                    if (items[i].showDivider && i < items.length - 1)
                      Divider(height: 1, color: scheme.onSurface.withValues(alpha: 0.1)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeSectionItemTile extends StatelessWidget {
  const _HomeSectionItemTile({
    required this.item,
    required this.index,
    required this.itemCount,
    required this.cardRadius,
  });

  final _HomeSectionItem item;
  final int index;
  final int itemCount;
  final double cardRadius;

  static const double _kAccentWidth = 5;

  static BorderRadius _splashRadiusForTile({required int index, required int count, required double r}) {
    if (count <= 0) return BorderRadius.zero;
    if (count == 1) return BorderRadius.circular(r);
    if (index == 0) {
      return BorderRadius.only(topLeft: Radius.circular(r), topRight: Radius.circular(r));
    }
    if (index == count - 1) {
      return BorderRadius.only(bottomLeft: Radius.circular(r), bottomRight: Radius.circular(r));
    }
    return BorderRadius.zero;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final splashRadius = _splashRadiusForTile(index: index, count: itemCount, r: cardRadius);

    final contentPadding = item.leadingEdgeAccent
        ? const EdgeInsets.fromLTRB(13, 12, 20, 12)
        : const EdgeInsets.symmetric(horizontal: 20, vertical: 12);

    final inner = Padding(
      padding: contentPadding,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, size: 32, color: item.accentColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: textTheme.titleMedium?.copyWith(
                    color: scheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (item.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle!,
                    style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface.withValues(alpha: 0.7), fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
          if (item.trailing != null)
            item.trailing!
          else if (item.onTap != null)
            Icon(Icons.chevron_right_rounded, color: scheme.onSurface.withValues(alpha: 0.6), size: 32),
        ],
      ),
    );

    // Same pattern as the original Book-a-court hero: accent is a left border on the tile, not a
    // separate column (avoids visual bleed past the card's rounded clip).
    Widget body = item.leadingEdgeAccent
        ? DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: _kAccentWidth, color: item.accentColor),
              ),
            ),
            child: inner,
          )
        : inner;

    if (item.onTap != null) {
      body = InkWell(onTap: item.onTap, borderRadius: splashRadius, child: body);
    }

    return Material(color: Colors.transparent, child: body);
  }
}

class _OverviewNavHint extends StatelessWidget {
  const _OverviewNavHint();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.touch_app_outlined, size: 20, color: SupraColors.textSecondary.withValues(alpha: 0.9)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Bookings, Fixtures, and Locations live on the bottom bar — swipe between them anytime.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: SupraColors.textSecondary, height: 1.45),
          ),
        ),
      ],
    );
  }
}

class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer({required this.onNavigate});

  final void Function(String routeName) onNavigate;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: SupraColors.scaffoldSecondary.withValues(alpha: 0.97),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Text(
                'More',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: SupraColors.textSecondary),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.groups_outlined),
              title: const Text('Users (test)'),
              onTap: () => onNavigate(RouteNames.users),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                final canAdmin = authState.maybeWhen(
                  authenticated: (s) => ProfileTypeEnum.get(s.profileTypeId ?? -1).isAdminOrElevated,
                  orElse: () => false,
                );
                if (!canAdmin) {
                  return const SizedBox.shrink();
                }
                return ListTile(
                  leading: const Icon(Icons.manage_accounts_outlined),
                  title: const Text('All profiles (admin)'),
                  onTap: () => onNavigate(RouteNames.adminProfiles),
                );
              },
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                final canAdmin = authState.maybeWhen(
                  authenticated: (s) => ProfileTypeEnum.get(s.profileTypeId ?? -1).isAdminOrElevated,
                  orElse: () => false,
                );
                if (!canAdmin) {
                  return const SizedBox.shrink();
                }
                return ListTile(
                  leading: const Icon(Icons.leaderboard_outlined),
                  title: const Text('Ladder management'),
                  onTap: () => onNavigate(RouteNames.adminLadders),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings (test)'),
              onTap: () => onNavigate(RouteNames.settings),
            ),
            ListTile(
              leading: const Icon(Icons.view_list_outlined),
              title: const Text('Ladders (test)'),
              onTap: () => onNavigate(RouteNames.ladders),
            ),
            ListTile(
              leading: const Icon(Icons.local_drink_outlined),
              title: const Text('Fridge calculator'),
              subtitle: const Text('Local demo — club fridge pricing'),
              onTap: () => onNavigate(RouteNames.fridgeCalculator),
            ),
          ],
        ),
      ),
    );
  }
}
