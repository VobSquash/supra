import 'dart:async';

import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dupra/presentation/admin/admin_member_profile_edit_page.dart';
import 'package:dupra/presentation/admin/data/admin_profiles_filters.dart';
import 'package:dupra/presentation/shell/shell_tab_insets.dart';
import 'package:dupra/presentation/users/data/users_directory_lead_letter.dart';
import 'package:dupra/presentation/users/users_directory_loaded_panel.dart';
import 'package:dupra/presentation/users/data/users_directory_metrics.dart';
import 'package:dupra/presentation/users/users_directory_search_bar.dart';
import 'package:dupra/presentation/users/users_directory_tile.dart';
import 'package:dupra/presentation/users/users_profiles_load_error.dart';
import 'package:dupra/presentation/users/users_stale_refresh_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Admin shell — full roster split into Active and Inactive tabs with shared name search.
class AdminUsersPlaceholderPage extends StatefulWidget {
  const AdminUsersPlaceholderPage({super.key});

  @override
  State<AdminUsersPlaceholderPage> createState() => _AdminUsersPlaceholderPageState();
}

class _AdminUsersPlaceholderPageState extends State<AdminUsersPlaceholderPage>
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

/// One tab’s scrollable roster (keeps scroll + letter overlay when switching tabs).
class _AdminUsersRosterPane extends StatefulWidget {
  const _AdminUsersRosterPane({
    required this.profiles,
    required this.emptyMessage,
    required this.onPullRefresh,
    required this.onTapProfile,
    super.key,
  });

  final List<BasicProfileDTO> profiles;
  final String emptyMessage;
  final Future<void> Function() onPullRefresh;
  final ValueChanged<BasicProfileDTO> onTapProfile;

  @override
  State<_AdminUsersRosterPane> createState() => _AdminUsersRosterPaneState();
}

class _AdminUsersRosterPaneState extends State<_AdminUsersRosterPane> with AutomaticKeepAliveClientMixin {
  static const Duration _scrollLetterDismiss = Duration(milliseconds: 620);

  final _scrollController = ScrollController();

  /// [UsersDirectoryLoadedPanel] expects a controller when search is omitted; unused.
  final _unusedSearch = TextEditingController();

  final _overlay = ValueNotifier<String?>(null);
  Timer? _overlayHideTimer;

  List<BasicProfileDTO> _scrollSnapshot = const [];

  @override
  bool get wantKeepAlive => true;

  void scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollTick);
  }

  @override
  void dispose() {
    _overlayHideTimer?.cancel();
    _scrollController.removeListener(_onScrollTick);
    _unusedSearch.dispose();
    _overlay.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScrollTick() {
    _overlayHideTimer?.cancel();

    if (!mounted || !_scrollController.hasClients || _scrollSnapshot.isEmpty) {
      _overlay.value = null;
      return;
    }

    final position = _scrollController.position;
    final pixels = position.pixels.clamp(position.minScrollExtent, position.maxScrollExtent);
    final scrolledFromFirstRowTop = pixels - UsersDirectoryRowMetrics.listPaddingTop;
    final rawIndex = scrolledFromFirstRowTop <= 0
        ? 0
        : (scrolledFromFirstRowTop / UsersDirectoryRowMetrics.rowStride).floor();
    final startIndex = rawIndex.clamp(0, _scrollSnapshot.length - 1);
    final profile = _scrollSnapshot[startIndex];
    final name = profile.displayName.trim().isEmpty ? '(no name)' : profile.displayName.trim();
    final letter = usersDirectoryLeadLetter(name);
    if (_overlay.value != letter) {
      _overlay.value = letter;
    }

    _overlayHideTimer = Timer(_scrollLetterDismiss, () {
      if (mounted) {
        _overlay.value = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _scrollSnapshot = widget.profiles;

    return UsersDirectoryLoadedPanel(
      searchHintText: 'Search by name',
      showStaleBanner: false,
      showSearchField: false,
      staleMessage: '',
      searchController: _unusedSearch,
      searchQueryNotEmpty: false,
      chipSection: null,
      filteredProfiles: widget.profiles,
      scrollController: _scrollController,
      scrollLetterOverlay: _overlay,
      onSearchChanged: (_) {},
      onSearchClear: () {},
      onRefresh: widget.onPullRefresh,
      onRetryRefresh: () {},
      itemBuilder: (context, profile) {
        return UsersDirectoryTile(
          profile: profile,
          onTap: () => widget.onTapProfile(profile),
        );
      },
      emptyAfterFilterMessage: widget.emptyMessage,
    );
  }
}
