import '../models/location_row.dart';

/// Locations endpoints (`locations` table).
abstract class IClientSupabaseLocations {
  /// Loads all location rows ordered by name.
  Future<List<LocationRow>> getLocations();
}
