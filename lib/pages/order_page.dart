import 'package:flutter/material.dart';
import 'package:restaurante/models/item.dart';
import 'package:restaurante/services/firebase_service.dart';

import '../dialogs/deleteDialog.dart';
import '../models/category.dart';
import '../models/customTable.dart';
import '../models/subcategory.dart';
import '../utils/group.dart';

/// Represent a page where orders are managed for a specific table.
class OrdersPage extends StatefulWidget {
  /// It contains the following properties:
  /// A function that navigates to the order page. Used to reinvoke.
  final void Function(CustomTable) goToOrderPage;

  /// A function that navigates to the mapa page.
  final void Function() goToMapaPage;

  /// This property represents the current table being managed on the order page.
  final CustomTable table;

  const OrdersPage(
      {super.key,
      required this.table,
      required this.goToOrderPage,
      required this.goToMapaPage});

  @override
  OrdersPageState createState() => OrdersPageState();
}

class OrdersPageState extends State<OrdersPage> {
  /// DESING MENU
  Color categoryColor = const Color(0xFF5DDAAD);
  Color subcategoryColor = const Color(0xFFFFD056);
  Color itemColor = const Color(0xFFDA71FF);
  List<Category> categories = [];
  Category currentCategory = Category(id: "", name: "", subcategories: []);
  Subcategory currentSubcategory = Subcategory(id: "", name: "", items: []);
  List<Item> currentSubcategoryItemList = [];

  /// SIZE BUTTONS
  double w = 255;
  double h = 230;

  /// UTILS
  /// It is a list that holds the ordered items for the table.
  List<Group> groupList = [];

  /// This list contains the newly added items that are yet to be sent.
  List<Item> newItemsList = [];

  /// Represents the total price of the ordered items.
  double totalPrice = 0;

