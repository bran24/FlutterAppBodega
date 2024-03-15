import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter_login_taxi/Consts/conts.dart";

class FirestorServices {
  static getUser(uid) {
    return firestore
        .collection(userCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  static Future<Map> getusuario() async {
    var id = await auth.currentUser!.uid;
    var doc = await firestore.collection("user").doc(id).get();
    final data0 = doc.data() as Map<String, dynamic>;
    final Map<String, dynamic> data = {
      'name': data0['name'],
      'email': data0['email'],
      'imageUrl': data0['imageUrl']
    };

    return data;
  }

  static getProduct() {
    return firestore.collection(productCollection).snapshots();
  }

  static getBotellas() {
    return firestore.collection("Botellas").snapshots();
  }

  static getBotellasPendientes() {
    return firestore
        .collection("Botellas")
        .where('estado', isEqualTo: 'pendiente')
        .snapshots();
  }

  static getCliente() {
    return firestore.collection("Cliente").snapshots();
  }

  static getProveedor() {
    return firestore.collection("Proveedor").snapshots();
  }

  static getCategorias() {
    return firestore.collection("Categorias").snapshots();
  }

  static getProductFiltro({String? busqueda}) {
    if (busqueda!.isEmpty) {
      return firestore.collection(productCollection).snapshots();
    }

    return firestore
        .collection(productCollection)
        .where('clave', isEqualTo: busqueda)
        .snapshots();
  }

  // static getProductCat(String catid) {
  //   var cat_id = "/Categorias/" + catid;

  //   DocumentReference catref = FirebaseFirestore.instance.doc(cat_id);
  //   return firestore
  //       .collection(productCollection)
  //       .where('categoria', isEqualTo: catref)
  //       .snapshots();
  // }

  static getProductid(uid) {
    return firestore
        .collection(productCollection)
        .where('nombre', isEqualTo: uid)
        .snapshots();
  }
}


// FirebaseFirestore db = FirebaseFirestore.instance;
// Future<List> getProducto() async {
//   List Producto = [];
//   CollectionReference CollectionReferenceProducto = db.collection('Producto');
//   QuerySnapshot queryProducto = await CollectionReferenceProducto.get();

//   queryProducto.docs.forEach((doc) {
//     Producto.add(doc.data());
//   });

//   return Producto;
// }
