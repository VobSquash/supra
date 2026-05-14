part of '../ladders_page.dart';

class _LadderPlayerRow extends StatelessWidget {
  const _LadderPlayerRow({
    required this.item,
    required this.rankWithinTeam,
  });

  final LadderItemDTO item;
  final int rankWithinTeam;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final name = item.profile?.displayName.trim();
    final titleText = (name != null && name.isNotEmpty) ? name : '(No name)';
    return Padding(
      padding: context.dupraScaledEdgeInsetsSymmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        contentPadding: context.dupraScaledEdgeInsetsSymmetric(horizontal: 8),
        leading: DupraAvatar(
          displayName: titleText,
          imageUrl: item.profile?.profilePictureUrl,
          radius: context.dupraScaledIconSize(22),
        ),
        title: Text(
          titleText,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Rank $rankWithinTeam',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.62),
              ),
        ),
        trailing: (item.canBeChallenged ?? false)
            ? Tooltip(
                message: 'Can be challenged',
                child: Icon(
                  Icons.sports_tennis,
                  color: scheme.primary,
                  size: context.dupraScaledIconSize(22),
                ),
              )
            : null,
      ),
    );
  }
}
