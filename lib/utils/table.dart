import 'item.dart';
import 'dart:convert';

class CustomTable {
  String? id;
  List<Item>? orders;

  CustomTable({required this.id, this.orders});

  bool get isOccupied => orders != null && orders!.isNotEmpty;

/*
  factory CustomTable.fromJson(Map<String, dynamic> json) => CustomTable(
        id: json["id"],
        orders: List<Item>.from(json["orders"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orders": List<dynamic>.from(orders!.map((x) => x.toJson())),
      };

*/

  CustomTable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    //   orders = List<Item>.from(json["orders"].map((x) => Item.fromJson(x)));
  }
}
