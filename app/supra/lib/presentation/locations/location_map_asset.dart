import 'package:client_models/client_models.dart';
import 'package:flutter/material.dart';

/// Bundled asset path for the club map image, or `null` if none can be inferred.
///
/// Resolution order:
/// 1. [LocationsItemDTO.imageUrl] when it is an app `assets/…` or `packages/…` path.
/// 2. `assets/images/locations/{basename}.jpg` from [LocationsItemDTO.name]: lowercase,
///    spaces removed, alphanumeric only (e.g. `"Bergvliet"` → `bergvliet.jpg`).
/// 3. Same basename rule on [LocationsItemDTO.lookup], then [prefix], when name cannot
///    produce a basename.
String? locationStaticMapAsset(LocationsItemDTO loc) {
  final bundled = loc.imageUrl?.trim();
  if (bundled != null && bundled.isNotEmpty && (bundled.startsWith('assets/') || bundled.startsWith('packages/'))) {
    return bundled;
  }
  final fromName = _baseFromClubFileName(loc.name);
  if (fromName != null) {
    return 'assets/images/locations/$fromName.jpg';
  }

  return null;
}

String? _baseFromClubFileName(String? raw) {
  final t = raw?.toLowerCase().trim();
  if (t == null || t.isEmpty) return null;
  final s = t.replaceAll(RegExp(r'\s+'), '').replaceAll(RegExp(r'[^a-z0-9]'), '');
  return s.isEmpty ? null : s;
}

/// Loads a bundled map image with a shared error fallback.
class LocationMapCover extends StatelessWidget {
  const LocationMapCover({super.key, required this.uri, required this.fallback});

  final String uri;
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    return Image.asset(uri, fit: BoxFit.cover, errorBuilder: (_, _, _) => fallback);
  }
}
