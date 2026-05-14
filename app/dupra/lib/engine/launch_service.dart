import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Central place for `mailto:`, `tel:`, https links, and map fallbacks.
class LaunchService {
  const LaunchService();

  Future<bool> launchUrlString(
    String url, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: mode);
        return true;
      }
    } on PlatformException {
      return false;
    } catch (_) {
      return false;
    }
    return false;
  }

  Future<bool> launchDialer(String number) {
    final formatted = number
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('-', '')
        .replaceAll(' ', '')
        .trim();
    return launchUrlString('tel:$formatted');
  }

  Future<bool> launchEmail(String email) => launchUrlString('mailto:$email');

  Future<bool> launchWebUrl(String url) => launchUrlString(url);

  /// Opens Google Maps in the browser when no native map app is available.
  Future<bool> launchGoogleMapsSearch(double latitude, double longitude, {String? placeLabel}) {
    final query = placeLabel != null && placeLabel.trim().isNotEmpty
        ? Uri.encodeComponent('$latitude,$longitude (${placeLabel.trim()})')
        : Uri.encodeComponent('$latitude,$longitude');
    return launchWebUrl('https://www.google.com/maps/search/?api=1&query=$query');
  }
}
