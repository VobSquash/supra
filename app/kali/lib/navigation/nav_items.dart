/// Primary desktop navigation destinations (SPA paths).
library;

import 'package:app_bloc/app_bloc.dart';

import 'kali_admin_eligibility.dart';

typedef NavDefinition = ({String path, String label});

const List<NavDefinition> navItems = [
  (path: '/', label: 'Home'),
  (path: '/bookings', label: 'Bookings'),
  (path: '/admin-bookings', label: 'Admin bookings'),
  (path: '/users', label: 'Users'),
  (path: '/fixtures', label: 'Fixtures'),
  (path: '/ladder', label: 'Ladder'),
];

/// Sidebar entries for [auth]; **Admin bookings** omitted unless [**kaliAuthIsAdminOrElevated**].
List<NavDefinition> kaliNavItemsVisibleFor(AuthState auth) {
  if (kaliAuthIsAdminOrElevated(auth)) {
    return navItems;
  }
  return navItems.where((e) => e.path != kaliAdminBookingsPath).toList(growable: false);
}

/// Normalizes [RouteState.location] (absolute URL or `/path`) to a leading-slash path key.
String normalizedRoutePath(String location) => _normalize(location);

String labelForRoutePath(String locationOrPath) {
  final normalized = _normalize(locationOrPath);
  for (final item in navItems) {
    if (item.path == normalized) return item.label;
  }
  return 'Admin';
}

String _normalize(String pathOrLocation) {
  final raw = pathOrLocation.trim();
  late final Uri u;
  if (raw.startsWith('/') && !raw.contains('://')) {
    u = Uri.parse('http://local$raw');
  } else {
    u = Uri.parse(raw);
  }
  final path = u.path.isEmpty ? '/' : u.path;
  if (path.endsWith('/') && path != '/') return path.substring(0, path.length - 1);
  return path;
}

bool routePathIsActive({required String location, required String navPath}) {
  final current = _normalize(location);
  final cmp = navPath == '/'
      ? current
      : navPath.endsWith('/')
      ? navPath.substring(0, navPath.length - 1)
      : navPath;
  if (cmp == '/') {
    return current == '/' || current.isEmpty;
  }
  return current == cmp || current.startsWith('$cmp/');
}
