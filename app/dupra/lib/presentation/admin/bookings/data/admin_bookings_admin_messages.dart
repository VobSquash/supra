import 'package:dio/dio.dart';

/// Best-effort message from bloc/facade errors (matches Supra admin bookings UX).
String adminBookingsAdminErrorMessage(Object error) {
  if (error is DioException) {
    final t = error.error?.toString().trim();
    if (t != null && t.isNotEmpty) return t;
    final m = error.message?.trim();
    if (m != null && m.isNotEmpty) return m;
  }
  final s = error.toString().trim();
  if (s.isNotEmpty && s != 'Exception') return s;
  return 'Request failed.';
}
