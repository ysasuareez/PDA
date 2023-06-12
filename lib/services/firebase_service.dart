import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:restaurante/models/category.dart';
import 'package:restaurante/models/employe.dart';
import 'package:restaurante/models/item.dart';
import 'package:restaurante/models/subcategory.dart';
import 'package:restaurante/models/customTable.dart';
import 'package:restaurante/utils/group.dart';

/// We uses the cloud_firestore package to interact with the Firebase Firestore
/// database. It defines several functions to perform operations such as
/// retrieving tables, employees, categories, and adding data to the database.

/// The FirebaseFirestore instance db is created to interact with the Firestore database.
FirebaseFirestore db = FirebaseFirestore.instance;

/// This function retrieves a list of tables from the "bbddTables"
/// collection in the database. It iterates over the documents in the
/// collection, retrieves the data, and constructs CustomTable objects.
Future<List<CustomTable>> getBBDDTables() async {
  CollectionReference tablesCollection = db.collection('bbddTables');
  QuerySnapshot querySnapshot = await tablesCollection.get();

  List<CustomTable> tables = [];
  for (var tableDocument in querySnapshot.docs) {
    Map<String, dynamic> data = tableDocument.data() as Map<String, dynamic>;
    if (data.isEmpty) continue;

    String tableId = tableDocument.get('id').toString();
    String firebaseId = tableDocument.id;

    CollectionReference ordersCollection =
        tableDocument.reference.collection('orders');
    QuerySnapshot ordersSnapshot = await ordersCollection.get();

    List<Item> orders = [];
    String closingTime = tableDocument.get('closingTime');
    String date = tableDocument.get('date');
    String openingTime = tableDocument.get('openingTime');
    String state = tableDocument.get('state');

    for (var orderDocument in ordersSnapshot.docs) {
      Map<String, dynamic> data = orderDocument.data() as Map<String, dynamic>;
      if (data.isEmpty) continue;
      String id = orderDocument.id;
      String name = orderDocument.get('name');
      double price = orderDocument.get('price');

      Item item = Item(id: id, name: name, price: price);
      orders.add(item);
    }

    CustomTable table = CustomTable(
        firebaseId: firebaseId,
        id: int.parse(tableId),
        orders: orders,
        isBilledOut: 'false',
        closingTime: closingTime,
        date: date,
        openingTime: openingTime,
        state: state);
    tables.add(table);
  }

  return tables;
}

/// This function retrieves a single table from the "customTables" collection
/// based on the provided table ID. It searches for the document with a
/// matching ID, retrieves the data, and constructs a CustomTable object.
Future<CustomTable?> getTableById(int id) async {
  CollectionReference tablesCollection = db.collection('customTables');
  QuerySnapshot querySnapshot =
      await tablesCollection.where('id', isEqualTo: id).get();

  var tableDocument;
  if (querySnapshot.docs.isNotEmpty) {
    tableDocument = querySnapshot.docs[0];
    Map<String, dynamic> data = tableDocument.data() as Map<String, dynamic>;

    String tableId = tableDocument.get('id').toString();
    String firebaseId = tableDocument.id;

    CollectionReference ordersCollection =
        tableDocument.reference.collection('orders');
    QuerySnapshot ordersSnapshot = await ordersCollection.get();

    List<Item> orders = [];
    String isBilledOut = tableDocument.get('isBilledOut');
    String closingTime = tableDocument.get('closingTime');
    String date = tableDocument.get('date');
    String openingTime = tableDocument.get('openingTime');
    String state = tableDocument.get('state');

    for (var orderDocument in ordersSnapshot.docs) {
      Map<String, dynamic> data = orderDocument.data() as Map<String, dynamic>;
      if (data.isEmpty) continue;
      String id = orderDocument.id;
      String name = orderDocument.get('name');
      double price = orderDocument.get('price');

      Item item = Item(id: id, name: name, price: price);
      orders.add(item);
    }

    CustomTable table = CustomTable(
        firebaseId: firebaseId,
        id: int.parse(tableId),
        orders: orders,
        isBilledOut: isBilledOut,
        closingTime: closingTime,
        date: date,
        openingTime: openingTime,
        state: state);

    return table;
  } else {
    return null;
  }
}

/// This function retrieves the orders associated with a specific table.
/// It fetches the documents from the "orders" subcollection of the table
/// and constructs Item objects.
Future<List<Item>> getOrderFromTable(CustomTable table) async {
  List<Item> orders = [];

  CollectionReference ordersCollection =
      db.collection('customTables').doc(table.firebaseId).collection('orders');

  QuerySnapshot querySnapshot = await ordersCollection.get();
  for (var document in querySnapshot.docs) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    if (data.isEmpty) continue;

    String id = document.id;
    String name = document.get('name');
    double price = document.get('price');

    Item item = Item(id: id, name: name, price: price);
    orders.add(item);
  }

  return orders;
}

