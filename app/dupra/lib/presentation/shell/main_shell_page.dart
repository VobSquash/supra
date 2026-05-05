import 'package:dupra/engine/dupra_shell_config.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/admin/admin_hub_page.dart';
import 'package:dupra/presentation/bookings/bookings_page.dart';
import 'package:dupra/presentation/fixtures/fixtures_page.dart';
import 'package:dupra/presentation/home/home_overview_tab.dart';
import 'package:dupra/presentation/ladders/ladders_page.dart';
import 'package:dupra/presentation/widgets/profile_app_bar_avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'dupra_dock_nav.dart';

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
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _onPageChanged(int index) {
    setState(() => _tabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('Dupra'),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: ProfileAppBarAvatar(
              displayName: 'Member',
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
  }
}
