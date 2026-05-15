part of '../../admin_users_placeholder_page.dart';

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
