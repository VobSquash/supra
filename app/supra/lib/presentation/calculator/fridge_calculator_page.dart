import 'package:app_bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/fridge_item.dart';
import 'models/item_category.dart';
import 'services/fridge_data_service.dart';
import 'widgets/fridge_item_tile.dart';
import 'widgets/saved_items_dialog.dart';

/// Club fridge pricing demo: tabs, local save via [FridgeDataService], optional SnapScan checkout.
class FridgeCalculatorPage extends StatefulWidget {
  const FridgeCalculatorPage({super.key});

  @override
  State<FridgeCalculatorPage> createState() => _FridgeCalculatorPageState();
}

class _FridgeCalculatorPageState extends State<FridgeCalculatorPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  FridgeDataService? _dataService;
  String _storageLabel = '';

  late Map<ItemCategory, List<FridgeItem>> _itemsByCategory;

  bool _loading = true;

  static List<FridgeItem> _defaultItemsFor(ItemCategory category) {
    switch (category) {
      case ItemCategory.drinks:
        return [
          const FridgeItem(id: 'beer-big', name: 'Beers (400-500ml)', price: 30),
          const FridgeItem(id: 'beer-small', name: 'Beers (330ml)', price: 25),
          const FridgeItem(id: 'beer-craft', name: 'Alcohol-Free / Craft Beer (330ml)', price: 25),
          const FridgeItem(id: 'cider-small', name: 'Ciders (330ml)', price: 35),
          const FridgeItem(id: 'wine', name: 'Wine Bottle', price: 120),
          const FridgeItem(id: 'energy-drink', name: 'Energy Drink', price: 20),
          const FridgeItem(id: 'coke-big', name: 'Coke (300ml)', price: 20),
          const FridgeItem(id: 'water-aquelle', name: 'Water (500ml)', price: 15),
        ];
      case ItemCategory.snacks:
        return [
          const FridgeItem(id: 'chips', name: 'Chips', price: 15),
          const FridgeItem(id: 'chocolate', name: 'Chocolate', price: 20),
        ];
      case ItemCategory.others:
        return [
          const FridgeItem(id: 'squash-ball', name: 'Squash Balls', price: 50),
        ];
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: ItemCategory.values.length, vsync: this);
    _itemsByCategory = {
      for (final c in ItemCategory.values) c: _defaultItemsFor(c).map((e) => e.copyWith()).toList(),
    };
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final auth = context.read<AuthBloc>();
    final suffix = auth.state.maybeWhen(
      authenticated: (s) {
        final g = s.vobGuid?.trim();
        if (g != null && g.isNotEmpty) return g;
        final e = s.email?.trim();
        if (e != null && e.isNotEmpty) return e;
        return 'user';
      },
      orElse: () => 'guest',
    );
    final label = auth.state.maybeWhen(
      authenticated: (s) => s.displayName?.trim().isNotEmpty == true ? s.displayName!.trim() : (s.email ?? suffix),
      orElse: () => suffix,
    );

    final service = FridgeDataService(storageKeySuffix: suffix);
    await service.init();
    if (!mounted) return;

    setState(() {
      _dataService = service;
      _storageLabel = label;
      _applySavedData(service.loadSavedItems());
      _loading = false;
    });
  }

  void _applySavedData(Map<String, dynamic>? savedData) {
    if (savedData == null) return;
    final categories = savedData['categories'];
    if (categories is! Map) return;
    for (final category in ItemCategory.values) {
      final key = category.name;
      if (!categories.containsKey(key)) continue;
      final rawList = categories[key];
      if (rawList is! List) continue;
      final list = _itemsByCategory[category]!;
      for (final itemData in rawList) {
        if (itemData is! Map<String, dynamic>) continue;
        final saved = FridgeItem.fromJson(itemData);
        final i = list.indexWhere((e) => e.id == saved.id);
        if (i >= 0) {
          list[i] = list[i].copyWith(count: saved.count);
        }
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _calculateTotal() => FridgeDataService.calculateTotal(_itemsByCategory);

  Future<void> _persistItems() async {
    final svc = _dataService;
    if (svc == null) return;
    await svc.saveItems(_itemsByCategory);
  }

  void _bumpCount(ItemCategory category, String id, int delta) {
    setState(() {
      final list = _itemsByCategory[category]!;
      final i = list.indexWhere((e) => e.id == id);
      if (i < 0) return;
      final next = (list[i].count + delta).clamp(0, 1 << 20);
      list[i] = list[i].copyWith(count: next);
    });
    Future<void>.microtask(_persistItems);
  }

  Future<void> _clearAll({bool showSnackBar = true}) async {
    setState(() {
      for (final c in ItemCategory.values) {
        final list = _itemsByCategory[c]!;
        for (var i = 0; i < list.length; i++) {
          list[i] = list[i].copyWith(count: 0);
        }
      }
    });
    await _dataService?.clearItems();
    if (!mounted || !showSnackBar) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All items cleared.')));
  }

  Future<void> _checkout() async {
    final total = _calculateTotal();
    if (total <= 0) return;
    final ref = Uri.encodeComponent(_storageLabel.isEmpty ? 'guest' : _storageLabel);
    final uri = Uri.parse('https://pos.snapscan.io/qr/qi7NvD2y?amount=${total * 100}&userReference=$ref');
    if (!await canLaunchUrl(uri)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open payment link.')));
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!mounted) return;
    await _clearAll(showSnackBar: false);
  }

  void _showSavedItemsDialog() {
    final svc = _dataService;
    if (svc == null) return;
    final savedData = svc.loadSavedItems();
    if (savedData == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No saved items found.')));
      return;
    }

    final timestamp = savedData['timestamp'] as String? ?? 'Unknown';
    final username = savedData['username'] as String? ?? _storageLabel;
    final rawCategories = savedData['categories'];
    if (rawCategories is! Map) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid saved data.')));
      return;
    }

    final categorizedItems = <String, List<FridgeItem>>{};
    for (final category in ItemCategory.values) {
      final key = category.name;
      if (!rawCategories.containsKey(key)) continue;
      final rawList = rawCategories[key];
      if (rawList is! List) continue;
      categorizedItems[key] = rawList
          .whereType<Map<String, dynamic>>()
          .map(FridgeItem.fromJson)
          .toList(growable: false);
    }

    final hasItems = categorizedItems.values.expand((e) => e).any((item) => item.count > 0);
    if (!hasItems) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No counted items in saved data.')));
      return;
    }

    showDialog<void>(
      context: context,
      builder: (ctx) => SavedItemsDialog(
        categorizedItems: categorizedItems,
        timestamp: timestamp,
        username: username,
      ),
    );
  }

  void _showCreditDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.sports_tennis),
            SizedBox(width: 8),
            Expanded(child: Text('Feature credit')),
          ],
        ),
        content: const Text('This feature was inspired by Keegan Smith.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final total = _calculateTotal();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fridge calculator'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Drinks'),
            Tab(text: 'Snacks'),
            Tab(text: 'Others'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Credit',
            onPressed: _showCreditDialog,
            icon: const Text('⭐', style: TextStyle(fontSize: 22)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        for (final category in ItemCategory.values)
                          ListView.builder(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            itemCount: _itemsByCategory[category]!.length,
                            itemBuilder: (context, index) {
                              final item = _itemsByCategory[category]![index];
                              return FridgeItemTile(
                                item: item,
                                onIncrement: () => _bumpCount(category, item.id, 1),
                                onDecrement: () => _bumpCount(category, item.id, -1),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton(
                          onPressed: total > 0 ? _checkout : null,
                          child: Text('Pay R$total'),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: _showSavedItemsDialog,
                          child: const Text('View saved'),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: _clearAll,
                          child: const Text('Clear all'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Totals update locally; pay opens SnapScan in the browser.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
