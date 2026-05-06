import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dupra/engine/accessibility/dupra_build_context_accessibility.dart';
import 'package:dupra/engine/dupra_shell_config.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/admin/admin_hub_page.dart';
import 'package:dupra/presentation/bookings/bookings_page.dart';
import 'package:dupra/presentation/fixtures/fixtures_page.dart';
import 'package:dupra/presentation/home/home_overview_tab.dart';
import 'package:dupra/presentation/ladders/ladders_page.dart';
import 'package:dupra/presentation/widgets/profile_app_bar_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:session_storage/session_storage.dart';

part 'dupra_dock_nav.dart';

String _localPartOfEmail(String email) {
  final parts = email.split('@');
  return parts.isEmpty ? '' : parts.first.trim();
}

String _appBarTitle(SessionSnapshot s) {
  final n = s.displayName?.trim();
  if (n != null && n.isNotEmpty) return n;
  final e = s.email?.trim();
  if (e != null && e.isNotEmpty) {
    final local = _localPartOfEmail(e);
    if (local.isNotEmpty) return local;
  }
  return 'Dupra';
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

String _shellTitle(SessionSnapshot? s, BasicProfileDTO? p) {
  final fromProfile = _displayFromProfile(p);
  if (fromProfile.isNotEmpty) return fromProfile;
  if (s != null) return _appBarTitle(s);
  return 'Dupra';
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

/// Root chrome: swipeable [PageView] synced with [_DupraDockNav].
class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  late final PageController _pageController;
  var _tabIndex = 0;

  int get _tabCount => DupraShellConfig.showAdminTab ? 5 : 4;

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

  void _goToTab(int index) {
    if (index < 0 || index >= _tabCount) {
      return;
    }
    setState(() => _tabIndex = index);
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic);
  }

  void _onPageChanged(int index) {
    setState(() => _tabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (prev, curr) {
        SessionSnapshot? snap(AuthState s) => s.maybeWhen(authenticated: (v) => v, orElse: () => null);
        final a = snap(prev);
        final b = snap(curr);
        return a?.displayName != b?.displayName || a?.email != b?.email || a?.avatarUrl != b?.avatarUrl;
      },
      builder: (context, authState) {
        final snapshot = authState.maybeWhen(authenticated: (s) => s, orElse: () => null);

        return BlocBuilder<UsersBloc, UsersState>(
          buildWhen: (prev, curr) => prev.currentUserProfile != curr.currentUserProfile,
          builder: (context, usersState) {
            final profile = usersState.currentUserProfile;
            final title = 'Welcome  ${_shellTitle(snapshot, profile)}';
            final avatarLabel = _shellAvatarLabel(snapshot, profile);
            final avatarUrl = _shellAvatarPhoto(snapshot, profile);

            return Scaffold(
              extendBody: true,
              appBar: AppBar(
                title: Text(title),
                actions: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ProfileAppBarAvatar(
                      displayName: avatarLabel,
                      imageUrl: avatarUrl,
                      onPressed: () => context.push('/profile-stub'),
                    ),
                  ),
                ],
              ),
              body: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  HomeOverviewTab(onOpenTab: _goToTab),
                  const BookingsPage(),
                  const FixturesPage(),
                  const LaddersPage(),
                  if (DupraShellConfig.showAdminTab) const AdminHubPage(),
                ],
              ),
              bottomNavigationBar: _DupraDockNav(
                scheme: scheme,
                selectedIndex: _tabIndex,
                tabCount: _tabCount,
                onTabChange: _goToTab,
              ),
            );
          },
        );
      },
    );
  }
}
