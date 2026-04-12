import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'location_map_asset.dart';
import 'location_sheet.dart';

class LocationsTestPage extends StatefulWidget {
  const LocationsTestPage({super.key, this.nested = false});

  /// When true, omits outer [Scaffold]/[AppBar] so a parent shell can host this page.
  final bool nested;

  @override
  State<LocationsTestPage> createState() => _LocationsTestPageState();
}

class _LocationsTestPageState extends State<LocationsTestPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _searchActive = false;

  @override
  void initState() {
    super.initState();
    context.read<LocationsBloc>().add(const LocationsEvent.onLoadLocations());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() => _searchActive = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  void _closeSearch() {
    setState(() {
      _searchActive = false;
      _searchController.clear();
    });
  }

  List<LocationsItemDTO> _locationsMatchingSearch(List<LocationsItemDTO> all) {
    if (!_searchActive) return all;
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all
        .where((loc) => (loc.name ?? '').toLowerCase().contains(q))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationsBloc, LocationsState>(
      builder: (context, state) {
        final status = state.status.status;
        final message = state.status.message?.trim();

        final allLocations = state.locations;
        final filtered = status == BaseLoadingStatus.loadingSuccess && allLocations.isNotEmpty
            ? _locationsMatchingSearch(allLocations)
            : allLocations;

        Widget body;
        if (status == BaseLoadingStatus.loading) {
          body = const Center(child: CircularProgressIndicator.adaptive());
        } else if (status == BaseLoadingStatus.loadingFailed) {
          body = Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                message?.isNotEmpty == true
                    ? message!
                    : 'Failed to load locations',
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (allLocations.isEmpty) {
          body = const Center(child: Text('No locations found.'));
        } else if (filtered.isEmpty) {
          body = Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No locations match "${_searchController.text.trim()}".',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        } else {
          body = LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 720;
              final pad = wide ? 24.0 : 16.0;
              final maxW = wide ? 560.0 : double.infinity;
              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxW),
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(pad, pad, pad, pad + 8),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final loc = filtered[index];
                      return _LocationClubCard(
                        location: loc,
                        onTap: () => showLocationDetailSheet(context, location: loc),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }

        if (widget.nested) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.35),
                child: _searchActive
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close),
                              tooltip: 'Close search',
                              onPressed: _closeSearch,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                decoration: const InputDecoration(
                                  hintText: 'Search by name',
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                textInputAction: TextInputAction.search,
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            if (_searchController.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.clear),
                                tooltip: 'Clear',
                                onPressed: () => setState(_searchController.clear),
                              ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  'Locations',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.search),
                              tooltip: 'Search locations',
                              onPressed: _openSearch,
                            ),
                          ],
                        ),
                      ),
              ),
              Expanded(child: body),
            ],
          );
        }

        return Scaffold(
          appBar: _searchActive
              ? AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    tooltip: 'Close search',
                    onPressed: _closeSearch,
                  ),
                  title: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: const InputDecoration(
                      hintText: 'Search by name',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    textInputAction: TextInputAction.search,
                    onChanged: (_) => setState(() {}),
                  ),
                  actions: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: 'Clear',
                        onPressed: () => setState(_searchController.clear),
                      ),
                  ],
                )
              : AppBar(
                  title: const Text('Locations'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      tooltip: 'Search locations',
                      onPressed: _openSearch,
                    ),
                  ],
                ),
          body: body,
        );
      },
    );
  }
}

class _LocationClubCard extends StatelessWidget {
  const _LocationClubCard({
    required this.location,
    required this.onTap,
  });

  final LocationsItemDTO location;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final name = (location.name ?? '').trim().isEmpty ? '(no name)' : location.name!.trim();
    final mapUri = locationStaticMapAsset(location);
    final hasCoords = (location.latitude?.trim().isNotEmpty ?? false) &&
        (location.longitude?.trim().isNotEmpty ?? false);

    return Material(
      color: scheme.surfaceContainerHigh,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (mapUri != null)
                    LocationMapCover(
                      uri: mapUri,
                      fallback: _CardMapFallback(scheme: scheme),
                    )
                  else
                    _CardMapFallback(scheme: scheme),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.1),
                            Colors.black.withValues(alpha: 0.72),
                          ],
                          stops: const [0.35, 0.65, 1],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 14,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  height: 1.15,
                                  shadows: const [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 6,
                                      color: Color(0x66000000),
                                    ),
                                  ],
                                ),
                          ),
                        ),
                        if (hasCoords)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.touch_app_outlined, size: 16, color: Colors.white.withValues(alpha: 0.95)),
                                const SizedBox(width: 6),
                                Text(
                                  'Details',
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
              child: Row(
                children: [
                  Icon(Icons.place_outlined, size: 20, color: scheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hasCoords ? 'Tap for map & directions' : 'Tap for venue details',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.75),
                          ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: scheme.onSurface.withValues(alpha: 0.45)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardMapFallback extends StatelessWidget {
  const _CardMapFallback({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primaryContainer.withValues(alpha: 0.65),
            scheme.tertiaryContainer.withValues(alpha: 0.5),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.map_outlined,
          size: 64,
          color: scheme.onSurface.withValues(alpha: 0.28),
        ),
      ),
    );
  }
}
