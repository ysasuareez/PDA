import 'item.dart';

/// Represents a subcategory model.
/// Categories store subcategories, which in turn store items.
class Subcategory {
  final String id;
  final String name;
  final List<Item> items;

  Subcategory({required this.id, required this.name, required this.items});
}
