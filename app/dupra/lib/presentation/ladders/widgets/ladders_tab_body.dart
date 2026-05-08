part of '../ladders_page.dart';

class _LadderTabBody extends StatelessWidget {
  const _LadderTabBody({required this.items, required this.emptyLabel, required this.showLadderBreakdown});

  final List<LadderItemDTO>? items;
  final String emptyLabel;
  final bool showLadderBreakdown;

  @override
  Widget build(BuildContext context) {
    final list = items;
    if (list == null || list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            emptyLabel,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
          ),
        ),
      );
    }

    if (!showLadderBreakdown) {
      final flat = List<LadderItemDTO>.of(list)..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
      return ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        itemCount: 1,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _LadderTeamBlock(team: 0, items: flat),
          );
        },
      );
    }

    final grouped = _groupByTeamSorted(list);
    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final team = grouped[index].key;
        final rows = grouped[index].value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _LadderTeamBlock(team: team, items: rows),
        );
      },
    );
  }
}
