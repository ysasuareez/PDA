import 'package:flutter/material.dart';
import 'package:restaurante/pages/tables_page.dart';

import '../utils/employe.dart';

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
    Employe(id: 1, name: 'Ysabel Suárez', pin: 1234),
    Employe(id: 2, name: 'Álvaro Gonzalez', pin: 1111),
    Employe(id: 3, name: 'Miguel Suárez', pin: 2222)
  ];

  // Empleado seleccionado
  late Employe _selectedEmployee = _employees[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownButtonFormField(
                items: _employees
                    .map((Employe employee) => DropdownMenuItem(
                          value: employee,
                          child: Text(employee.name),
                        ))
                    .toList(),
                value: _selectedEmployee,
                hint: const Text('Selecciona tu nombre'),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedEmployee.pin ==
                        int.parse(_pinController.text)) {
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
                          title: const Text('Error'),
                          content: const Text('PIN incorrecto'),
                          actions: [
                            ElevatedButton(
                              child: const Text('OK'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
                child: const Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
