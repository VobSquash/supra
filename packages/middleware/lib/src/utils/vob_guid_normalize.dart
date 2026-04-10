/// Normalizes legacy 32-char hex GUID to hyphenated lowercase UUID when possible.
/// Same rules as migration `normalizeVobGuid`.
String? normalizeVobGuid(String? raw) {
  if (raw == null) return null;
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;

  final lower = trimmed.toLowerCase();
  final uuidRegex = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
  );
  if (uuidRegex.hasMatch(lower)) return lower;

  final hex32 = RegExp(r'^[0-9a-f]{32}$');
  if (!hex32.hasMatch(lower)) return lower;

  return '${lower.substring(0, 8)}-'
      '${lower.substring(8, 12)}-'
      '${lower.substring(12, 16)}-'
      '${lower.substring(16, 20)}-'
      '${lower.substring(20)}';
}
