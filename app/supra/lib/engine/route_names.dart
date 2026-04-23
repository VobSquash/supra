/// Central route path strings for [MaterialApp.onGenerateRoute].
///
/// Mirrors the portal `RouteNames` pattern (single app surface; no web/app split).
class RouteNames {
  RouteNames._();

  static const String login = '/login';

  static const String initial = '/';

  static const String users = '/users';
  static const String locations = '/locations';
  static const String settings = '/settings';
  static const String ladders = '/ladders';
  static const String leagueFixtures = '/league-fixtures';
  static const String bookings = '/bookings';

  /// Admin / fixture block bookings (test harness).
  static const String adminBookings = '/admin-bookings';

  /// Profile placeholder (auth later).
  static const String profile = '/profile';

  /// [RouteSettings.arguments] must be a [BasicProfileDTO].
  static const String profileDetails = '/profile-details';

  /// All profiles (including inactive); admin / elevated. [BlocProvider]<[UsersBloc]>.
  static const String adminProfiles = '/admin-profiles';

  /// Admin/elevated ladder order management (quick re-order + add members).
  static const String adminLadders = '/admin-ladders';
}
