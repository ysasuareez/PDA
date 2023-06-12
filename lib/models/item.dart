/// Represents an item model.
class Item {
  final String id;
  String name;
  final double price;

  Item({required this.id, required this.name, required this.price});

  @override
  String toString() {
    return id + name;
  }

  /// Converts the item object to a map.
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "price": price,
    };
  }
}
