// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restaurante/pages/order_page.dart';
import 'package:restaurante/utils/table.dart';
import 'package:flutter/services.dart' as rootBundle;
import '../utils/employe.dart';

class TablesPage extends StatefulWidget {
  final Employe employee;
  TablesPage({super.key, required this.employee});

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

  /*

  Launch.fromJson(Map<String, dynamic> json){

    CustomTable customTable = new CustomTable(id: json['id'], orders: json);
    
  }
  */

  Future<List<CustomTable>> readJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('lib/json/tables.json');
    final list = json.decode(jsondata);

    return list.map((e) => CustomTable.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mesas'),
        ),
        body: FutureBuilder(
          future: readJsonData(),
          builder: ((context, data) {
            if (data.hasData) {
              var tables = data.data as List<CustomTable>;
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(tables[index].id.toString()),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        )

        /*GridView.count(
        crossAxisCount: 3,
        children: tableList
            .map((table) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedTable = table;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrdersPage(
                            employee: widget.employee,
                            table: selectedTable,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          table.isOccupied ? Colors.red : Colors.green,
                    ),
                    child: Text('Mesa ${table.id}'),
                  ),
                ))
            .toList(),
      ),*/
        );
  }
}
