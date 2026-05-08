part of '../ladders_page.dart';

class _LadderTeamBlock extends StatelessWidget {
  const _LadderTeamBlock({required this.team, required this.items});

  final int team;
  final List<LadderItemDTO> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = _accentForTeam(team);
    final title = _leagueTitle(team);

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHigh,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outline.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: accent, width: 4)),
              color: accent.withValues(alpha: 0.75),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.groups_2_outlined, color: scheme.onSurface.withValues(alpha: 0.65), size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                  ),
                  Text(
                    '${items.length} ${items.length == 1 ? 'player' : 'players'}',
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: scheme.onSurface.withValues(alpha: 0.65)),
                  ),
                ],
              ),
            ),
          ),
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) Divider(height: 1, color: scheme.outline),
            _LadderPlayerRow(item: items[i], rankWithinTeam: i + 1),
          ],
        ],
      ),
    );
  }
}
