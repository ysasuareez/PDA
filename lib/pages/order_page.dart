import 'package:flutter/material.dart';
import 'package:restaurante/models/employe.dart';
import 'package:restaurante/models/item.dart';
import 'package:restaurante/models/subcategory.dart';
import 'package:restaurante/pages/tables_page.dart';
import 'package:restaurante/services/firebase_service.dart';

import '../models/category.dart';
import '../models/table.dart';

class OrdersPage extends StatefulWidget {
  final CustomTable table;
  final Employe employee;

  const OrdersPage({super.key, required this.table, required this.employee});

  @override
  OrdersPageState createState() => OrdersPageState();
}

class OrdersPageState extends State<OrdersPage> {
  List<Category> categories = [];
  Category currentCategory = Category(id: "", name: "", subcategories: []);
  Subcategory currentSubcategory = Subcategory(id: "", name: "", items: []);
  List<Item> currentSubcategoryItemList = [];
  List<Item> orderList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    CustomTable table = widget.table;

    return WillPopScope(
      onWillPop: () async {
        if (orderList.isNotEmpty) {
          alertAbandonarComanda();
        } else {
          return true;
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 70, 50, 43),
          title: Text(
            'Mesa ${table.id}',
            style: const TextStyle(
              color: Color.fromARGB(255, 253, 233, 204),
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              color: const Color.fromARGB(255, 253, 233, 204),
              onPressed: () {
                if (orderList.isNotEmpty) {
                  enviarComanda(table);
                } else {
                  alertMesaVacia();
                }
              },
              icon: const Icon(Icons.send_outlined),
            ),
            IconButton(
              color: const Color.fromARGB(255, 253, 233, 204),
              icon: const Icon(Icons.delete),
              onPressed: () {
                if (orderList.isNotEmpty) {
                  eliminarComanda(table);
                } else {
                  alertMesaVacia();
                }
              },
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 253, 233, 204),
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
                itemCount: orderList.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(orderList[i].name),
                    subtitle: Text(orderList[i].note),
                    trailing: SizedBox(
                      width: 100.0,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                addNote(orderList[i]);
                              });
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                orderList.removeAt(i);
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Mostramos la botonera mapeando el List
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: categories.map((Category category) {
                  return Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          currentCategory = category;
                          currentSubcategory = category.subcategories.first;
                          currentSubcategoryItemList = currentSubcategory.items;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 0.5),
                          color: const Color.fromARGB(255, 23, 150, 148),
                        ),
                        child: Center(
                          child: Text(
                            category.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Mostramos las subcategorias mapeando el List
            currentCategory.name.isNotEmpty
                ? SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: categories
                          .where(
                              (category) => category.id == currentCategory.id)
                          .first
                          .subcategories
                          .map((subcategory) {
                        return Expanded(
                          child: InkWell(
                            onTap: () {
                              List<Item> subcategoryItems = subcategory.items;

                              setState(() {
                                currentSubcategory = subcategory;
                                currentSubcategoryItemList = subcategoryItems;
                              });
                            },
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 0.5),
                                  color: const Color.fromARGB(255, 245, 123, 0),
                                ),
                                child: Center(
                                    child: Text(
                                  subcategory.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : Container(),

            // Mostramos los items de la subcategoria mapeando el List
            currentCategory.name.isNotEmpty &&
                    currentSubcategory.name.isNotEmpty
                ? SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: currentSubcategoryItemList.map((Item item) {
                        return Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                //Creamos una nueva instancia de Item al agregarlo a la
                                //lista para que cada objeto en la lista sea independiente
                                //Si no se hace eso, se estaría añadiendo el mismo item tantas
                                //veces como se pulse, y no seria posible cambiar las notas
                                //por separado
                                orderList.add(Item(
                                  id: UniqueKey().toString(),
                                  name: item.name,
                                  note: item.note,
                                  price: item.price,
                                ));
                              });
                            },
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 0.5),
                                  color:
                                      const Color.fromARGB(255, 255, 244, 192),
                                ),
                                child: Center(
                                    child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : const SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  ///METODOS DE ALERTS
  ///
  void alertMesaVacia() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 253, 233, 204),
          title: const Text('Mesa vacía.'),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 70, 50, 43)),
                  minimumSize: MaterialStateProperty.all(const Size(80, 40))),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                currentSubcategoryItemList.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void eliminarComanda(CustomTable table) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 253, 233, 204),
          title: const Text('¿Eliminar comanda?'),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 70, 50, 43)),
                  minimumSize: MaterialStateProperty.all(const Size(80, 40))),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 70, 50, 43)),
                  minimumSize: MaterialStateProperty.all(const Size(80, 40))),
              child: const Text(
                'Eliminar',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                deleteTable(table.firebaseId).then((value) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => TablesPage(
                        employee: widget.employee,
                      ),
                    ),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  void enviarComanda(CustomTable table) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 249, 240, 227),
          title: const Text('¿Enviar comanda?'),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 70, 50, 43)),
                  minimumSize: MaterialStateProperty.all(const Size(80, 40))),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Color.fromARGB(255, 249, 240, 227),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 70, 50, 43)),
                  minimumSize: MaterialStateProperty.all(const Size(80, 40))),
              child: const Text(
                'Enviar',
                style: TextStyle(
                  color: Color.fromARGB(255, 249, 240, 227),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                //guardar comanda
                saveOrders(orderList, table.firebaseId).then((value) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => TablesPage(
                        employee: widget.employee,
                      ),
                    ),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  void alertAbandonarComanda() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 249, 240, 227),
        title: const Text(
          '¿Abandonar comanda?',
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 70, 50, 43)),
                minimumSize: MaterialStateProperty.all(const Size(80, 40))),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: Color.fromARGB(255, 249, 240, 227),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 70, 50, 43)),
                minimumSize: MaterialStateProperty.all(const Size(80, 40))),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Abandonar',
              style: TextStyle(
                color: Color.fromARGB(255, 249, 240, 227),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addNote(Item item) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 249, 240, 227),
        title: Text('Nota de ${item.name}'),
        content: TextField(
          controller: controller,
          onChanged: (value) {
            setState(() {
              item.note = value;
            });
          },
          decoration: const InputDecoration(hintText: 'Escribir aquí...'),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 70, 50, 43)),
                minimumSize: MaterialStateProperty.all(const Size(80, 40))),
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 70, 50, 43)),
                minimumSize: MaterialStateProperty.all(const Size(80, 40))),
            child: const Text('Aceptar'),
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

  void _loadData() async {
    var loadedCategories = await getCategories();

    setState(() {
      categories = loadedCategories;
      currentCategory = categories.first;
      currentSubcategory = currentCategory.subcategories.first;
      currentSubcategoryItemList = currentSubcategory.items;
      orderList = widget.table.orders;
    });
  }
}
