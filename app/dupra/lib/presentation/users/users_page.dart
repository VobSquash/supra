import 'dart:async';

import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dupra/engine/accessibility/dupra_build_context_accessibility.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/widgets/dupra_icon_row.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'data/users_directory_list_metrics.dart';
part 'widgets/users_directory_loaded_panel.dart';
part 'widgets/users_directory_tile.dart';
part 'widgets/users_membership_chip_row.dart';
part 'data/users_membership_filter.dart';
part 'widgets/users_profile_refresh_list.dart';
part 'widgets/users_profiles_load_error.dart';
part 'widgets/users_search_bar.dart';
part 'widgets/users_stale_refresh_banner.dart';
part 'widgets/users_scroll_letter_overlay.dart';

/// Lists active profiles from [UsersBloc], with search and membership filters.
class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  static const Duration _scrollLetterDismiss = Duration(milliseconds: 620);

  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final ValueNotifier<String?> _scrollLetterOverlay = ValueNotifier<String?>(null);
  Timer? _scrollLetterHideTimer;
  List<BasicProfileDTO> _directoryScrollSnapshot = const [];
  UsersMembershipFilter _membershipSegment = UsersMembershipFilter.all;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onDirectoryScrollPositionChanged);
    context.read<UsersBloc>().add(const UsersEvent.onLoadActiveProfiles());
  }

  @override
  void dispose() {
    _scrollLetterHideTimer?.cancel();
    _scrollController.removeListener(_onDirectoryScrollPositionChanged);
    _scrollLetterOverlay.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onDirectoryScrollPositionChanged() {
    _scrollLetterHideTimer?.cancel();

    if (!mounted ||
        !_scrollController.hasClients ||
        _directoryScrollSnapshot.isEmpty) {
      _scrollLetterOverlay.value = null;
      return;
    }

    final position = _scrollController.position;
    final pixels = position.pixels.clamp(position.minScrollExtent, position.maxScrollExtent);
    final scrolledFromFirstRowTop = pixels - UsersDirectoryRowMetrics.listPaddingTop;
    final rawIndex =
        scrolledFromFirstRowTop <= 0 ? 0 : (scrolledFromFirstRowTop / UsersDirectoryRowMetrics.rowStride).floor();
    final startIndex = rawIndex.clamp(0, _directoryScrollSnapshot.length - 1);
    final profile = _directoryScrollSnapshot[startIndex];
    final name =
        profile.displayName.trim().isEmpty ? '(no name)' : profile.displayName.trim();
    final letter = usersDirectoryLeadLetter(name);
    if (_scrollLetterOverlay.value != letter) {
      _scrollLetterOverlay.value = letter;
    }

    _scrollLetterHideTimer = Timer(_scrollLetterDismiss, () {
      if (mounted) {
        _scrollLetterOverlay.value = null;
      }
    });
  }

  void _scrollListToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _reloadActiveProfiles() {
    context.read<UsersBloc>().add(const UsersEvent.onLoadActiveProfiles());
  }

  Future<void> _onPullToRefresh() async {
    final bloc = context.read<UsersBloc>()..add(const UsersEvent.onLoadActiveProfiles());
    try {
      await bloc.stream
          .timeout(const Duration(seconds: 45))
          .firstWhere(
            (s) =>
                s.status.status == BaseLoadingStatus.loadingSuccess ||
                s.status.status == BaseLoadingStatus.loadingFailed,
          );
    } on TimeoutException {
      // Stop the indicator even if the request stalls.
    }
  }

  void _openProfile(BasicProfileDTO profile) {
    context.pushNamed('user-profile', extra: profile);
  }

  String _effectiveErrorMessage(String? trimmed) =>
      (trimmed != null && trimmed.isNotEmpty) ? trimmed : 'Failed to load profiles';

  String _effectiveStaleMessage(String? trimmed) =>
      (trimmed != null && trimmed.isNotEmpty) ? trimmed : 'Could not refresh. Showing cached profiles.';

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 16);

    final body = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: BlocBuilder<UsersBloc, UsersState>(
              builder: (context, state) {
                final status = state.status.status;
                final message = state.status.message?.trim();

                if (status == BaseLoadingStatus.loadingFailed && state.profiles.isEmpty) {
                  return _UsersProfilesLoadError(
                    message: _effectiveErrorMessage(message),
                    onRetry: _reloadActiveProfiles,
                  );
                }

                if (state.profiles.isEmpty && status == BaseLoadingStatus.loadingSuccess) {
                  return const Center(child: Text('No active profiles found.'));
                }

                if (state.profiles.isEmpty) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                }

                final filtered = filterUsersProfilesForDirectory(
                  profiles: state.profiles,
                  rawQuery: _searchController.text,
                  membership: _membershipSegment,
                );

                final showStale = status == BaseLoadingStatus.loadingFailed && state.profiles.isNotEmpty;

                _directoryScrollSnapshot = filtered;

                return _UsersDirectoryLoadedPanel(
                  showStaleBanner: showStale,
                  staleMessage: _effectiveStaleMessage(message),
                  searchController: _searchController,
                  searchQueryNotEmpty: _searchController.text.trim().isNotEmpty,
                  membershipSelected: _membershipSegment,
                  filteredProfiles: filtered,
                  scrollController: _scrollController,
                  scrollLetterOverlay: _scrollLetterOverlay,
                  onSearchChanged: (_) => setState(_scrollListToTop),
                  onSearchClear: () {
                    _searchController.clear();
                    setState(_scrollListToTop);
                  },
                  onMembershipSelected: (f) {
                    setState(() {
                      _membershipSegment = f;
                      _scrollListToTop();
                    });
                  },
                  onRefresh: _onPullToRefresh,
                  onRetryRefresh: _reloadActiveProfiles,
                  onOpenProfile: _openProfile,
                );
              },
            ),
          ),
        ],
      ),
    );

    // if (widget.embedInShell) {
    //   return body;
    // }

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: body,
    );
  }
}
