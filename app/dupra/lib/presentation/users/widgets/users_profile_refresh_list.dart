part of '../users_page.dart';

class _UsersProfileRefreshList extends StatelessWidget {
  const _UsersProfileRefreshList({
    required this.scrollController,
    required this.onRefresh,
    required this.profilesEmptyMessage,
    required this.profiles,
    required this.itemBuilder,
  });

  final ScrollController scrollController;
  final Future<void> Function() onRefresh;
  final String profilesEmptyMessage;
  final List<BasicProfileDTO> profiles;
  final Widget Function(BuildContext context, BasicProfileDTO profile) itemBuilder;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72);

    return RefreshIndicator.adaptive(
      onRefresh: onRefresh,
      child: profiles.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              children: [
                const SizedBox(height: 48),
                Text(
                  profilesEmptyMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: muted),
                ),
              ],
            )
          : CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(
                    top: UsersDirectoryRowMetrics.listPaddingTop,
                    bottom: UsersDirectoryRowMetrics.listPaddingBottom,
                  ),
                  sliver: SliverFixedExtentList(
                    itemExtent: UsersDirectoryRowMetrics.rowStride,
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final profile = profiles[index];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: UsersDirectoryRowMetrics.tileHeight,
                              width: double.infinity,
                              child: ClipRect(
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: itemBuilder(context, profile),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: UsersDirectoryRowMetrics.separatorHeight,
                            ),
                          ],
                        );
                      },
                      childCount: profiles.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
