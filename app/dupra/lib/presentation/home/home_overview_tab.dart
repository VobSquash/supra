import 'package:dupra/engine/member_shell_tab.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/home/data/home_overview_destination.dart';
import 'package:dupra/presentation/home/data/home_section_item.dart';
import 'package:flutter/material.dart';

part 'widgets/home_section.dart';

typedef HomeOverviewNavigate = void Function(BuildContext context, HomeOverviewDestination destination);

/// First [PageView] tab: section tiles with optional [HomeSectionItem.leadingEdgeAccent].
class HomeOverviewTab extends StatelessWidget {
  const HomeOverviewTab({required this.onNavigate, super.key});

  final HomeOverviewNavigate onNavigate;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return ListView(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 24 + bottomInset + 72),
      children: [
        HomeSection(
          title: 'Play',
          items: const [
            HomeSectionItem(
              title: 'Bookings',
              icon: Icons.calendar_month_rounded,
              subtitle: 'Grid and list layouts (placeholder)',
              leadingEdgeAccent: true,
              destination: HomeShellTabDestination(MemberShellTab.bookings),
            ),
            HomeSectionItem(
              title: 'Fixtures',
              icon: Icons.sports_tennis_rounded,
              subtitle: 'Home / away blocks — equal height in production',
              leadingEdgeAccent: true,
              accentColor: DupraColors.success,
              destination: HomeShellTabDestination(MemberShellTab.fixtures),
            ),
          ],
          onNavigate: onNavigate,
        ),
        HomeSection(
          title: 'Club',
          cardAccent: DupraColors.tertiary,
          items: const [
            HomeSectionItem(
              title: 'Ladders',
              icon: Icons.emoji_events_rounded,
              subtitle: 'Carry forward legacy layout',
              leadingEdgeAccent: true,
              destination: HomeShellTabDestination(MemberShellTab.ladders),
            ),
            HomeSectionItem(
              title: 'Users',
              icon: Icons.people_rounded,
              subtitle: 'List of users',
              leadingEdgeAccent: true,
              accentColor: DupraColors.error,
              destination: HomePushRouteDestination(HomePushRoute.users),
            ),
            HomeSectionItem(
              title: 'Calculator',
              icon: Icons.calculate_rounded,
              subtitle: 'Pay for your refreshments',
              leadingEdgeAccent: true,
              accentColor: DupraColors.calculator,
              destination: HomePushRouteDestination(HomePushRoute.calculator),
            ),
          ],
          onNavigate: onNavigate,
        ),
      ],
    );
  }
}
