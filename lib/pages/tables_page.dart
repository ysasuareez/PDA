// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:restaurante/models/employe.dart';
import 'package:restaurante/models/table.dart';
import 'package:restaurante/pages/login_page.dart';
import 'package:restaurante/pages/order_page.dart';
import 'package:restaurante/services/firebase_service.dart';

class TablesPage extends StatefulWidget {
  final Employe employee;
  const TablesPage({super.key, required this.employee});

  @override
  TablesPageState createState() => TablesPageState();
}

class TablesPageState extends State<TablesPage> {
  late List<CustomTable> tableList;
  late CustomTable selectedTable;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MESAS',
          style: TextStyle(
            color: Color.fromARGB(255, 249, 240, 227),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 70, 50, 43),
      ),
      backgroundColor: const Color.fromARGB(255, 249, 240, 227),
      body: FutureBuilder(
        future: getTables(),
        builder:
            (BuildContext context, AsyncSnapshot<List<CustomTable>> snapshot) {
          if (snapshot.hasData) {
            var tables = snapshot.data as List<CustomTable>;

            return GridView.count(
              crossAxisCount: 3,
              children: tables
                  .map((table) => Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: ElevatedButton(
                          onPressed: () {
                            selectedTable = table;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrdersPage(
                                  employee: widget.employee,
                                  table: selectedTable,
                                ),
                              ),
                            );

                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: table.isOccupied
                                ? const Color.fromARGB(255, 243, 100, 89)
                                : const Color.fromARGB(255, 106, 215, 110),
                          ),
                          child: Text('${table.id}'),
                        ),
                      ))
                  .toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      endDrawer: Drawer(
        child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 249, 240, 227),
            ),
            child: ListView(children: [
              DrawerHeader(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 300.0,
                    maxHeight: 300.0,
                  ),
                  child: Image.asset(
                    'lib/assets/images/logoSolo.png', // Ruta de la imagen
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              ListTile(
                  leading: const Icon(Icons.close),
                  title: const Text('SING UP',
                      style: TextStyle(fontSize: 20, fontFamily: 'Nunito')),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginPage()));
                  }),
            ])),
      ),
    );
  }
}
