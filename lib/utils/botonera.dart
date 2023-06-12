import 'package:flutter/material.dart';

import '../services/firebase_service.dart';

class Botonera extends StatefulWidget {
  final TextEditingController pinController;
  final void Function() goToMapaPage;
  final String text;
  final double w;
  final double h;

  const Botonera({
    Key? key,
    required this.pinController,
    required this.text,
    required this.goToMapaPage,
    required this.w,
    required this.h,
  }) : super(key: key);
  @override
  BotoneraState createState() => BotoneraState();
}

class BotoneraState extends State<Botonera> {
  Color azulOscuro = const Color(0xFF3D8BE7);
  Color azulClaro = const Color(0xFFB0D5FF);
  String noUser = '';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          noUser,
          style: TextStyle(
            fontSize: 16,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 17),
        Row(
          children: [
            buildNumericButton('1', azulClaro),
            buildNumericButton('2', azulOscuro),
            buildNumericButton('3', azulClaro),
          ],
        ),
        const SizedBox(height: 2.0),
        Row(
          children: [
            buildNumericButton('4', azulOscuro),
            buildNumericButton('5', azulClaro),
            buildNumericButton('6', azulOscuro),
          ],
        ),
        const SizedBox(height: 2.0),
        Row(
          children: [
            buildNumericButton('7', azulClaro),
            buildNumericButton('8', azulOscuro),
            buildNumericButton('9', azulClaro),
          ],
        ),
        const SizedBox(height: 2.0),
        Row(
          children: [
            buildActionButton('D', Icons.arrow_back),
            buildNumericButton('0', azulClaro),
            lateBotton(),
          ],
        ),
        const SizedBox(height: 2.0),
      ],
    );
  }

  Widget buildNumericButton(String label, Color backgroundColor) {
    return SizedBox(
      width: widget.w,
      height: widget.h,
      child: ElevatedButton(
        onPressed: () {
          widget.pinController.text += label;
          setState(() {
            noUser = '';
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 45, color: Colors.black),
        ),
      ),
    );
  }

  Widget buildActionButton(String label, IconData iconData) {
    return Container(
      width: widget.w,
      height: widget.h,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: GestureDetector(
          onTap: () {
            if (widget.text == '.') {
              widget.pinController.text += label;
            } else {
              if (label == 'D' && widget.pinController.text.isNotEmpty) {
                widget.pinController.text = widget.pinController.text
                    .substring(0, widget.pinController.text.length - 1);
                setState(() {
                  noUser = '';
                });
              } else if (label == 'S') {
                comprobarPIN();
              }
            }
          },
          child: Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Icon(
                iconData,
                color: Colors.blue,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void comprobarPIN() async {
    if (widget.pinController.text.isNotEmpty) {
      var selectedEmployee =
          await getEmployeeByPIN(int.parse(widget.pinController.text));
      if (selectedEmployee != null) {
        widget.goToMapaPage();
      }
      setState(() {
        noUser = 'Usuario no encontrado';
      });
    }
  }

  Widget lateBotton() {
    if (widget.text == '.') {
      return buildNumericButton('.', Color(0xFF3D8BE7));
    } else {
      return buildActionButton(widget.text, Icons.check);
    }
  }
}
