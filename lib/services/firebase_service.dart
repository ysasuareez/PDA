import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurante/models/category.dart';
import 'package:restaurante/models/employe.dart';
import 'package:restaurante/models/item.dart';
import 'package:restaurante/models/subcategory.dart';
import 'package:restaurante/models/table.dart';

/// Servicio de Firebase
FirebaseFirestore db = FirebaseFirestore.instance;

/// Obtiene la lista de mesas de la base de datos
Future<List<CustomTable>> getTables() async {
  CollectionReference tablesCollection = db.collection('customeTable');
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
    for (var orderDocument in ordersSnapshot.docs) {
      Map<String, dynamic> data = orderDocument.data() as Map<String, dynamic>;
      if (data.isEmpty) continue;
      String id = orderDocument.id;
      String name = orderDocument.get('name');
      String note = orderDocument.get('note');
      double price = orderDocument.get('price');

      Item item = Item(id: id, name: name, note: note, price: price);
      orders.add(item);
    }

    CustomTable table =
        CustomTable(firebaseId: firebaseId, id: tableId, orders: orders);
    tables.add(table);
  }

  return tables;
}

/// Obtiene la lista de empleados de la base de datos
Future<List<Employe>> getEmployees() async {
  List<Employe> employees = [];

  List<QueryDocumentSnapshot<Object?>> employeesCollection =
      await _getCollection('employees');
  for (var employeeDocument in employeesCollection) {
    String id = employeeDocument.id;
    String name = employeeDocument.get('name');
    int pin = employeeDocument.get('pin');

    Employe employee = Employe(id: id, name: name, pin: pin);
    employees.add(employee);
  }

  return employees;
}

/// Obtiene la lista de categorías de la base de datos
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
        String note = itemDocument.get('note');
        double price = double.parse(itemDocument.get('price').toString());

        Item item = Item(id: id, name: name, note: note, price: price);
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

Future<void> saveOrders(List<Item> orders, String tableId) async {
  if (orders.isEmpty) return;
  if (tableId.isEmpty) return;

  CollectionReference ordersCollection =
      db.collection('customeTable').doc(tableId).collection('orders');

  // Remove all data from orders collection
  QuerySnapshot querySnapshot = await ordersCollection.get();
  for (var document in querySnapshot.docs) {
    await document.reference.delete();
  }

  for (var item in orders) {
    await ordersCollection.doc(item.id).set({
      'name': item.name,
      'note': item.note,
      'price': item.price,
    });
  }
}

/// Elimina una mesa de la base de datos
Future<void> deleteTable(String tableId) async {
  if (tableId.isEmpty) return;

  CollectionReference ordersCollection =
      db.collection('customeTable').doc(tableId).collection('orders');

  // Remove all data from orders collection
  QuerySnapshot querySnapshot = await ordersCollection.get();
  for (var document in querySnapshot.docs) {
    await document.reference.delete();
  }
}

/// Obtiene la lista de artículos de la base de datos
/// - category: Nombre de la categoría
Future<List<QueryDocumentSnapshot<Object?>>> _getCollection(
    String collection) async {
  CollectionReference collectionReference = db.collection(collection);
  QuerySnapshot querySnapshot = await collectionReference.get();

  return querySnapshot.docs;
}

/// Obtiene una colección de la base de datos
/// La clase QueryDocumentSnapshot permite obtener la información de una colección de Firebase.
/// - collection: Nombre de la colección
/// - document: Documento de referencia
Future<List<QueryDocumentSnapshot<Object?>>> _getCollectionFromDocument(
    String collection, QueryDocumentSnapshot<Object?> document) async {
  CollectionReference collectionReference =
      document.reference.collection(collection);
  QuerySnapshot querySnapshot = await collectionReference.get();

  return querySnapshot.docs;
}

/// Obtiene la lista de documentos de la base de datos.
/// La clase DocumentSnapshot permite obtener la información de un documento de Firebase.
/// - collection: Nombre de la colección
/// - document: Nombre del documento
Future<DocumentSnapshot<Object?>> getDocument(
    String collection, String document) async {
  DocumentReference documentReference = db.collection(collection).doc(document);
  DocumentSnapshot documentSnapshot = await documentReference.get();

  return documentSnapshot;
}
