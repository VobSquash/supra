/// Abstract row shape for the `locations` table.
abstract class ILocation {
  String get id;

  String? get vobGuid;

  String? get name;

  String? get latitude;

  String? get longitude;

  String? get lookup;
}