/// his function adds a new custom table to the "customTables" collection in
/// the database. It checks if a table with the same ID already exists and,
/// if not, adds the new table document.
Future<void> addCustomTable(CustomTable t) async {
  CollectionReference tablesCollection = db.collection('customTables');

  QuerySnapshot querySnapshot =
      await tablesCollection.where('id', isEqualTo: t.id).get();
  if (querySnapshot.size > 0) {
    return;
  }

  DocumentReference tableDocument = tablesCollection.doc(t.firebaseId);

  await tableDocument.set({
    'id': t.id,
    'isBilledOut': t.isBilledOut,
    'date': t.date,
    'openingTime': t.openingTime,
    'closingTime': t.closingTime,
    'state': t.state,
  });
}

/// This function adds a table to the "bbddTables" collection to keep a
/// history of closed tables. It creates a new document with a timestamp as
/// the document ID, sets the table details, and adds the orders as
/// subcollection documents.
Future<void> addHistoryTable(CustomTable t) async {
  CollectionReference tablesCollection = db.collection('bbddTables');

  DocumentReference<Map<String, dynamic>> bbddTablesCollection =
      db.collection('bbddTables').doc('${DateTime.now()}');

  CollectionReference ordersCollection =
      bbddTablesCollection.collection('orders');

  await bbddTablesCollection.set({
    'id': t.id,
    'date': t.date,
    'openingTime': t.openingTime,
    'closingTime': t.closingTime,
    'state': t.state,
  });

  for (var item in t.orders) {
    await ordersCollection.doc(item.id).set({
      'name': item.name,
      'price': item.price,
    });
  }
}

/// This function updates the "isBilledOut" field of a table document in the
/// "customTables" collection.
Future<void> updateIsBilledOut(CustomTable t, String isBilledOut) async {
  final collection = FirebaseFirestore.instance.collection('customTables');
  final document = collection.doc(t.firebaseId);

  await document.update({'isBilledOut': isBilledOut});
}

/// This function updates the "date" field of a table document in the
/// "customTables" collection.
Future<void> updateDate(CustomTable t, String date) async {
  final collection = FirebaseFirestore.instance.collection('customTables');
  final document = collection.doc(t.firebaseId);

  await document.update({'date': date});
}

/// This function updates the "openingTime" field of a table document in the
/// "customTables" collection.
Future<void> updateOpeningTime(CustomTable t, String openingTime) async {
  final collection = FirebaseFirestore.instance.collection('customTables');
  final document = collection.doc(t.firebaseId);

  await document.update({'openingTime': openingTime});
}

/// This function updates the "closingTime" field of a table document in the
/// "customTables" collection.
Future<void> updateClosingTime(CustomTable t, String closingTime) async {
  final collection = FirebaseFirestore.instance.collection('customTables');
  final document = collection.doc(t.firebaseId);

  await document.update({'closingTime': closingTime});
}

/// This function updates the "state" field of a table document in the
/// "customTables" collection.
Future<void> updateState(CustomTable t, String state) async {
  final collection = FirebaseFirestore.instance.collection('customTables');
  final document = collection.doc(t.firebaseId);

  await document.update({'state': state});
}

/// This function retrieves a list of employees from the "employees"
/// collection in the database. It constructs Employee objects from
/// the retrieved data.
Future<List<Employee>> getEmployees() async {
  List<Employee> employees = [];

  List<QueryDocumentSnapshot<Object?>> employeesCollection =
      await _getCollection('employees');
  for (var employeeDocument in employeesCollection) {
    String id = employeeDocument.id;
    String name = employeeDocument.get('name');
    int pin = employeeDocument.get('pin');
    String salary = employeeDocument.get('salary');
    String birthDate = employeeDocument.get('birthDate');
    String dni = employeeDocument.get('dni');

    Employee employee = Employee(
        id: id,
        name: name,
        pin: pin,
        salary: salary,
        birthDate: birthDate,
        dni: dni);
    employees.add(employee);
  }

  return employees;
}

/// This function retrieves an employee based on their PIN from the
/// "employees" collection. It searches for a document with a matching
/// PIN and returns an Employee object if found.
Future<Employee?> getEmployeeByPIN(int pin) async {
  CollectionReference tablesCollection = db.collection('employees');
  QuerySnapshot querySnapshot =
      await tablesCollection.where('pin', isEqualTo: pin).get();

  if (querySnapshot.size == 0) {
    return null;
  }

  var employeeDocument = querySnapshot.docs[0];
  Map<String, dynamic> data = employeeDocument.data() as Map<String, dynamic>;

  return Employee(
    id: employeeDocument.id,
    name: employeeDocument.get('name'),
    pin: employeeDocument.get('pin'),
    salary: employeeDocument.get('salary'),
    birthDate: employeeDocument.get('birthDate'),
    dni: employeeDocument.get('dni'),
  );
}

