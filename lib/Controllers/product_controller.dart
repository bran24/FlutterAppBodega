import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_login_taxi/Services/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../Consts/firebase_const.dart';

class ProductController extends GetxController {
  TextEditingController clavetextController = TextEditingController();
  TextEditingController nombretextController = TextEditingController();

  TextEditingController cantidadtextController = TextEditingController();
  TextEditingController precioCompratextController = TextEditingController();
  TextEditingController precioVentatextController = TextEditingController();
  TextEditingController fechavencimienotextController = TextEditingController();
  TextEditingController imagentextController = TextEditingController();
  TextEditingController descripciontextController = TextEditingController();
  TextEditingController agregarCategoriatextController =
      TextEditingController();

  TextEditingController busquetextController = TextEditingController();
  var categorialist = <String>[].obs;
  var unidadlist = <String>[].obs;
  var categoryvalue = ''.obs;
  var unidadvalue = ''.obs;

  var productoImgPath = ''.obs;
  var profileImageLink = '';
  var isloading = false.obs;

  limpiarCampos() {
    clavetextController.text = '';
    cantidadtextController.text = '';
    descripciontextController.text = '';
    fechavencimienotextController.text = '';
    nombretextController.text = '';
    precioCompratextController.text = '';
    precioVentatextController.text = '';
    productoImgPath.value = '';
    profileImageLink = '';
    categoryvalue.value = '';
    unidadvalue.value = '';
  }

  getCategorias() async {
    categorialist.clear();
    var data0 = await firestore.collection("Categorias").get();
    var list = data0.docs.toList();
    for (var item in list) {
      categorialist.add(item['nombre']);
    }
  }

  getunidades() async {
    unidadlist.clear();
    var data0 = await firestore.collection("Unidad").get();
    var list = data0.docs;

    for (var item in list) {
      unidadlist.add(item['nombre']);
    }
  }

  changeImage() async {
    final img = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    try {
      if (img == null) return;
      final imgcompress = await utils.compressImage(File(img.path));
      productoImgPath.value = imgcompress!.path;
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
        timeInSecForIosWeb: 1,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

// Future<void> getLostData() async {
//   final ImagePicker picker = ImagePicker();
//   final LostDataResponse response = await picker.retrieveLostData();
//   if (response.isEmpty) {
//     return;
//   }
//   final List<XFile>? files = response.files;
//   if (files != null) {
//     _handleLostFiles(files);
//   } else {
//     _handleError(response.exception);
//   }
// }
  void fotoImagen() async {
    final img = await ImagePicker().pickImage(source: ImageSource.camera);
    try {
      if (img == null) return;
      final imgcompress = await utils.compressImage(File(img.path));

      productoImgPath.value = imgcompress!.path;
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
        timeInSecForIosWeb: 1,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  uploadProductoImage() async {
    var date = DateTime.now();
    var dat = date.year.toString() +
        date.month.toString() +
        date.day.toString() +
        date.hour.toString() +
        date.minute.toString() +
        date.second.toString() +
        date.microsecond.toString();

    var filename = basename(productoImgPath.value);
    var destination = 'productos/${dat}_${filename}';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(productoImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }

  updateProducto({required String? id}) async {
    print(fechavencimienotextController.text.toString());
    var store = firestore.collection("Producto").doc(id);
    var unidad = await firestore
        .collection("Unidad")
        .where('nombre', isEqualTo: unidadvalue.value)
        .get();
    var unidad_id = "/Unidad/" + unidad.docs[0]['id'].toString();

    var cat = await firestore
        .collection("Categorias")
        .where('nombre', isEqualTo: categoryvalue.value)
        .get();
    var cat_id = "/Categorias/" + cat.docs[0]['id'].toString();

    DocumentReference unidadref = FirebaseFirestore.instance.doc(unidad_id);
    DocumentReference catref = FirebaseFirestore.instance.doc(cat_id);

    await store.set({
      "id": store.id,
      "clave": clavetextController.text,
      "cantidad": int.parse(cantidadtextController.text),
      "descripcion": descripciontextController.text,
      "fecha_vencimiento": DateTime.parse(fechavencimienotextController.text),
      "imagenurl": profileImageLink,
      "nombre": nombretextController.text,
      "precio_compra": double.parse(precioCompratextController.text),
      "precio_venta": double.parse(precioVentatextController.text),
      "unidad": unidadref,
      "categoria": catref
    }).timeout(Duration(seconds: 15));
  }

  registrarProducto() async {
    var store = firestore.collection("Producto").doc();
    var unidad = await firestore
        .collection("Unidad")
        .where('nombre', isEqualTo: unidadvalue.value)
        .get();
    var unidad_id = "/Unidad/" + unidad.docs[0]['id'].toString();

    var cat = await firestore
        .collection("Categorias")
        .where('nombre', isEqualTo: categoryvalue.value)
        .get();
    var cat_id = "/Categorias/" + cat.docs[0]['id'].toString();

    DocumentReference unidadref = FirebaseFirestore.instance.doc(unidad_id);
    DocumentReference catref = FirebaseFirestore.instance.doc(cat_id);
    await store.set({
      "id": store.id,
      "clave": clavetextController.text,
      "cantidad": int.parse(cantidadtextController.text),
      "descripcion": descripciontextController.text,
      "fecha_vencimiento": DateTime.parse(fechavencimienotextController.text),
      "imagenurl": profileImageLink,
      "nombre": nombretextController.text,
      "precio_compra": double.parse(precioCompratextController.text),
      "precio_venta": double.parse(precioVentatextController.text),
      "unidad": unidadref,
      "categoria": catref
    }).timeout(Duration(seconds: 15));
  }

  removeProduct(String id) async {
    isloading.value = true;
    await firestore.collection("Producto").doc(id).delete();
  }

  agregarCategoria() async {
    var store = firestore.collection("Categorias").doc();

    await store.set({
      "id": store.id,
      "nombre": agregarCategoriatextController.text
    }).timeout(Duration(seconds: 15));

    print("cantidadddddd");
  }
}
