part of '../../admin_users_placeholder_page.dart';

class _AdminUsersManagementBody extends StatefulWidget {
  const _AdminUsersManagementBody();

  @override
  State<_AdminUsersManagementBody> createState() => _AdminUsersManagementBodyState();
}

class _AdminUsersManagementBodyState extends State<_AdminUsersManagementBody>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final GlobalKey<_AdminUsersRosterPaneState> _activePaneKey = GlobalKey();
  final GlobalKey<_AdminUsersRosterPaneState> _inactivePaneKey = GlobalKey();

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<UsersBloc>().add(const UsersEvent.onLoadBasicProfiles());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _reloadBasicProfiles() {
    context.read<UsersBloc>().add(const UsersEvent.onLoadBasicProfiles());
  }

  Future<void> _onPullToRefresh() async {
    final bloc = context.read<UsersBloc>()..add(const UsersEvent.onLoadBasicProfiles());
    try {
      await bloc.stream.timeout(const Duration(seconds: 45)).firstWhere(
            (s) =>
                s.status.status == BaseLoadingStatus.loadingSuccess ||
                s.status.status == BaseLoadingStatus.loadingFailed,
          );
    } on TimeoutException {
      // Stop the indicator even if the request stalls.
    }
  }

  Future<void> _openMemberEditor(BasicProfileDTO profile) async {
    final usersBloc = context.read<UsersBloc>();
    final popped = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        settings: const RouteSettings(name: 'AdminMemberProfileEdit'),
        builder: (routeContext) => BlocProvider<UsersBloc>.value(
          value: usersBloc,
          child: AdminMemberProfileEditPage(profile: profile),
        ),
      ),
    );
    if (!mounted || popped != true) {
      return;
    }
    context.read<UsersBloc>().add(const UsersEvent.onLoadBasicProfiles());
  }

  void _scrollBothListsToTop() {
    _activePaneKey.currentState?.scrollToTop();
    _inactivePaneKey.currentState?.scrollToTop();
  }

  String _effectiveErrorMessage(String? trimmed) =>
      (trimmed != null && trimmed.isNotEmpty) ? trimmed : 'Failed to load profiles';

  String _effectiveStaleMessage(String? trimmed) =>
      (trimmed != null && trimmed.isNotEmpty) ? trimmed : 'Could not refresh. Showing cached profiles.';

  @override
  Widget build(BuildContext context) {
    final variant = Theme.of(context).colorScheme.onSurfaceVariant;

    return Padding(
      padding: dupraShellTabPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Admin · users',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Active vs inactive · filter by name (both tabs)',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: variant),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<UsersBloc, UsersState>(
              builder: (context, state) {
                final status = state.status.status;
                final message = state.status.message?.trim();

                if (status == BaseLoadingStatus.loadingFailed && state.profiles.isEmpty) {
                  return UsersProfilesLoadError(
                    message: _effectiveErrorMessage(message),
                    onRetry: _reloadBasicProfiles,
                  );
                }

                if (state.profiles.isEmpty && status == BaseLoadingStatus.loadingSuccess) {
                  return Center(
                    child: Text('No profiles found.', style: TextStyle(color: variant)),
                  );
                }

                if (state.profiles.isEmpty) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                }

                final showStale = status == BaseLoadingStatus.loadingFailed && state.profiles.isNotEmpty;

                final activeBase = rosterSortedByDisplayName(rosterActiveSubset(state.profiles));
                final inactiveBase = rosterSortedByDisplayName(rosterInactiveSubset(state.profiles));

                final activeFiltered = filterAdminProfilesByDisplayNameParts(
                  roster: activeBase,
                  rawQuery: _searchController.text,
                );
                final inactiveFiltered = filterAdminProfilesByDisplayNameParts(
                  roster: inactiveBase,
                  rawQuery: _searchController.text,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showStale) ...[
                      UsersStaleRefreshBanner(message: _effectiveStaleMessage(message), onRetry: _reloadBasicProfiles),
                      const SizedBox(height: 12),
                    ],
                    UsersDirectorySearchBar(
                      controller: _searchController,
                      searchQueryNotEmpty: _searchController.text.trim().isNotEmpty,
                      hintText: 'Search by name',
                      onChanged: (_) => setState(_scrollBothListsToTop),
                      onClear: () {
                        _searchController.clear();
                        setState(_scrollBothListsToTop);
                      },
                    ),
                    const SizedBox(height: 8),
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(text: 'Active (${activeFiltered.length})'),
                        Tab(text: 'Inactive (${inactiveFiltered.length})'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _AdminUsersRosterPane(
                            key: _activePaneKey,
                            profiles: activeFiltered,
                            emptyMessage: 'No active profiles match that name.',
                            onPullRefresh: _onPullToRefresh,
                            onTapProfile: (p) => unawaited(_openMemberEditor(p)),
                          ),
                          _AdminUsersRosterPane(
                            key: _inactivePaneKey,
                            profiles: inactiveFiltered,
                            emptyMessage: 'No inactive profiles match that name.',
                            onPullRefresh: _onPullToRefresh,
                            onTapProfile: (p) => unawaited(_openMemberEditor(p)),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
