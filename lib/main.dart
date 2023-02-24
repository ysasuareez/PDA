import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurante/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:restaurante/pages/tables_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurante PDA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }

  Future<List> getMesas() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    List tables = [];

    CollectionReference collectionReferenceTables =
        db.collection('customTable');
    QuerySnapshot queryTables = await collectionReferenceTables.get();

    queryTables.docs.forEach((documento) {
      tables.add(documento.data());
    });
    print(tables);
    return tables;
  }
}
