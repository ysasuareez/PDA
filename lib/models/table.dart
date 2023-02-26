import 'item.dart';

/// Modelo de una tabla
class CustomTable {
  String firebaseId;
  String id;
  List<Item> orders;

  CustomTable({required this.firebaseId, required this.id, required this.orders});

  bool get isOccupied => orders.isNotEmpty;
}
