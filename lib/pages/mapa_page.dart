import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restaurante/models/customTable.dart';
import 'package:restaurante/services/firebase_service.dart';

/// Represents a Flutter page called "MapaPage", which displays a map of tables
/// in a restaurant.
class MapaPage extends StatefulWidget {
  /// It contains the following properties:
  /// A function that navigates to the order page.
  final void Function(CustomTable) goToOrderPage;

  const MapaPage({super.key, required this.goToOrderPage});

  @override
  MapaPageState createState() => MapaPageState();
}

class MapaPageState extends State<MapaPage> {
  /// A list of CustomTable objects representing the tables.
  late List<CustomTable> tableList;

  /// A Timer object used for scheduling a periodic callback
  Timer? timer;

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPositionTables(),
    );
  }

  /// A method that builds the table map UI.
  Widget buildPositionTables() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 900,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 1,
                child: Image.asset(
                  'lib/assets/images/mapa_mesas_sin2.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // PRIMERA FILA
            Positioned(
              top: 60,
              left: 25,
              child: buildSingleTable(5),
            ),
            Positioned(
              top: 60,
              left: 150,
              child: buildSingleTable(6),
            ),
            Positioned(
              top: 60,
              left: 275,
              child: buildSingleTable(7),
            ),

            // SEGUNDA FILA
            Positioned(
              top: 190,
              left: 25,
              child: buildSingleTable(8),
            ),
            Positioned(
              top: 190,
              left: 150,
              child: buildSingleTable(9),
            ),
            Positioned(
              top: 190,
              left: 275,
              child: buildSingleTable(10),
            ),

            // TERCERA FILA
            Positioned(
              top: 320,
              left: 25,
              child: buildMesaDoble(11),
            ),
            Positioned(
              top: 320,
              left: 220,
              child: buildSingleTable(12),
            ),

            // CUARTA FILA
            Positioned(
              top: 450,
              left: 25,
              child: buildMesaDoble(13),
            ),
            Positioned(
              top: 450,
              left: 220,
              child: buildSingleTable(14),
            ),

            // QUINTA FILA
            Positioned(
              top: 580,
              left: 25,
              child: buildMesaDoble(15),
            ),
            Positioned(
              top: 580,
              left: 220,
              child: buildSingleTable(16),
            ),

            // BANQUETAS
            Positioned(
              top: 360,
              left: 440,
              child: buildMesaBanqueta(1),
            ),
            Positioned(
              top: 440,
              left: 440,
              child: buildMesaBanqueta(2),
            ),
            Positioned(
              top: 520,
              left: 440,
              child: buildMesaBanqueta(3),
            ),
            Positioned(
              top: 600,
              left: 440,
              child: buildMesaBanqueta(4),
            ),

            // ----------- TERRAZA --------------
            // PRIMERA FILA
            Positioned(
              top: 60,
              left: 650,
              child: buildSingleTable(17),
            ),
            Positioned(
              top: 60,
              left: 775,
              child: buildSingleTable(22),
            ),

            // SEGUNDA FILA
            Positioned(
              top: 190,
              left: 650,
              child: buildSingleTable(18),
            ),
            Positioned(
              top: 190,
              left: 775,
              child: buildSingleTable(23),
            ),

            // TERCERA FILA
            Positioned(
              top: 320,
              left: 650,
              child: buildSingleTable(19),
            ),
            Positioned(
              top: 320,
              left: 775,
              child: buildSingleTable(24),
            ),

            // CUARTA FILA
            Positioned(
              top: 450,
              left: 650,
              child: buildSingleTable(20),
            ),
            Positioned(
              top: 450,
              left: 775,
              child: buildSingleTable(25),
            ),

            // QUINTA FILA
            Positioned(
              top: 580,
              left: 650,
              child: buildSingleTable(21),
            ),
            Positioned(
              top: 580,
              left: 775,
              child: buildSingleTable(26),
            ),
          ],
        ),
      ),
    );
  }

  /// A method that builds a single table widget.
  Widget buildSingleTable(int number) {
    Color colorMesa = const Color(0xFF5DDAAD);
    CustomTable? table;

    return FutureBuilder<CustomTable?>(
      future: getTableById(number),
      builder: (context, snapshot) {
        double topPosition = 16;
        double leftPosition = 22;

        if (snapshot.hasData && snapshot.data != null) {
          table = snapshot.data;

          if (isBilledOut(table!)) {
            colorMesa = const Color(0xFFFFD056);
          } else if (isBusy(table!)) {
            colorMesa = const Color(0xFFEC5D5D);
          } else if (isFree(table!)) {
            colorMesa = const Color(0xFF5DDAAD);
          }
        } else {
          table = null;
        }

        if (number > 9) {
          leftPosition = 15.0;
        }

        return GestureDetector(
          onTap: () {
            timer!.cancel();
            widget.goToOrderPage(table!);
          },
          child: SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              children: [
                Container(
                  color: colorMesa,
                ),
                Positioned(
                  top: topPosition,
                  left: leftPosition,
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// A method that builds a double table widget.
  Widget buildMesaDoble(int number) {
    Color colorMesa = const Color(0xFF5DDAAD);
    CustomTable? table;
    return FutureBuilder<CustomTable?>(
      future: getTableById(number),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          table = snapshot.data;

          if (isBilledOut(table!)) {
            colorMesa = const Color(0xFFFFD056);
          } else if (isBusy(table!)) {
            colorMesa = const Color(0xFFEC5D5D);
          } else if (isFree(table!)) {
            colorMesa = const Color(0xFF5DDAAD);
          }
        } else {
          table = null;
        }

        return InkWell(
          onTap: () {
            timer!.cancel();
            widget.goToOrderPage(table!);
          },
          child: Container(
            width: 130,
            height: 60,
            color: colorMesa,
            child: Stack(
              children: [
                Positioned(
                  top: 16.0,
                  left: 50.0,
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// A method that builds a double table widget.
  Widget buildMesaBanqueta(int number) {
    Color colorMesa = const Color(0xFF5DDAAD);
    CustomTable? table;
    return FutureBuilder<CustomTable?>(
      future: getTableById(number),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          table = snapshot.data;

          if (isBilledOut(table!)) {
            colorMesa = const Color(0xFFFFD056);
          } else if (isBusy(table!)) {
            colorMesa = const Color(0xFFEC5D5D);
          } else if (isFree(table!)) {
            colorMesa = const Color(0xFF5DDAAD);
          }
        } else {
          table = null;
        }
        return GestureDetector(
          onTap: () {
            timer!.cancel();
            widget.goToOrderPage(table!);
          },
          onLongPress: () {
            setState(() {});
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: colorMesa,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// This method checks if the specified table is currently busy.
  /// It examines the status field of the table object and returns true if the
  /// status is set to busy.
  bool isBusy(CustomTable t) {
    if (t.orders.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  /// This method checks if a specific CustomTable is selected. It iterates over
  /// the selectedTablesList and compares the IDs of the tables to determine if
  ///  the given table is selected.
  bool isFree(CustomTable t) {
    if (!t.orders.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  /// This method checks if a specific CustomTable is billed out. It checks if
  /// the given table is present in the billedOutTableList, which contains
  /// tables that have been billed out.
  bool isBilledOut(CustomTable t) {
    if (t.orders.isNotEmpty && t.isBilledOut == 'true') {
      return true;
    } else {
      return false;
    }
  }

  /// This method reloads the state of the widget. It fetches the latest table
  /// data from the database and updates the UI accordingly.
  void reload() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        buildPositionTables();
      });
    });
  }
}
