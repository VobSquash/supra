class FridgeItem {
  const FridgeItem({
    required this.id,
    required this.name,
    required this.price,
    this.count = 0,
  });

  final String id;
  final String name;
  final int price;
  final int count;

  FridgeItem copyWith({String? id, String? name, int? price, int? count}) {
    return FridgeItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'price': price,
        'count': count,
      };

  factory FridgeItem.fromJson(Map<String, dynamic> json) {
    return FridgeItem(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}
