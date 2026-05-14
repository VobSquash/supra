import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dupra/engine/accessibility/dupra_build_context_accessibility.dart';
import 'package:dupra/engine/shell_locations.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/gen/assets.gen.dart';
import 'package:dupra/presentation/admin/admin_bookings_placeholder_page.dart';
import 'package:dupra/presentation/admin/admin_home_placeholder_page.dart';
import 'package:dupra/presentation/admin/admin_ladders_placeholder_page.dart';
import 'package:dupra/presentation/admin/admin_users_placeholder_page.dart';
import 'package:dupra/presentation/bookings/bookings_page.dart';
import 'package:dupra/presentation/fixtures/fixtures_page.dart';
import 'package:dupra/presentation/home/data/home_overview_destination.dart';
import 'package:dupra/presentation/home/home_overview_tab.dart';
import 'package:dupra/presentation/ladders/ladders_page.dart';
import 'package:dupra/presentation/profile/profile_stub_page.dart';
import 'package:dupra/presentation/widgets/dupra_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:session_storage/session_storage.dart';

part 'dupra_dock_nav.dart';

String _localPartOfEmail(String email) {
  final parts = email.split('@');
  return parts.isEmpty ? '' : parts.first.trim();
}

String _displayFromProfile(BasicProfileDTO? p) {
  if (p == null) return '';
  final first = p.firstName?.trim() ?? '';
  final last = p.lastName?.trim() ?? '';
  final combined = '$first $last'.trim();
  if (combined.isNotEmpty) return combined;
  final e = p.email?.trim();
  if (e != null && e.isNotEmpty) return _localPartOfEmail(e);
  return '';
}

String _shellAvatarLabel(SessionSnapshot? s, BasicProfileDTO? p) {
  final fromProfile = _displayFromProfile(p);
  if (fromProfile.isNotEmpty) return fromProfile;
  if (s != null) return _avatarLabel(s);
  return 'Member';
}

String? _shellAvatarPhoto(SessionSnapshot? s, BasicProfileDTO? p) {
  final fromProfile = p?.profilePictureUrl?.trim();
  if (fromProfile != null && fromProfile.isNotEmpty) return fromProfile;
  final fromSession = s?.avatarUrl?.trim();
  if (fromSession != null && fromSession.isNotEmpty) return fromSession;
  return null;
}

String _avatarLabel(SessionSnapshot s) {
  final n = s.displayName?.trim();
  if (n != null && n.isNotEmpty) return n;
  final e = s.email?.trim();
  if (e != null && e.isNotEmpty) {
    final local = _localPartOfEmail(e);
    if (local.isNotEmpty) return local;
  }
  return 'Member';
}

bool _sessionAllowsAdminShell(SessionSnapshot? snapshot) {
  final id = snapshot?.profileTypeId;
  if (id == null) return false;
  return ProfileTypeEnum.get(id).isAdminOrElevated;
}

bool _hasAdminShellAccess(BasicProfileDTO? profile, SessionSnapshot? session) {
  final typeStr = profile?.profileType?.trim();
  if (typeStr != null && typeStr.isNotEmpty) {
    return ProfileTypeEnum.get(typeStr).isAdminOrElevated;
  }
  return _sessionAllowsAdminShell(session);
}

/// Resolves shell suite (`m` / `a`) and tab index from [GoRouterState].
({String suite, int tabIndex, bool adminShell}) _shellPlacement(GoRouterState routerState) {
  final suite = routerState.pathParameters['suite'] ?? 'm';
  final tab = routerState.pathParameters['tab'] ?? 'home';
  if (!ShellLocations.isValidSuite(suite) || !ShellLocations.isValidTab(suite, tab)) {
    return (suite: 'm', tabIndex: 0, adminShell: false);
  }
  final idx = ShellLocations.tabIndexFor(suite: suite, tab: tab) ?? 0;
  return (suite: suite, tabIndex: idx, adminShell: suite == 'a');
}

