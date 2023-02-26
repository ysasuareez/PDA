import 'order.dart';

class CustomTable {
  final int id;
  List<Order>? orders;

  CustomTable({required this.id, this.orders});

  bool get isOccupied => orders != null && orders!.isNotEmpty;
}
