class Group {
  final String id;
  String name;
  int units;
  final double price;
  double get totalPirce => units * price;

  Group(
      {required this.id,
      required this.name,
      required this.price,
      required this.units});
}
