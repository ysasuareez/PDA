import 'subcategory.dart';

/// Represents a category.
/// Categories contain subcategories, which in turn contain items.
class Category {
  final String id;
  final String name;
  final List<Subcategory> subcategories;

  Category({required this.id, required this.name, required this.subcategories});
}