/// This function adds an employee to the "employees" collection in
/// the database. It creates a new document with the employee details.
Future<void> addEmployeeToFirebase(Employee employee) async {
  CollectionReference employeesCollection =
      FirebaseFirestore.instance.collection('employees');

  try {
    await employeesCollection.doc(employee.id).set({
      'name': employee.name,
      'pin': employee.pin,
      'birthDate': employee.birthDate,
      'dni': employee.dni,
      'salary': employee.salary,
    });
    print('Empleado agregado a Firebase: ${employee.name}');
  } catch (e) {
    print('Error al agregar el empleado a Firebase: $e');
  }
}

/// This function retrieves a list of categories from the "categories"
/// collection in the database. It constructs Category objects and
/// fetches associated subcategories and items.
Future<List<Category>> getCategories() async {
  List<Category> categories = [];

  List<QueryDocumentSnapshot<Object?>> categoriesCollection =
      await _getCollection('categories');
  for (var categoryDocument in categoriesCollection) {
    String id = categoryDocument.id;
    String name = categoryDocument.get('name');

    List<QueryDocumentSnapshot<Object?>> subcategoriesCollection =
        await _getCollectionFromDocument('subcategories', categoryDocument);

    List<Subcategory> subcategories = [];
    for (var subcategoryDocument in subcategoriesCollection) {
      String id = subcategoryDocument.id;
      String subcategoryName = subcategoryDocument.get('name');

      List<QueryDocumentSnapshot<Object?>> itemsCollection =
          await _getCollectionFromDocument('items', subcategoryDocument);

      List<Item> items = [];
      for (var itemDocument in itemsCollection) {
        String id = itemDocument.id;
        String name = itemDocument.get('name');
        double price = double.parse(itemDocument.get('price').toString());

        Item item = Item(id: id, name: name, price: price);
        items.add(item);
      }

      Subcategory subcategory =
          Subcategory(id: id, name: subcategoryName, items: items);
      subcategories.add(subcategory);
    }

    Category category =
        Category(id: id, name: name, subcategories: subcategories);
    categories.add(category);
  }

  return categories;
}

/// This function adds a new category, subcategories, and items to the
/// database. It creates documents for each level and adds the relevant data.
Future<void> addCategory(Category category) async {
  CollectionReference categoryCollection = db.collection('categories');

  // Obtener el ID de la categoría
  String categoryId = category.id;

  // Crear la categoría principal con el ID personalizado
  await categoryCollection.doc(categoryId).set({
    'name': category.name,
  });

  // Recorrer las subcategorías de la categoría
  for (var subcategory in category.subcategories) {
    // Obtener el ID de la subcategoría
    String subcategoryId = subcategory.id;

    // Crear la subcategoría con el ID personalizado
    await categoryCollection
        .doc(categoryId)
        .collection('subcategories')
        .doc(subcategoryId)
        .set({
      'name': subcategory.name,
    });

    // Recorrer los items de la subcategoría
    for (var item in subcategory.items) {
      // Obtener el ID del item
      String itemId = item.id;

      // Crear el item con el ID personalizado
      await categoryCollection
          .doc(categoryId)
          .collection('subcategories')
          .doc(subcategoryId)
          .collection('items')
          .doc(itemId)
          .set({
        'id': item.id,
        'name': item.name,
        'price': item.price,
      });
    }
  }
}

/// This function adds a list of order items to a specific table in the
/// "orders" collection. It creates documents for each order item and adds
/// them as subdocuments in the "orders" subcollection of the table.
Future<void> addListItemToTable(
    List<Item> orders, String tableFirebaseId) async {
  for (var item in orders) {
    DocumentReference<Map<String, dynamic>> ordersCollection = db
        .collection('customTables')
        .doc(tableFirebaseId)
        .collection('orders')
        .doc('${DateTime.now()}');

    await ordersCollection.set({
      'name': item.name,
      'price': item.price,
    });
  }
}

/// This function adds an item to a specific table's "orders" collection.
/// It creates a new document in the "orders" subcollection of the table
/// and sets the name and price fields based on the provided item.
Future<void> addItemToTable(Item item, CustomTable table) async {
  DocumentReference<Map<String, dynamic>> ordersCollection = db
      .collection('customTables')
      .doc(table.firebaseId)
      .collection('orders')
      .doc('${DateTime.now()}');

  await ordersCollection.set({
    'name': item.name,
    'price': item.price,
  });
}

