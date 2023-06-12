import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restaurante/firebase_options.dart';
import 'package:restaurante/pages/login_page.dart';
import 'package:restaurante/pages/mapa_page.dart';
import 'package:restaurante/pages/order_page.dart';

import 'models/employe.dart';
import 'models/customTable.dart';

void main() async {
  // Inicia Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  String _currentPage = 'login';
  Employee? _selectedEmployee;
  CustomTable? _table;

  void _goToLoginPage() {
    setState(() {
      _currentPage = 'login';
      _isLoggedIn = false;
    });
  }

  void _goToMapaPage() {
    setState(() {
      _currentPage = 'mapa';
      _isLoggedIn = true;
    });
  }

  void _goToOrderPage(CustomTable table) {
    setState(() {
      _currentPage = 'orders';
      _isLoggedIn = true;
      _table = table;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_currentPage) {
      case 'login':
        body = LoginPage(goToMapaPage: _goToMapaPage);
        break;
      case 'mapa':
        body = MapaPage(
          goToOrderPage: _goToOrderPage,
        );
        break;
      case 'orders':
        body = OrdersPage(
          table: _table!,
          goToMapaPage: _goToMapaPage,
          goToOrderPage: _goToOrderPage,
        );
        break;

      default:
        body = Container();
    }

    return MaterialApp(
      title: 'TPV',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          automaticallyImplyLeading: false,
          title: Text(
            name(),
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0), // Color del container
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        body: body,
        endDrawer: _currentPage != 'login'
            ? Drawer(
                child: ListView(
                  children: [
                    ListTile(
                      title: Text('Cerrar Sesión'),
                      leading: Icon(Icons.exit_to_app),
                      onTap: _goToLoginPage,
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }

  String name() {
    if (_isLoggedIn == true && _selectedEmployee != null) {
      return _selectedEmployee!.name;
    } else {
      return '';
    }
  }
}
