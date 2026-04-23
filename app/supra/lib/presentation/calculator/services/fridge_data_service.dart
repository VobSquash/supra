import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/fridge_item.dart';
import '../models/item_category.dart';

/// Persists fridge calculator selections per user key (no network).
class FridgeDataService {
  FridgeDataService({required String storageKeySuffix}) : _suffix = storageKeySuffix.trim();

  final String _suffix;
  SharedPreferences? _prefs;

  static const _keyPrefix = 'supra.fridge_calculator.saved.';

  static String sanitizeStorageSuffix(String raw) {
    final s = raw.trim().toLowerCase();
    if (s.isEmpty) return 'guest';
    return s.replaceAll(RegExp(r'[^a-z0-9_.@-]'), '_');
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get _storageKey => '$_keyPrefix${sanitizeStorageSuffix(_suffix)}';

  Map<String, dynamic>? loadSavedItems() {
    try {
      final prefs = _prefs;
      if (prefs == null) return null;
      final raw = prefs.getString(_storageKey);
      if (raw == null || raw.isEmpty) return null;
      final decoded = json.decode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return decoded;
    } catch (e, st) {
      debugPrint('FridgeDataService.loadSavedItems: $e\n$st');
      return null;
    }
  }

  Future<bool> saveItems(Map<ItemCategory, List<FridgeItem>> itemsByCategory) async {
    try {
      final prefs = _prefs;
      if (prefs == null) return false;
      final dataToSave = <String, dynamic>{
        'timestamp': DateTime.now().toIso8601String(),
        'username': _suffix,
        'categories': <String, dynamic>{},
      };
      final categories = dataToSave['categories']! as Map<String, dynamic>;
      for (final entry in itemsByCategory.entries) {
        final categoryName = entry.key.name;
        categories[categoryName] = entry.value.map((e) => e.toJson()).toList();
      }
      await prefs.setString(_storageKey, json.encode(dataToSave));
      return true;
    } catch (e, st) {
      debugPrint('FridgeDataService.saveItems: $e\n$st');
      return false;
    }
  }

  Future<void> clearItems() async {
    final prefs = _prefs;
    if (prefs == null) return;
    await prefs.remove(_storageKey);
  }

  static int calculateTotal(Map<ItemCategory, List<FridgeItem>> itemsByCategory) {
    return itemsByCategory.values
        .expand((items) => items)
        .fold<int>(0, (sum, item) => sum + item.count * item.price);
  }
}
