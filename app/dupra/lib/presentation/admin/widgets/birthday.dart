part of '../admin_home_placeholder_page.dart';

/// Birthdays horizon (tiles, refresh, load / error / empty states).
class _AdminHomeBirthdays extends StatelessWidget {
  const _AdminHomeBirthdays({
    required this.variant,
    required this.today,
    required this.loading,
    required this.failed,
    required this.message,
    required this.profiles,
    required this.onReload,
  });

  final Color variant;
  final DateTime today;
  final bool loading;
  final bool failed;
  final String? message;
  final List<BasicProfileDTO> profiles;
  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final upcoming = upcomingAdminBirthdays(
      profiles,
      DateTime.now(),
      daysAheadInclusive: AdminHomePlaceholderPage.birthdayHorizonDaysAheadInclusive,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'Birthdays · next 7 days',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            IconButton.outlined(
              tooltip: 'Refresh member list',
              onPressed: loading ? null : onReload,
              icon: loading
                  ? SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.primary),
                    )
                  : const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        if (failed && (message?.isNotEmpty ?? false))
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(message!, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    FilledButton.tonal(onPressed: onReload, child: const Text('Try again')),
                  ],
                ),
              ),
            ),
          ),
        if (loading && profiles.isEmpty && !failed) ...[
          const SizedBox(height: 24),
          const Center(child: CircularProgressIndicator()),
        ],
        if (!loading || profiles.isNotEmpty)
          ...upcoming.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final label = adminProfileDisplayLabel(item.profile);
            final rawPic = item.profile.profilePictureUrl?.trim();
            final picUrl = rawPic != null && rawPic.isNotEmpty ? rawPic : null;

            return Padding(
              padding: EdgeInsets.only(top: index == 0 ? 4 : 10),
              child: DupraUpcomingBirthdayTile(
                displayName: label,
                imageUrl: picUrl,
                celebrationDay: item.celebrationLocal,
                today: today,
              ),
            );
          }),
        if (!loading && !failed && profiles.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 28),
            child: Text(
              'No active profiles loaded.',
              style: theme.textTheme.bodyLarge?.copyWith(color: variant),
            ),
          ),
        if (!loading && !failed && profiles.isNotEmpty && upcoming.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'No birthdays in this window.',
              style: theme.textTheme.bodyLarge?.copyWith(color: variant),
            ),
          ),
      ],
    );
  }
}
