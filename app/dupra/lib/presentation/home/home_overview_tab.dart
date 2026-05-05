import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/home/data/home_section_item.dart';
import 'package:flutter/material.dart';

part 'widgets/home_section.dart';

/// First [PageView] tab: section tiles with optional [HomeSectionItem.leadingEdgeAccent].
class HomeOverviewTab extends StatelessWidget {
  const HomeOverviewTab({required this.onOpenTab, super.key});

  final ValueChanged<int> onOpenTab;

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
            ),
            HomeSectionItem(
              title: 'Fixtures',
              icon: Icons.sports_tennis_rounded,
              subtitle: 'Home / away blocks — equal height in production',
              leadingEdgeAccent: true,
            ),
          ],
          onItemTap: (i) {
            if (i == 0) {
              onOpenTab(1);
            } else {
              onOpenTab(2);
            }
          },
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
            ),
          ],
          onItemTap: (_) => onOpenTab(3),
        ),
      ],
    );
  }
}