/// Root chrome: swipeable [PageView] synced with [_DupraDockNav] and [ShellLocations].
class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  late final PageController _pageController;

  static const int _tabCount = 5;

  /// Last rounded page passed to [_LazyShellTab]; avoids [setState] on every scroll tick.
  int _shellLazyRoundedTabCache = -999999;

  /// Triggers rebuilds while [PageView] settles so lazy tabs can materialize during a swipe.
  void _onShellPageControllerTick() {
    if (!mounted || !_pageController.hasClients) return;
    final page = _pageController.page;
    if (page == null) return;
    final rounded = page.round();
    if (rounded == _shellLazyRoundedTabCache) return;
    _shellLazyRoundedTabCache = rounded;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onShellPageControllerTick);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authed = context.read<AuthBloc>().state.maybeWhen(authenticated: (_) => true, orElse: () => false);
      if (!authed) return;
      if (context.read<UsersBloc>().state.currentUserProfile != null) return;
      context.read<UsersBloc>().add(const UsersEvent.loadCurrentUserProfile());
    });
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_onShellPageControllerTick)
      ..dispose();
    super.dispose();
  }

  /// Page currently under the viewport (or [fallback] before [PageController] attaches).
  int _effectiveShellTabIndex(int fallback) {
    if (!_pageController.hasClients) return fallback;
    final page = _pageController.page;
    if (page == null) return fallback;
    return page.round();
  }

  void _syncPageControllerToIndex(int tabIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (!_pageController.hasClients) {
        return;
      }
      final current = _pageController.page?.round() ?? 0;
      if (current != tabIndex) {
        _pageController.jumpToPage(tabIndex);
      }
    });
  }

  void _goToTab(BuildContext context, int index) {
    if (index < 0 || index >= _tabCount) {
      return;
    }
    final routerState = GoRouterState.of(context);
    final suite = routerState.pathParameters['suite'] ?? 'm';
    final admin = suite == 'a';
    context.go(ShellLocations.path(suite, ShellLocations.tabSlugForIndex(admin: admin, index: index)));
  }

  void _handleHomeOverviewDestination(BuildContext context, HomeOverviewDestination destination) {
    switch (destination) {
      case HomeShellTabDestination(:final tab):
        final idx = ShellLocations.tabIndexFor(suite: 'm', tab: tab.slug);
        if (idx == null) {
          return;
        }
        _goToTab(context, idx);
      case HomePushRouteDestination(:final route):
        context.pushNamed(route.namedRoute);
    }
  }

  void _onPageChanged(BuildContext context, int index) {
    final routerState = GoRouterState.of(context);
    final suite = routerState.pathParameters['suite'] ?? 'm';
    final admin = suite == 'a';
    final next = ShellLocations.path(suite, ShellLocations.tabSlugForIndex(admin: admin, index: index));
    if (routerState.matchedLocation != next) {
      context.go(next);
    }
  }

  void _toggleAdminShell(BuildContext context) {
    final routerState = GoRouterState.of(context);
    final suite = routerState.pathParameters['suite'] ?? 'm';
    final goingAdmin = suite != 'a';
    context.go(ShellLocations.path(goingAdmin ? 'a' : 'm', 'home'));
  }

  void _dropAdminShellIfUnauthorized(BuildContext context, {required bool adminEligible, required bool adminShell}) {
    if (adminEligible || !adminShell) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.go(ShellLocations.defaultMember);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (prev, curr) {
        SessionSnapshot? snap(AuthState s) => s.maybeWhen(authenticated: (v) => v, orElse: () => null);
        final a = snap(prev);
        final b = snap(curr);
        return a?.displayName != b?.displayName ||
            a?.email != b?.email ||
            a?.avatarUrl != b?.avatarUrl ||
            a?.profileTypeId != b?.profileTypeId;
      },
      builder: (context, authState) {
        final snapshot = authState.maybeWhen(authenticated: (s) => s, orElse: () => null);

        return BlocBuilder<UsersBloc, UsersState>(
          buildWhen: (prev, curr) => prev.currentUserProfile != curr.currentUserProfile,
          builder: (context, usersState) {
            final profile = usersState.currentUserProfile;
            final adminEligible = _hasAdminShellAccess(profile, snapshot);

            final routerState = GoRouterState.of(context);
            final placement = _shellPlacement(routerState);
            _dropAdminShellIfUnauthorized(context, adminEligible: adminEligible, adminShell: placement.adminShell);
            _syncPageControllerToIndex(placement.tabIndex);
            final suiteKey = placement.adminShell ? 'a' : 'm';

            const profileTabIndex = _tabCount - 1;
            final avatarLabel = _shellAvatarLabel(snapshot, profile);
            final avatarUrl = _shellAvatarPhoto(snapshot, profile);

            return Scaffold(
              extendBody: true,
              appBar: AppBar(
                title: Align(
                  child: Semantics(
                    label: 'Dupra',
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 60, maxWidth: 220),
                      child: Assets.images.homeDarkMode.image(fit: BoxFit.cover, alignment: Alignment.centerLeft),
                    ),
                  ),
                ),
                actions: [
                  if (adminEligible)
                    IconButton(
                      tooltip: placement.adminShell ? 'Exit admin mode' : 'Admin mode',
                      onPressed: () => _toggleAdminShell(context),
                      icon: Icon(placement.adminShell ? Icons.close_rounded : Icons.admin_panel_settings_outlined),
                    ),
                ],
              ),
              body: PageView(
                controller: _pageController,
                onPageChanged: (i) => _onPageChanged(context, i),
                children: placement.adminShell
                    ? List.generate(
                        _tabCount,
                        (i) => _LazyShellTab(
                          key: ValueKey<String>('shell-$suiteKey-$i'),
                          tabIndex: i,
                          effectiveTabIndex: _effectiveShellTabIndex(placement.tabIndex),
                          builder: () => switch (i) {
                            0 => const AdminHomePlaceholderPage(),
                            1 => const AdminBookingsPlaceholderPage(),
                            2 => const AdminUsersPlaceholderPage(),
                            3 => const AdminLaddersPlaceholderPage(),
                            _ => const ProfileStubPage(),
                          },
                        ),
                      )
                    : List.generate(
                        _tabCount,
                        (i) => _LazyShellTab(
                          key: ValueKey<String>('shell-$suiteKey-$i'),
                          tabIndex: i,
                          effectiveTabIndex: _effectiveShellTabIndex(placement.tabIndex),
                          builder: () => switch (i) {
                            0 => HomeOverviewTab(onNavigate: _handleHomeOverviewDestination),
                            1 => const BookingsPage(),
                            2 => const FixturesPage(),
                            3 => const LaddersPage(),
                            _ => const ProfileStubPage(),
                          },
                        ),
                      ),
              ),
              bottomNavigationBar: _DupraDockNav(
                scheme: scheme,
                mode: placement.adminShell ? _ShellDockMode.admin : _ShellDockMode.member,
                selectedIndex: placement.tabIndex,
                profileTabIndex: profileTabIndex,
                avatarDisplayName: avatarLabel,
                avatarImageUrl: avatarUrl,
                onTabChange: (i) => _goToTab(context, i),
              ),
            );
          },
        );
      },
    );
  }
}

/// Builds a shell tab only once it becomes visible, then keeps the subtree alive.
class _LazyShellTab extends StatefulWidget {
  const _LazyShellTab({
    required this.tabIndex,
    required this.effectiveTabIndex,
    required this.builder,
    super.key,
  });

  final int tabIndex;
  final int effectiveTabIndex;
  final Widget Function() builder;

  @override
  State<_LazyShellTab> createState() => _LazyShellTabState();
}

class _LazyShellTabState extends State<_LazyShellTab> {
  Widget? _child;

  @override
  Widget build(BuildContext context) {
    final materialize = widget.tabIndex == widget.effectiveTabIndex || _child != null;
    if (!materialize) {
      return const SizedBox.expand();
    }
    _child ??= widget.builder();
    return _child!;
  }
}
