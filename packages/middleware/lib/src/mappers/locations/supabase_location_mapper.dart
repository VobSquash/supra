import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';

import 'supabase_location_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<LocationRow, LocationsItemDTO>(
    fields: [
      Field('prefix', custom: SupabaseLocationMapper.mapNullPrefix),
      Field('imageUrl', custom: SupabaseLocationMapper.mapNullImageUrl),
    ],
  ),
])
class SupabaseLocationMapper extends $SupabaseLocationMapper {
  const SupabaseLocationMapper() : super();

  static String? mapNullPrefix(LocationRow _) => null;

  static String? mapNullImageUrl(LocationRow _) => null;
}
