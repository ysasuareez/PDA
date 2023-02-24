class Item {
  final int id;
  final String item;
  late String note;
  final double price;

  Item(
    this.id,
    this.item,
    this.note,
    this.price,
  );

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      json['id'].toInt(),
      json['item'],
      json['note'] ?? '',
      json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item': item,
      'note': note,
      'price': price,
    };
  }
}
