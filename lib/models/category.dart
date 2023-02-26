import 'subcategory.dart';

/// Modelo de una categoría
class Category {
  final String id;
  final String name;
  final List<Subcategory> subcategories;

  Category({required this.id, required this.name, required this.subcategories});
}
