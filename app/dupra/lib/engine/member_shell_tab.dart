/// Tabs in the member shell (`/:suite/:tab` where suite is `m`).
/// Ordering matches the member slug list in `shell_locations.dart` — keep in sync manually.
enum MemberShellTab {
  home,
  bookings,
  fixtures,
  ladders,
  profile;

  /// Route slug for `/m/<slug>` (member suite).
  String get slug => switch (this) {
        MemberShellTab.home => 'home',
        MemberShellTab.bookings => 'bookings',
        MemberShellTab.fixtures => 'fixtures',
        MemberShellTab.ladders => 'ladders',
        MemberShellTab.profile => 'profile',
      };
}