/// This function deletes an item from a table's "orders" collection.
/// It searches for the item by its name and deletes the first found
/// item's document reference.
Future<void> deleteItemFromTable(String firebaseId, String itemName) async {
  try {
    // Obtener la referencia a la colección "orders" de la mesa
    CollectionReference ordersCollection = FirebaseFirestore.instance
        .collection('customTables')
        .doc(firebaseId)
        .collection('orders');

    // Obtener la referencia al ítem por su nombre
    QuerySnapshot querySnapshot =
        await ordersCollection.where('name', isEqualTo: itemName).get();
    if (querySnapshot.docs.isNotEmpty) {
      // Eliminar el primer ítem encontrado (asumiendo que no hay duplicados del mismo nombre)
      await querySnapshot.docs.first.reference.delete();
    } else {}
  } catch (error) {}
}

/// This function deletes a table and all its associated order items.
/// It retrieves the "orders" collection of the table and deletes all
/// the documents within it.
Future<void> deleteTable(CustomTable t) async {
  int i = 0;
  CollectionReference ordersCollection =
      db.collection('customTables').doc(t.firebaseId).collection('orders');

  // Remove all data from orders collection
  QuerySnapshot querySnapshot = await ordersCollection.get();
  for (var document in querySnapshot.docs) {
    await document.reference.delete();
  }
}

/// This function moves all the tables from a given list to a specified
/// destiny table. It iterates over each table and its associated order
/// items, then adds the order items to the "orders" collection of the
/// destiny table and finally deletes the original table.
Future<void> moveTable(
    List<CustomTable> tableList, CustomTable destinyTable) async {
  List<CustomTable> copyList = List.from(tableList);
  for (var t in copyList) {
    for (var item in t.orders) {
      await db
          .collection('customTables')
          .doc(destinyTable.firebaseId)
          .collection('orders')
          .add(item.toMap());
    }

    await deleteTable(t);
  }
}

// This function updates the state of a table and other related information.
/// It sets the current date, closing time, and provided state to the table.
/// It also updates the opening time if it's empty. Finally,
/// it adds the table to the history.
Future<void> updateTable(CustomTable t, String state) async {
  DateTime now = DateTime.now();
  String closingTime = DateFormat('HH:mm').format(now);
  String date = DateFormat('yyyy-MM-dd').format(now);

  await updateDate(t, date);
  await updateState(t, state);
  await updateClosingTime(t, closingTime);
  t.date = date;
  t.state = state;
  t.closingTime = closingTime;
  if (t.openingTime == '' || t.openingTime.isEmpty) {
    updateOpeningTime(t, closingTime);
    t.openingTime = closingTime;
  }

  await addHistoryTable(t);
}

/// This function opens a table by setting its opening time to the current time.
Future<void> openTable(CustomTable t) async {
  DateTime now = DateTime.now();
  String openingTime = DateFormat('HH:mm').format(now);

  await updateOpeningTime(t, openingTime);
}

/// This function closes a table by resetting its date, state, opening time,
/// closing time, and deleting the table.
Future<void> closeTable(CustomTable t) async {
  t.date = '';
  await updateIsBilledOut(t, 'false');
  await updateDate(t, '');
  await updateState(t, '');
  await updateOpeningTime(t, '');
  await updateClosingTime(t, '');

  await deleteTable(t);
}

/// This function deletes multiple tables from the selectedTablesList.
/// It iterates over each table, deletes their associated order items,
/// and deletes the tables.
Future<void> deleteListTable(List<CustomTable> selectedTablesList) async {
  for (var t in selectedTablesList) {
    if (t.firebaseId.isEmpty) return;

    CollectionReference ordersCollection =
        db.collection('customTables').doc(t.firebaseId).collection('orders');

    QuerySnapshot querySnapshot = await ordersCollection.get();
    for (var document in querySnapshot.docs) {
      await document.reference.delete();
    }
  }
}

/// This function retrieves all documents within a specified collection.
Future<List<QueryDocumentSnapshot<Object?>>> _getCollection(
    String collection) async {
  CollectionReference collectionReference = db.collection(collection);
  QuerySnapshot querySnapshot = await collectionReference.get();

  return querySnapshot.docs;
}

/// This function retrieves all documents within a subcollection of
///  a specified document.
Future<List<QueryDocumentSnapshot<Object?>>> _getCollectionFromDocument(
    String collection, QueryDocumentSnapshot<Object?> document) async {
  CollectionReference collectionReference =
      document.reference.collection(collection);
  QuerySnapshot querySnapshot = await collectionReference.get();

  return querySnapshot.docs;
}

/// This function retrieves a specific document from a collection based
///  on the document's ID.
Future<DocumentSnapshot<Object?>> getDocument(
    String collection, String document) async {
  DocumentReference documentReference = db.collection(collection).doc(document);
  DocumentSnapshot documentSnapshot = await documentReference.get();

  return documentSnapshot;
}
