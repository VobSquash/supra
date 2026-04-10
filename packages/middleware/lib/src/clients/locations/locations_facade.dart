import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/src/injection.dart';
import 'package:middleware/src/mappers/locations/supabase_location_mapper.dart';

import 'i_locations_facade.dart';

@LazySingleton(as: ILocationsFacade)
class LocationsFacade implements ILocationsFacade {
  LocationsFacade();

  IClientSupabase get _client => middlewareSl<IClientSupabase>();

  LocationsItemDTO _toDto(LocationRow row) {
    return const SupabaseLocationMapper().convert<LocationRow, LocationsItemDTO>(row);
  }

  @override
  Future<List<LocationsItemDTO>> loadLocations() async {
    final rows = await _client.locations.getLocations();
    final list = rows.map(_toDto).toList(growable: false);
    list.sort((a, b) => _sortKey(a.name).compareTo(_sortKey(b.name)));
    return list;
  }

  String _sortKey(String? name) => (name ?? '').toLowerCase();
}
