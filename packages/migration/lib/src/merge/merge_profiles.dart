import '../models/merged_parse_profile.dart';

/// Joins Parse `Profile` rows with `ProfileExtensions` via `ProfileId.objectId`.
///
/// Throws if any profile is missing an extension (your data invariant).
List<MergedParseProfile> mergeProfilesAndExtensions({
  required List<Map<String, dynamic>> profiles,
  required List<Map<String, dynamic>> extensions,
}) {
  final byObjectId = <String, Map<String, dynamic>>{
    for (final p in profiles) p['objectId'] as String: p,
  };

  final usedProfileIds = <String>{};
  final merged = <MergedParseProfile>[];
  final seenExtensionProfileIds = <String>{};

  for (final ext in extensions) {
    final pointer = ext['ProfileId'];
    if (pointer is! Map<String, dynamic>) {
      throw StateError('ProfileExtensions row missing ProfileId pointer: $ext');
    }
    final profileObjectId = pointer['objectId'] as String?;
    if (profileObjectId == null || profileObjectId.isEmpty) {
      throw StateError('ProfileExtensions ProfileId.objectId missing: $ext');
    }

    if (!seenExtensionProfileIds.add(profileObjectId)) {
      throw StateError('Duplicate ProfileExtensions for Profile objectId=$profileObjectId');
    }

    final profile = byObjectId[profileObjectId];
    if (profile == null) {
      throw StateError(
        'ProfileExtensions points at unknown Profile objectId=$profileObjectId',
      );
    }

    usedProfileIds.add(profileObjectId);
    merged.add(MergedParseProfile(profile: profile, extension: ext));
  }

  if (usedProfileIds.length != profiles.length) {
    final missing = byObjectId.keys.where((id) => !usedProfileIds.contains(id)).toList();
    throw StateError(
      'Not every Profile has a ProfileExtensions row. Missing for objectIds: $missing',
    );
  }

  if (merged.length != profiles.length) {
    throw StateError(
      'Merge count mismatch: profiles=${profiles.length} merged=${merged.length}',
    );
  }

  return merged;
}
