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
      bottomNavigationBar: SafeArea(
        top: false,
        child: NavigationBar(
          selectedIndex: _selectedTab,
          onDestinationSelected: _goToTab,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          indicatorColor: scheme.primary.withValues(alpha: 0.35),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: 'Bookings',
            ),
            NavigationDestination(
              icon: Icon(Icons.emoji_events_outlined),
              selectedIcon: Icon(Icons.emoji_events),
              label: 'Fixtures',
            ),
            NavigationDestination(
              icon: Icon(Icons.place_outlined),
              selectedIcon: Icon(Icons.place_rounded),
              label: 'Locations',
            ),
          ],
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
  });

  final VoidCallback onOpenBookings;
  final VoidCallback onOpenAdminBookings;
  final VoidCallback onOpenMembers;
  final VoidCallback onOpenLadders;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 420;
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            Text(
              'Courts and bookings first. Members and ladders are a tap away. Welcome to the new age of VOB bookings',
              style: textTheme.bodyLarge?.copyWith(color: SupraColors.textSecondary, height: 1.35),
            ),
            const SizedBox(height: 24),
            _HeroBookingCard(onPressed: onOpenBookings),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onOpenAdminBookings,
              icon: const Icon(Icons.admin_panel_settings_outlined),
              label: const Text('Admin bookings (test)'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            const SizedBox(height: 16),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _CompactActionCard(
                      icon: Icons.groups_outlined,
                      title: 'Members',
                      subtitle: 'Active profiles',
                      onTap: onOpenMembers,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CompactActionCard(
                      icon: Icons.view_list_outlined,
                      title: 'Ladders',
                      subtitle: 'Lists & ladders',
                      onTap: onOpenLadders,
                    ),
                  ),
                ],
              )
            else ...[
              _CompactActionCard(
                icon: Icons.groups_outlined,
                title: 'Members',
                subtitle: 'Active profiles',
                onTap: onOpenMembers,
              ),
              const SizedBox(height: 12),
              _CompactActionCard(
                icon: Icons.view_list_outlined,
                title: 'Ladders',
                subtitle: 'Lists & ladders',
                onTap: onOpenLadders,
              ),
            ],
            const SizedBox(height: 20),
            Text(
              'Tip: Bookings, Fixtures, and Locations are on the bottom bar.',
              style: textTheme.bodyMedium?.copyWith(color: SupraColors.textSecondary, height: 1.35),
            ),
          ],
        );
      },
    );
  }
}

class _HeroBookingCard extends StatelessWidget {
  const _HeroBookingCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface.withValues(alpha: 0.88),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: SupraColors.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.event_available_rounded, color: SupraColors.secondary, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bookings',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Court reservations by day — your main destination.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: SupraColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(Icons.arrow_forward_ios_rounded, size: 18, color: SupraColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onPressed: onPressed,
                child: Text('Open bookings', style: Theme.of(context).textTheme.titleMedium),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactActionCard extends StatelessWidget {
  const _CompactActionCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.75),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: SupraColors.secondary, size: 28),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: SupraColors.textSecondary, height: 1.35),
              ),
            ],
          ),
        ),
      ),
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
