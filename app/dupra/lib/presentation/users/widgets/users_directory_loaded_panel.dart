part of '../users_page.dart';

/// Search, chips, stale banner, and refreshable list for the loaded-users state.
class _UsersDirectoryLoadedPanel extends StatelessWidget {
  const _UsersDirectoryLoadedPanel({
    required this.showStaleBanner,
    required this.staleMessage,
    required this.searchController,
    required this.searchQueryNotEmpty,
    required this.membershipSelected,
    required this.filteredProfiles,
    required this.scrollController,
    required this.scrollLetterOverlay,
    required this.onSearchChanged,
    required this.onSearchClear,
    required this.onMembershipSelected,
    required this.onRefresh,
    required this.onRetryRefresh,
    required this.onOpenProfile,
  });

  final bool showStaleBanner;
  final String staleMessage;
  final TextEditingController searchController;
  final bool searchQueryNotEmpty;
  final UsersMembershipFilter membershipSelected;
  final List<BasicProfileDTO> filteredProfiles;
  final ScrollController scrollController;
  final ValueListenable<String?> scrollLetterOverlay;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;
  final ValueChanged<UsersMembershipFilter> onMembershipSelected;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetryRefresh;
  final ValueChanged<BasicProfileDTO> onOpenProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showStaleBanner) ...[
          _UsersStaleRefreshBanner(
            message: staleMessage,
            onRetry: onRetryRefresh,
          ),
          const SizedBox(height: 12),
        ],
        _UsersSearchBar(
          controller: searchController,
          searchQueryNotEmpty: searchQueryNotEmpty,
          onChanged: onSearchChanged,
          onClear: onSearchClear,
        ),
        const SizedBox(height: 10),
        _UsersMembershipChipRow(
          selected: membershipSelected,
          onSelected: onMembershipSelected,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _UsersProfileRefreshList(
                scrollController: scrollController,
                onRefresh: onRefresh,
                profilesEmptyMessage: 'No profiles match your search or filters.',
                profiles: filteredProfiles,
                itemBuilder: (context, profile) {
                  return _UsersDirectoryTile(
                    profile: profile,
                    onTap: () => onOpenProfile(profile),
                  );
                },
              ),
              Positioned.fill(
                child: Center(
                  child: _UsersScrollLetterOverlay(listenable: scrollLetterOverlay),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
