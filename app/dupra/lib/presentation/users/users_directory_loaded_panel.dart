import 'package:client_models/client_models.dart';
import 'package:dupra/presentation/users/users_directory_search_bar.dart';
import 'package:dupra/presentation/users/users_profile_refresh_list.dart';
import 'package:dupra/presentation/users/users_scroll_letter_overlay.dart';
import 'package:dupra/presentation/users/users_stale_refresh_banner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Search chrome, optional extras under the bar, stale banner, and refreshable scroll list + letter overlay.
class UsersDirectoryLoadedPanel extends StatelessWidget {
  const UsersDirectoryLoadedPanel({
    required this.searchHintText,
    required this.staleMessage,
    required this.searchController,
    required this.searchQueryNotEmpty,
    required this.chipSection,
    required this.filteredProfiles,
    required this.scrollController,
    required this.scrollLetterOverlay,
    required this.onSearchChanged,
    required this.onSearchClear,
    required this.onRefresh,
    required this.onRetryRefresh,
    required this.itemBuilder,
    required this.emptyAfterFilterMessage,
    this.showStaleBanner = true,
    this.showSearchField = true,
    super.key,
  });

  final String searchHintText;

  final bool showStaleBanner;

  final bool showSearchField;

  final String staleMessage;
  final TextEditingController searchController;
  final bool searchQueryNotEmpty;

  /// Placed beneath the search field (e.g. membership chips). Omit with `null`.
  final Widget? chipSection;

  final List<BasicProfileDTO> filteredProfiles;
  final ScrollController scrollController;
  final ValueListenable<String?> scrollLetterOverlay;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetryRefresh;
  final Widget Function(BuildContext context, BasicProfileDTO profile) itemBuilder;

  /// Shown inside the refresh list when filtering yields nothing while the roster is loaded.
  final String emptyAfterFilterMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showStaleBanner) ...[
          UsersStaleRefreshBanner(message: staleMessage, onRetry: onRetryRefresh),
          const SizedBox(height: 12),
        ],
        if (showSearchField) ...[
          UsersDirectorySearchBar(
            controller: searchController,
            searchQueryNotEmpty: searchQueryNotEmpty,
            onChanged: onSearchChanged,
            onClear: onSearchClear,
            hintText: searchHintText,
          ),
          if (chipSection != null) ...[
            const SizedBox(height: 10),
            chipSection!,
            const SizedBox(height: 8),
          ] else
            const SizedBox(height: 8),
        ],
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              UsersProfileRefreshList(
                scrollController: scrollController,
                onRefresh: onRefresh,
                profilesEmptyMessage: emptyAfterFilterMessage,
                profiles: filteredProfiles,
                itemBuilder: itemBuilder,
              ),
              Positioned.fill(
                child: Center(child: UsersScrollLetterOverlay(listenable: scrollLetterOverlay)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
