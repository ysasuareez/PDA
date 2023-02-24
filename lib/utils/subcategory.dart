import 'item.dart';

class Subcategory {
  final String name;
  final List<Item> items;

  Subcategory(this.name, this.items);

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      json['name'],
      List<Item>.from(json['items'].map((x) => Item.fromJson(x))),
    );
  }
}
