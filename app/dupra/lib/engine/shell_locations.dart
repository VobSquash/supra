/// Canonical paths for the main shell tabs. Used with GoRouter `/:suite/:tab`.
/// Suite `m` = member, `a` = admin. Slugs match dock order in `MainShellPage`.
abstract final class ShellLocations {
  ShellLocations._();

  static const String defaultMember = '/m/home';

  static const _memberTabs = ['home', 'bookings', 'fixtures', 'ladders', 'profile'];
  static const _adminTabs = ['home', 'bookings', 'users', 'ladder', 'profile'];

  static bool isValidSuite(String suite) => suite == 'm' || suite == 'a';

  static bool isValidTab(String suite, String tab) {
    if (suite == 'm') {
      return _memberTabs.contains(tab);
    }
    if (suite == 'a') {
      return _adminTabs.contains(tab);
    }
    return false;
  }

  static String path(String suite, String tab) => '/$suite/$tab';

  /// Returns `null` if [suite] / [tab] is not a known shell location.
  static int? tabIndexFor({required String suite, required String tab}) {
    if (suite == 'm') {
      final i = _memberTabs.indexOf(tab);
      return i < 0 ? null : i;
    }
    if (suite == 'a') {
      final i = _adminTabs.indexOf(tab);
      return i < 0 ? null : i;
    }
    return null;
  }

  static String tabSlugForIndex({required bool admin, required int index}) {
    final list = admin ? _adminTabs : _memberTabs;
    return list[index.clamp(0, list.length - 1)];
  }
}
