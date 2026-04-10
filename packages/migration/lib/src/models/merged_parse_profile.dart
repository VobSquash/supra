/// One Parse [Profile] row plus its matching [ProfileExtensions] row.
class MergedParseProfile {
  const MergedParseProfile({
    required this.profile,
    required this.extension,
  });

  final Map<String, dynamic> profile;
  final Map<String, dynamic> extension;
}