  /// It is a list that holds the grouped order items.
  List<Item> orderList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loadDataMenu();
    _loadDataBill();
    return Scaffold(
      body: Column(
        children: [
          //BILL
          Column(
            children: [
              Container(
                width: 400,
                height: 50,
                color: const Color(0xFF3D8BE7),
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, left: 8),
                  child: Text("MESA ${widget.table.id}",
                      style:
                          const TextStyle(fontSize: 25, color: Colors.white)),
                ),
              ),
              Container(
                width: 410,
                height: 40,
                decoration: const BoxDecoration(
                    color: Color(0xFFB0D5FF),
                    border: Border(
                      left: BorderSide(color: Color(0xFF3D8BE7), width: 1.0),
                      right: BorderSide(color: Color(0xFF3D8BE7), width: 1.0),
                      bottom: BorderSide(color: Color(0xFF3D8BE7), width: 1.0),
                    )),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: SizedBox(
                        width: 150,
                        child: Text("PRODUCTO", style: TextStyle(fontSize: 17)),
                      ),
                    ),
                    Container(
                      width: 1.5,
                      color: const Color.fromARGB(255, 166, 166, 166),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 11, right: 5),
                      child: SizedBox(
                        width: 20,
                        child: Text("U", style: TextStyle(fontSize: 17)),
                      ),
                    ),
                    Container(
                      width: 1.5,
                      color: const Color.fromARGB(255, 166, 166, 166),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 50,
                        child: Text("IMP", style: TextStyle(fontSize: 17)),
                      ),
                    ),
                    Container(
                      width: 1.5,
                      color: const Color.fromARGB(255, 166, 166, 166),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 60,
                        child: Text("TOTAL", style: TextStyle(fontSize: 17)),
                      ),
                    ),
                    Container(
                      width: 1.5,
                      color: const Color.fromARGB(255, 166, 166, 166),
                    ),
                  ],
                ),
              ),
              Container(
                width: 400,
                height: 290,
                decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(color: Color(0xFF3D8BE7), width: 1.0),
                        right: BorderSide(color: Color(0xFF3D8BE7), width: 1.0),
                        bottom:
                            BorderSide(color: Color(0xFF3D8BE7), width: 1.0))),
                child: ListView(
                  shrinkWrap: true,
                  children: groupList.map((item) {
                    return Container(
                      height: 40,
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                            color: Color.fromARGB(255, 166, 166, 166)),
                      )),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 8),
                            child: SizedBox(
                              width: 150,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(item.name,
                                        style: const TextStyle(fontSize: 17)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 1.5,
                            height: 50,
                            color: const Color.fromARGB(255, 166, 166, 166),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 11, right: 5),
                            child: SizedBox(
                              width: 20,
                              child: Text("${item.units}",
                                  style: const TextStyle(fontSize: 17)),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 1.5,
                            color: const Color.fromARGB(255, 166, 166, 166),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              width: 50,
                              child: Text("${item.price}€",
                                  style: const TextStyle(fontSize: 17)),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 1.5,
                            color: const Color.fromARGB(255, 166, 166, 166),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              width: 60,
                              child: Text("${item.totalPrice}€",
                                  style: const TextStyle(fontSize: 17)),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 1.5,
                            color: const Color.fromARGB(255, 166, 166, 166),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: IconButton(
                              onPressed: () {
                                if (orderList.contains(orderList.firstWhere(
                                    (element) => element.name == item.name))) {
                                  orderList.remove(orderList.firstWhere(
                                      (element) => element.name == item.name));
                                } else if (newItemsList.contains(
                                    newItemsList.firstWhere((element) =>
                                        element.name == item.name))) {
                                  newItemsList.remove(newItemsList.firstWhere(
                                      (element) => element.name == item.name));
                                }

                                setState(() {
                                  _loadDataBill();
                                });
                              },
                              icon: const Icon(Icons.close),
                              iconSize: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              //MENU
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: SizedBox(
                      width: 97,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (orderList.isNotEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) => DeleteDialog(
                                      afirmativeAction: () async {
                                        await updateTable(
                                            widget.table, 'eliminada');

                                        setState(() {
                                          Navigator.pop(context);
                                        });
                                        widget.goToMapaPage();

                                        await closeTable(
                                          widget.table,
                                        );
                                      },
                                    ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3D8BE7),
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: SizedBox(
                      width: 95,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (newItemsList.isNotEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) => DeleteDialog(
                                      afirmativeAction: () {
                                        Navigator.pop(context);
                                        widget.goToMapaPage();
                                      },
                                    ));
                          } else {
                            widget.goToMapaPage();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3D8BE7),
                        ),
                        child: const Icon(
                          Icons.map_outlined,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: SizedBox(
                      width: 96,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (orderList.isNotEmpty) {
                            updateIsBilledOut(widget.table, 'true');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3D8BE7),
                        ),
                        child: const Icon(
                          Icons.print,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: SizedBox(
                      width: 96,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (newItemsList.isNotEmpty) {
                            await addListItemToTable(
                                newItemsList, widget.table.firebaseId);
                            await openTable(
                              widget.table,
                            );
                            newItemsList.clear();
                            widget.goToMapaPage();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3D8BE7),
                        ),
                        child: const Icon(
                          Icons.send_outlined,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //CARTA
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: SizedBox(
                  width: 400,
                  child: FutureBuilder<List<Category>>(
                      future: getCategories(),
                      builder: (context, snapshot) {
                        int rowCountCategories = (categories.length / 5).ceil();
                        int rowCountSubcategories =
                            (currentCategory.subcategories.length / 5).ceil();
                        int rowCountItems =
                            (currentSubcategory.items.length / 5).ceil();
                        return Column(
                          children: [
                            Column(
                              children:
                                  List.generate(rowCountCategories, (rowIndex) {
                                int startIndex = rowIndex * 5;
                                int endIndex = (rowIndex + 1) * 5;
                                if (endIndex > categories.length) {
                                  endIndex = categories.length;
                                }

                                List<Category?> rowCategories = List.from(
                                    categories.sublist(startIndex, endIndex));
                                rowCategories.addAll(List.filled(
                                    4 - (endIndex - startIndex), null));

                                return _buildButtonRow(
                                    rowCategories,
                                    _handleCategoryButtonPressed,
                                    categoryColor);
                              }),
                            ),
                            SizedBox(
                              height: 257,
                              child: ListView(
                                children: [
                                  Column(
                                    children: List.generate(
                                        rowCountSubcategories, (rowIndex) {
                                      int startIndex = rowIndex * 4;
                                      int endIndex = (rowIndex + 1) * 4;
                                      if (endIndex >
                                          currentCategory
                                              .subcategories.length) {
                                        endIndex = currentCategory
                                            .subcategories.length;
                                      }

                                      List<Subcategory?> rowSubcategories =
                                          List.from(currentCategory
                                              .subcategories
                                              .sublist(startIndex, endIndex));
                                      rowSubcategories.addAll(List.filled(
                                          4 - (endIndex - startIndex), null));

                                      return _buildButtonRow(
                                          rowSubcategories,
                                          _handleSubcategoryButtonPressed,
                                          subcategoryColor);
                                    }),
                                  ),
                                  Column(
                                    children: List.generate(rowCountItems,
                                        (rowIndex) {
                                      int startIndex = rowIndex * 4;
                                      int endIndex = (rowIndex + 1) * 4;
                                      if (endIndex >
                                          currentSubcategory.items.length) {
                                        endIndex =
                                            currentSubcategory.items.length;
                                      }

                                      List<Item?> rowItems = List.from(
                                        currentSubcategory.items
                                            .sublist(startIndex, endIndex),
                                      );
                                      rowItems.addAll(List.filled(
                                          4 - (endIndex - startIndex), null));

                                      return _buildButtonRow(rowItems,
                                          _handleItemButtonPressed, itemColor);
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildButtonRow(
      List<dynamic> objetc, Function onPressed, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: objetc.map((item) {
        if (item != null) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: ElevatedButton(
                onPressed: () => onPressed(item),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  elevation: 0,
                  padding: const EdgeInsets.all(0),
                ),
                child: Container(
                  height: 65,
                  decoration: BoxDecoration(
                    color: color,
                  ),
                  child: Center(
                    child: item.name != null
                        ? Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              item.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
          );
        } else {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Stack(
                children: [
                  Center(
                    child: Opacity(
                      opacity: 0.15, // Ajusta la opacidad según tus necesidades
                      child: SizedBox(
                        width: 40,
                        child: Image.asset(
                          'lib/assets/images/menu_null_nombre.jpg',
                          fit: BoxFit
                              .fill, // Ajusta el modo de ajuste según tus necesidades
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }).toList(),
    );
  }

  /// This method is called when a category button is pressed. It updates the
  /// currentCategory and currentSubcategory properties based on the selected
  ///  category.
  void _handleCategoryButtonPressed(Category category) {
    setState(() {
      currentCategory = category;
      currentSubcategory = category.subcategories.first;
    });
  }

  /// Similar to _handleCategoryButtonPressed
  void _handleSubcategoryButtonPressed(Subcategory subcategory) {
    setState(() {
      currentSubcategory = subcategory;
    });
  }

  /// This method is called when an item button is pressed. It adds the selected
  /// item to both the newItemsList and orderList, updates the groupList, and
  /// recalculates the totalPrice.
  void _handleItemButtonPressed(Item item) {
    newItemsList.add(item);
    orderList.add(item);
    setState(() {
      groupList = _getGroupedOrder();
      totalPrice = orderList
          .map((e) => e.price)
          .fold(0, (value, element) => value + element);
    });
  }

  ///This method takes the orderList and groups the ordered items based on their
  /// name and price. It returns a list of Group objects that represent the
  ///  grouped items.
  List<Group> _getGroupedOrder() {
    Map<String, Group> orderGroup = {};

    for (var item in orderList) {
      String key = '${item.name}-${item.price}';
      if (orderGroup.containsKey(key)) {
        orderGroup[key]!.units += 1;
      } else {
        orderGroup[key] = Group(
          id: item.id,
          name: item.name,
          price: item.price,
          units: 1,
        );
      }
    }

    return orderGroup.values.toList();
  }

  /// This method loads the menu data, including categories, subcategories, and
  ///  items. It initializes the categories, currentCategory, currentSubcategory,
  ///  and currentSubcategoryItemList properties.
  void _loadDataMenu() async {
    var loadedCategories = await getCategories();

    categories = loadedCategories;
    currentCategory = categories.first;
    currentSubcategory = currentCategory.subcategories.first;
    currentSubcategoryItemList = currentSubcategory.items;
  }

  ///_loadDataBill(): This method loads the order data for the current table.
  /// It populates the orderList, groupList, and totalPrice based on the
  ///  existing orders.
  void _loadDataBill() {
    orderList = widget.table.orders;
    groupList = _getGroupedOrder();
    totalPrice = orderList
        .map((e) => e.price)
        .fold(0, (value, element) => value + element);
  }
}
