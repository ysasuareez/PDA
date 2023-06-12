import 'package:flutter/material.dart';

import '../utils/botonera.dart';

/// Represents the login screen of the TPV.
class LoginPage extends StatefulWidget {
  /// It contains the following properties:
  /// goToMapaPage: A callback function that will be invoked when the
  /// validate button on the Numeric keypad is pressed.
  final void Function() goToMapaPage;

  const LoginPage({super.key, required this.goToMapaPage});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  /// _pinController: It is a text controller for the PIN input field.
  final TextEditingController _pinController = TextEditingController();

  /// _obscureText: It is a boolean indicating whether the text in the input
  /// field should be obscured or shown.
  bool _obscureText = true;

  /// This method is called when the widget is being removed and is
  /// responsible for releasing resources. In this case, it ensures that the
  /// _pinController controller is properly disposed.
  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'lib/assets/images/fondo_torcido.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 350,
              height: 520,
              decoration: BoxDecoration(
                color: Colors.white, // Color del container
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'lib/assets/images/logo_nombre.jpg',
                      width: 230,
                    ),
                    const SizedBox(height: 30.0),
                    Container(
                      width: 220,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(47.12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _pinController,
                              readOnly: true,
                              obscureText: _obscureText,
                              decoration: const InputDecoration(
                                hintText: 'PIN',
                                hintStyle: TextStyle(fontSize: 15),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 100),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: _obscureText
                                  ? const Icon(Icons.visibility_off, size: 20)
                                  : const Icon(Icons.visibility, size: 20),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child: Botonera(
                        pinController: _pinController,
                        goToMapaPage: widget.goToMapaPage,
                        text: 'S',
                        w: 90,
                        h: 65,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
