import 'subcategory.dart';

class Category {
  final String name;
  final List<Subcategory> subcategories;

  Category(this.name, this.subcategories);

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      json['name'],
      List<Subcategory>.from(
          json['subcategories'].map((x) => Subcategory.fromJson(x))),
    );
  }
}
