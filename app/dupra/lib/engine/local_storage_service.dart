import 'package:shared_preferences/shared_preferences.dart';

/// App-wide persisted key–value storage (backed by [SharedPreferences]).
///
/// Prefer this over calling [SharedPreferences] directly so Dupra-local prefs stay
/// in one place and we can migrate or augment storage later (e.g. encrypt,
/// namespaces, alternate backends).
///
/// Uses a single lazily-loaded [SharedPreferences] instance for the process.
final class LocalStorageService {
  LocalStorageService._();
  static final LocalStorageService instance = LocalStorageService._();

  SharedPreferences? _prefs;

  Future<SharedPreferences> _ensurePrefs() async => _prefs ??= await SharedPreferences.getInstance();

  Future<bool> containsKey(String key) async => (await _ensurePrefs()).containsKey(key);

  Future<String?> readString(String key) async => (await _ensurePrefs()).getString(key);

  Future<bool> writeString(String key, String value) async => (await _ensurePrefs()).setString(key, value);

  Future<bool?> readBool(String key) async => (await _ensurePrefs()).getBool(key);

  Future<bool> writeBool(String key, bool value) async => (await _ensurePrefs()).setBool(key, value);

  Future<int?> readInt(String key) async => (await _ensurePrefs()).getInt(key);

  Future<bool> writeInt(String key, int value) async => (await _ensurePrefs()).setInt(key, value);

  Future<double?> readDouble(String key) async => (await _ensurePrefs()).getDouble(key);

  Future<bool> writeDouble(String key, double value) async => (await _ensurePrefs()).setDouble(key, value);

  Future<List<String>?> readStringList(String key) async => (await _ensurePrefs()).getStringList(key);

  Future<bool> writeStringList(String key, List<String> value) async =>
      (await _ensurePrefs()).setStringList(key, value);

  Future<bool> remove(String key) async => (await _ensurePrefs()).remove(key);
}
