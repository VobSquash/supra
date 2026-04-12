import 'package:client_models/client_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../engine/launch_service.dart';
import 'location_map_asset.dart';

const _launch = LaunchService();

/// Opens a sheet with club map, name, coordinates, and entry to installed map apps.
Future<void> showLocationDetailSheet(
  BuildContext context, {
  required LocationsItemDTO location,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
          child: _LocationDetailBody(
            location: location,
            parentContext: context,
          ),
        ),
      );
    },
  );
}

/// Parses semantic lat/lng for [map_launcher.Coords].
///
/// Migrated `locations` rows (and the legacy client) store values with **column names
/// reversed** vs WGS84: the string in [LocationsItemDTO.longitude] is the **latitude**,
/// and [LocationsItemDTO.latitude] is the **longitude** — same as the old
/// `Coords(parse(dto.longitude), parse(dto.latitude))` pattern.
Coords? _parseCoords(LocationsItemDTO loc) {
  final latStr = loc.longitude?.trim();
  final lngStr = loc.latitude?.trim();
  if (latStr == null || lngStr == null || latStr.isEmpty || lngStr.isEmpty) return null;
  final lat = double.tryParse(latStr);
  final lng = double.tryParse(lngStr);
  if (lat == null || lng == null) return null;
  if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return null;
  return Coords(lat, lng);
}

class _LocationDetailBody extends StatelessWidget {
  const _LocationDetailBody({
    required this.location,
    required this.parentContext,
  });

  final LocationsItemDTO location;
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final title = (location.name ?? '').trim().isEmpty ? 'Location' : location.name!.trim();
    final mapUri = locationStaticMapAsset(location);
    final coords = _parseCoords(location);
    final coordLabel =
        coords != null ? '${coords.latitude}, ${coords.longitude}' : '—';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
                color: scheme.onSurface,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: mapUri != null
                  ? LocationMapCover(
                      uri: mapUri,
                      fallback: _MapPlaceholder(scheme: scheme),
                    )
                  : _MapPlaceholder(scheme: scheme),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.location_on_outlined, color: scheme.primary),
            title: Text(
              'Coordinates',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            subtitle: Text(
              coordLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.75),
                  ),
            ),
            trailing: coords != null
                ? FilledButton.tonalIcon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showInstalledMapsSheet(parentContext, location: location, coords: coords);
                    },
                    icon: const Icon(Icons.map_outlined, size: 20),
                    label: const Text('Maps'),
                  )
                : null,
          ),
          if (coords == null) ...[
            const SizedBox(height: 8),
            Text(
              'No coordinates for this venue; maps cannot be opened.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.65),
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.surfaceContainerHighest,
            scheme.surfaceContainerHigh.withValues(alpha: 0.85),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.map_outlined,
          size: 56,
          color: scheme.onSurface.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}

/// Lists installed map apps; falls back to Google Maps in the browser.
Future<void> showInstalledMapsSheet(
  BuildContext context, {
  required LocationsItemDTO location,
  required Coords coords,
}) {
  final title = (location.name ?? '').trim().isEmpty ? 'Location' : location.name!.trim();
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
          child: _InstalledMapsBody(
            coords: coords,
            markerTitle: title,
            parentContext: context,
          ),
        ),
      );
    },
  );
}

class _InstalledMapsBody extends StatefulWidget {
  const _InstalledMapsBody({
    required this.coords,
    required this.markerTitle,
    required this.parentContext,
  });

  final Coords coords;
  final String markerTitle;
  final BuildContext parentContext;

  @override
  State<_InstalledMapsBody> createState() => _InstalledMapsBodyState();
}

class _InstalledMapsBodyState extends State<_InstalledMapsBody> {
  late Future<List<AvailableMap>> _future;

  @override
  void initState() {
    super.initState();
    _future = MapLauncher.installedMaps;
  }

  Future<void> _openInBrowser() async {
    final messenger = ScaffoldMessenger.maybeOf(widget.parentContext);
    final ok = await _launch.launchGoogleMapsSearch(
      widget.coords.latitude,
      widget.coords.longitude,
      placeLabel: widget.markerTitle,
    );
    if (!mounted) return;
    if (!ok && messenger != null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not open maps in the browser.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FutureBuilder<List<AvailableMap>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Could not detect installed map apps.',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _openInBrowser();
                  },
                  child: const Text('Open in Google Maps (browser)'),
                ),
              ],
            ),
          );
        }

        final maps = snapshot.data ?? const <AvailableMap>[];
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.55,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 12, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Open in Maps',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: scheme.onSurface,
                    ),
                  ],
                ),
              ),
              if (maps.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Text(
                    'No map apps were found on this device.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.75),
                        ),
                  ),
                ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  itemCount: maps.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final map = maps[i];
                    return ListTile(
                      leading: _MapAppIcon(mapType: map.mapType),
                      title: Text(map.mapName),
                      onTap: () async {
                        final messenger = ScaffoldMessenger.maybeOf(widget.parentContext);
                        Navigator.pop(context);
                        try {
                          await map.showMarker(coords: widget.coords, title: widget.markerTitle);
                        } catch (_) {
                          messenger?.showSnackBar(
                            SnackBar(content: Text('Could not open ${map.mapName}.')),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _openInBrowser();
                  },
                  icon: const Icon(Icons.public, size: 20),
                  label: const Text('Open in browser instead'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MapAppIcon extends StatelessWidget {
  const _MapAppIcon({required this.mapType});

  final MapType mapType;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final path = 'assets/icons/${mapType.name}.svg';
    return SizedBox(
      width: 32,
      height: 32,
      child: SvgPicture.asset(
        path,
        package: 'map_launcher',
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) =>
            Icon(Icons.map, color: scheme.onSurface.withValues(alpha: 0.7)),
      ),
    );
  }
}
