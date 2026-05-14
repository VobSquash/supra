import 'package:dupra/engine/local_storage_service.dart';

/// Member bookings slot list layout (persisted).
enum DupraBookingsSlotLayout {
  /// Three-column courts grid.
  grid,

  /// One row per court (accessibility-style).
  accessible;

  bool get usesCompactGrid => this == DupraBookingsSlotLayout.grid;

  static DupraBookingsSlotLayout decode(String? raw) {
    if (raw == _prefsValueGrid) return DupraBookingsSlotLayout.grid;
    return DupraBookingsSlotLayout.accessible;
  }

  String get encode => switch (this) {
        DupraBookingsSlotLayout.grid => _prefsValueGrid,
        DupraBookingsSlotLayout.accessible => _prefsValueAccessible,
      };

  static const _prefsValueGrid = 'grid';
  static const _prefsValueAccessible = 'accessible';
}

/// Persists [DupraBookingsSlotLayout] for the Dupra bookings tab.
abstract final class DupraBookingsLayoutPreferenceStore {
  static const _key = 'dupra.bookings.slot_layout';

  static Future<DupraBookingsSlotLayout> load() async {
    final raw = await LocalStorageService.instance.readString(_key);
    return DupraBookingsSlotLayout.decode(raw);
  }

  static Future<void> save(DupraBookingsSlotLayout layout) async {
    await LocalStorageService.instance.writeString(_key, layout.encode);
  }
}
