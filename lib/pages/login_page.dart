import 'package:flutter/material.dart';
import 'package:restaurante/pages/tables_page.dart';

import '../models/employe.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();

  // Empleados predefinidos
  final _employees = [
    Employe(id: "1", name: 'Ysabel Suárez', pin: 1234),
    Employe(id: "2", name: 'Álvaro Gonzalez', pin: 1111),
    Employe(id: "3", name: 'Miguel Suárez', pin: 2222),
  ];

  // Empleado seleccionado
  late Employe _selectedEmployee = _employees[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LOGIN',
          style: TextStyle(
            color: Color.fromARGB(255, 249, 240, 227),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 70, 50, 43),
      ),
      backgroundColor: const Color.fromARGB(255, 249, 240, 227),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              constraints: const BoxConstraints(
                maxWidth: 300.0,
                maxHeight: 300.0,
              ),
              child: Image.asset(
                'lib/assets/images/logo.png', // Ruta de la imagen
                fit: BoxFit.contain,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                        ),
                        items: _employees
                            .map((Employe employee) => DropdownMenuItem(
                                  value: employee,
                                  child: Text(employee.name),
                                ))
                            .toList(),
                        value: _selectedEmployee,
                        onChanged: (employee) {
                          setState(() {
                            _selectedEmployee = employee!;
                          });
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _pinController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'PIN',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Introduce tu PIN';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 70, 50, 43)),
                            minimumSize:
                                MaterialStateProperty.all(const Size(100, 50))),
                        onPressed: () {
                          comprobarPIN();
                        },
                        child: const Text('ENTRAR'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void comprobarPIN() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedEmployee.pin == int.parse(_pinController.text)) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TablesPage(
              employee: _selectedEmployee,
            ),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color.fromARGB(255, 253, 233, 204),
            title: const Text('ERROR'),
            content: const Text('PIN incorrecto'),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 70, 50, 43)),
                    minimumSize: MaterialStateProperty.all(const Size(80, 40))),
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }
}
