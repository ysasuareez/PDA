import 'package:flutter/material.dart';

///Represents a dialog for confirming the deletion of a command.
class DeleteDialog extends StatefulWidget {
  /// It contains the following properties:
  ///It has a required afirmativeAction parameter, which is a callback function
  ///that will be called when the user confirms the deletion.
  final void Function() afirmativeAction;

  const DeleteDialog({
    Key? key,
    required this.afirmativeAction,
  }) : super(key: key);

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 100),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Image.asset(
                  'lib/assets/images/camareros.jpg',
                  width: 230,
                ),
                const SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF7B7B7B),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '¡CUIDADO JEFE!',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Nunito',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'ESTÁS A PUNTO DE\nELIMINAR UNA COMANDA',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontFamily: 'Nunito',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Close the dialog
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD056),
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'CANCELAR',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF5C5C5C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // calls the afirmativeAction callback provided through the
                    // DeleteDialog widget
                    ElevatedButton(
                      onPressed: () {
                        widget.afirmativeAction();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD056),
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'CONTINUAR',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF5C5C5C),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          )),
    );
  }
}
