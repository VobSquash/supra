import 'package:client_models/client_models.dart';

/// Facade for location read operations exposed by [middlewareSl].
abstract class ILocationsFacade {
  Future<List<LocationsItemDTO>> loadLocations();
}
