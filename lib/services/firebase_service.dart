import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/table.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

/*
List<CustomTable> fromJson() {
  Map<String, dynamic> json = getJson();
  List<CustomTable> customTable;
  return customTable = List<CustomTable>.from(
      json["customTable"].map((x) => CustomTable.fromJson(x)));
}

Map<String, dynamic> toJson(List<CustomTable> customTable) => {
      "customTable": List<dynamic>.from(customTable.map((x) => x.toJson())),
    };
*/

Future<List> getTables() async {
  List tables = [];
  CollectionReference collectionReference = db.collection('customeTable');
  QuerySnapshot querySnapshot = await collectionReference.get();
  querySnapshot.docs.forEach((element) {
    tables.add(element.data());
  });

  await Future.delayed(const Duration(seconds: 15));

  return tables;
}
