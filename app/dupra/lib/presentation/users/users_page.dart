import 'dart:async';

import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dupra/presentation/users/data/users_directory_lead_letter.dart';
import 'package:dupra/presentation/users/users_directory_loaded_panel.dart';
import 'package:dupra/presentation/users/data/users_directory_metrics.dart';
import 'package:dupra/presentation/users/users_directory_tile.dart';
import 'package:dupra/presentation/users/users_membership_chip_row.dart';
import 'package:dupra/presentation/users/data/users_membership_filter.dart';
import 'package:dupra/presentation/users/users_profiles_load_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    final rawIndex = scrolledFromFirstRowTop <= 0
        ? 0
        : (scrolledFromFirstRowTop / UsersDirectoryRowMetrics.rowStride).floor();
    final startIndex = rawIndex.clamp(0, _directoryScrollSnapshot.length - 1);
    final profile = _directoryScrollSnapshot[startIndex];
    final name = profile.displayName.trim().isEmpty ? '(no name)' : profile.displayName.trim();
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
      await bloc.stream.timeout(const Duration(seconds: 45)).firstWhere(
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
                  return UsersProfilesLoadError(
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

                return UsersDirectoryLoadedPanel(
                  searchHintText: 'Search name, email, phone…',
                  showStaleBanner: showStale,
                  staleMessage: _effectiveStaleMessage(message),
                  searchController: _searchController,
                  searchQueryNotEmpty: _searchController.text.trim().isNotEmpty,
                  chipSection: UsersMembershipChipRow(
                    selected: _membershipSegment,
                    onSelected: (f) {
                      setState(() {
                        _membershipSegment = f;
                        _scrollListToTop();
                      });
                    },
                  ),
                  filteredProfiles: filtered,
                  scrollController: _scrollController,
                  scrollLetterOverlay: _scrollLetterOverlay,
                  onSearchChanged: (_) => setState(_scrollListToTop),
                  onSearchClear: () {
                    _searchController.clear();
                    setState(_scrollListToTop);
                  },
                  onRefresh: _onPullToRefresh,
                  onRetryRefresh: _reloadActiveProfiles,
                  itemBuilder: (context, profile) {
                    return UsersDirectoryTile(profile: profile, onTap: () => _openProfile(profile));
                  },
                  emptyAfterFilterMessage: 'No profiles match your search or filters.',
                );
              },
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: body,
    );
  }
}
