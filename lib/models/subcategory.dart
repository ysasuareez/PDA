import 'item.dart';

/// Modelo de una subcategoría
/// Las categorías almacenan subcategorías que a su vez almacenan los items
class Subcategory {
  final String id;
  final String name;
  final List<Item> items;

  Subcategory({required this.id, required this.name, required this.items});
}
