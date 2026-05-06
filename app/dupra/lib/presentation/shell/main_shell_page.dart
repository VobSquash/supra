import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dupra/engine/accessibility/dupra_build_context_accessibility.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/gen/assets.gen.dart';
import 'package:dupra/presentation/admin/admin_hub_page.dart';
import 'package:dupra/presentation/bookings/bookings_page.dart';
import 'package:dupra/presentation/fixtures/fixtures_page.dart';
import 'package:dupra/presentation/home/home_overview_tab.dart';
import 'package:dupra/presentation/ladders/ladders_page.dart';
import 'package:dupra/presentation/profile/profile_stub_page.dart';
import 'package:dupra/presentation/widgets/dupra_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

/// Admin / elevated tooling tab: prefer [BasicProfileDTO.profileType] when loaded,
/// otherwise fall back to [SessionSnapshot.profileTypeId] (e.g. before profile fetch).
bool _shouldShowAdminTab(BasicProfileDTO? profile, SessionSnapshot? session) {
  final typeStr = profile?.profileType?.trim();
  if (typeStr != null && typeStr.isNotEmpty) {
    return ProfileTypeEnum.get(typeStr).isAdminOrElevated;
  }
  final id = session?.profileTypeId;
  if (id != null) {
    return ProfileTypeEnum.get(id).isAdminOrElevated;
  }
  return false;
}

/// Root chrome: swipeable [PageView] synced with [_DupraDockNav].
class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  late final PageController _pageController;
  var _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToTab(int index, int tabCount) {
    if (index < 0 || index >= tabCount) {
      return;
    }
    setState(() => _tabIndex = index);
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic);
  }

  void _onPageChanged(int index) {
    setState(() => _tabIndex = index);
  }

  void _ensureTabIndexInRange(int tabCount) {
    if (_tabIndex < tabCount) {
      return;
    }
    final next = tabCount - 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (_tabIndex >= tabCount) {
        setState(() => _tabIndex = next);
        if (_pageController.hasClients) {
          _pageController.jumpToPage(next);
        }
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
            final showAdminTab = _shouldShowAdminTab(profile, snapshot);
            final contentTabCount = 4 + (showAdminTab ? 1 : 0);
            final profileTabIndex = contentTabCount;
            final tabCount = contentTabCount + 1;
            _ensureTabIndexInRange(tabCount);
            // final appBarTitle = _tabIndex == profileTabIndex ? 'Profile' : 'Welcome  ${_shellTitle(snapshot, profile)}';
            final avatarLabel = _shellAvatarLabel(snapshot, profile);
            final avatarUrl = _shellAvatarPhoto(snapshot, profile);

            return Scaffold(
              extendBody: true,
              //appBar: AppBar(title: Text(appBarTitle)),
              appBar: AppBar(
                title: Align(
                  child: Semantics(
                    label: 'Supra',
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 60, maxWidth: 220),
                      child: Assets.images.homeDarkMode.image(fit: BoxFit.cover, alignment: Alignment.centerLeft),
                    ),
                  ),
                ),
              ),
              body: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  HomeOverviewTab(onOpenTab: (i) => _goToTab(i, tabCount)),
                  const BookingsPage(),
                  const FixturesPage(),
                  const LaddersPage(),
                  if (showAdminTab) const AdminHubPage(),
                  const ProfileStubPage(embedInShell: true),
                ],
              ),
              bottomNavigationBar: _DupraDockNav(
                scheme: scheme,
                selectedIndex: _tabIndex,
                showAdminTab: showAdminTab,
                profileTabIndex: profileTabIndex,
                avatarDisplayName: avatarLabel,
                avatarImageUrl: avatarUrl,
                onTabChange: (i) => _goToTab(i, tabCount),
              ),
            );
          },
        );
      },
    );
  }
}
