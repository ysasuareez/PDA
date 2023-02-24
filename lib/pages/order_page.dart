import 'package:flutter/material.dart';
import 'package:restaurante/pages/tables_page.dart';
import 'package:restaurante/utils/employe.dart';
import 'package:restaurante/utils/item.dart';
import 'package:restaurante/utils/subcategory.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/category.dart';
import '../utils/table.dart';

class OrdersPage extends StatefulWidget {
  final CustomTable table;
  final Employe employee;

  OrdersPage({required this.table, required this.employee});

  @override
  OrdersPageState createState() => OrdersPageState();
}

class OrdersPageState extends State<OrdersPage> {
  List<Category> categories = [];
  List<Item> items = [];
  String currentCategory = "";
  String currentSubcategory = "";

  List<Item> comanda = [];

  @override
  void initState() {
    super.initState();
    currentCategory = "";
    currentSubcategory = "";
    _loadData();
  }

  void _loadData() async {
    final response = await http.get(Uri.parse(
        'https://my-json-server.typicode.com/ysasuareez/PDA2json/categories'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        categories = List<Category>.from(
            data.map((category) => Category.fromJson(category)));
        currentCategory = categories.isNotEmpty ? categories[0].name : "";
        currentSubcategory =
            categories.isNotEmpty && categories[0].subcategories.isNotEmpty
                ? categories[0].subcategories[0].name
                : "";
        items = categories
            .where((category) => category.name == currentCategory)
            .first
            .subcategories
            .where((subcategory) => subcategory.name == currentSubcategory)
            .first
            .items;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (comanda.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('¿Abandonar comanda?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('Abandonar'),
                ),
              ],
            ),
          );
        } else {
          return true;
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mesa ${widget.table.id}'),
          actions: [
            IconButton(
              onPressed: () {
                if (comanda.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('¿Enviar comanda?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Enviar'),
                            onPressed: () {
                              //guardar comanda
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Mesa vacía.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              items.clear();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              icon: const Icon(Icons.send_outlined),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                if (comanda.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('¿Eliminar comanda?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Eliminar'),
                            onPressed: () {
                              items.clear();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Mesa vacía.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              items.clear();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            // Mostramos la lista de items seleccionados
            Expanded(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: Colors.grey[700],
                    height: 0.5,
                  );
                },
                itemCount: comanda.length,
                itemBuilder: (context, i) {
                  return Container(
                    child: ListTile(
                      title: Text(comanda[i].item),
                      subtitle: Text(comanda[i].note),
                      trailing: SizedBox(
                        width: 100.0,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  addNote(comanda[i]);
                                });
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  comanda.removeAt(i);
                                });
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Mostramos la botonera mapeando el List
            Container(
              height: 50,
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 10,
                children: categories.map((category) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        currentCategory = category.name;
                        currentSubcategory = category.subcategories[1].name;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(category.name),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Mostramos las subcategorias mapeando el List
            currentCategory.isNotEmpty
                ? Container(
                    height: 50,
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 10,
                      children: categories
                          .where((category) => category.name == currentCategory)
                          .first
                          .subcategories
                          .map((subcategory) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              currentSubcategory = subcategory.name;
                              items = categories
                                  .where((category) =>
                                      category.name == currentCategory)
                                  .first
                                  .subcategories
                                  .where((subcategory) =>
                                      subcategory.name == currentSubcategory)
                                  .first
                                  .items;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(subcategory.name),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : Container(),

            // Mostramos los items de la subcategoria mapeando el List
            currentCategory.isNotEmpty && currentSubcategory.isNotEmpty
                ? Container(
                    height: 50,
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 10,
                      children: categories
                          .firstWhere(
                              (element) => element.name == currentCategory)
                          .subcategories
                          .firstWhere(
                              (element) => element.name == currentSubcategory)
                          .items
                          .map((item) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              //Creamos una nueva instancia de Item al agregarlo a la
                              //lista para que cada objeto en la lista sea independiente
                              //Si no se hace eso, se estaría añadiendo el mismo item tantas
                              //veces como se pulse, y no seria posible cambiar las notas
                              //por separado
                              comanda.add(Item(
                                item.id,
                                item.item,
                                item.note,
                                item.price,
                              ));
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(item.item),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void addNote(Item item) {
    String nota = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nota ${item.item}'),
        content: TextField(
          onChanged: (value) {
            setState(() {
              item.note = value;
            });
          },
          decoration: InputDecoration(hintText: 'Escribir aquí...'),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('Aceptar'),
            onPressed: () {
              setState(() {
                Navigator.of(context).pop();
              });
            },
          ),
        ],
      ),
    );
  }
}
