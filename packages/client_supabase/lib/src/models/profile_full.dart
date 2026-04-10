import 'profile_extension_row.dart';
import 'profile_row.dart';

/// Aggregated "full profile" record: a profile plus its extension.
///
/// This matches the shape we request from PostgREST:
/// `select=*,profile_extensions(*)`
class ProfileFull {
  const ProfileFull({
    required this.profile,
    required this.extension,
  });

  final ProfileRow profile;
  final ProfileExtensionRow? extension;

  /// Parses a PostgREST embedded relationship payload.
  ///
  /// PostgREST will typically return `profile_extensions` as:
  /// - a JSON object for 1:1 relationships, OR
  /// - a JSON array for 1:n relationships (even if only 1 row exists).
  factory ProfileFull.fromPostgrestJson(Map<String, dynamic> json) {
    final extensionJson = json['profile_extensions'];

    Map<String, dynamic>? extensionMap;
    if (extensionJson is Map<String, dynamic>) {
      extensionMap = extensionJson;
    } else if (extensionJson is List && extensionJson.isNotEmpty) {
      final first = extensionJson.first;
      if (first is Map<String, dynamic>) {
        extensionMap = first;
      }
    }

    final profile = ProfileRow.fromJson(json);
    final extension =
        extensionMap != null ? ProfileExtensionRow.fromJson(extensionMap) : null;

    return ProfileFull(profile: profile, extension: extension);
  }
}

