import 'package:restaurante/utils/table.dart';

class Employe {
  final int id;
  final String name;
  final int pin;

  List<CustomTable>? tables;

  Employe({required this.id, required this.name, required this.pin});
}
