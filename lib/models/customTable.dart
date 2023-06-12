import 'item.dart';

/// Represents a table model.
class CustomTable {
  String firebaseId;
  int id;
  List<Item> orders;
  String isBilledOut;
  String date;
  String state;
  String openingTime;
  String closingTime;

  CustomTable({
    required this.firebaseId,
    required this.id,
    required this.orders,
    required this.isBilledOut,
    required this.date,
    required this.state,
    required this.openingTime,
    required this.closingTime,
  });

  /// Returns true if the table is currently occupied/busy.
  bool get isBusy => orders.isNotEmpty;

  /// Returns the number of units (items) in the table.
  int getUnits() {
    return orders.length;
  }

  /// Calculates and returns the total amount for the table's orders.
  double getTotalAmount() {
    double total = 0.0;
    for (var item in orders) {
      total += item.price;
    }
    return total;
  }
}
