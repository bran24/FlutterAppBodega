import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../Consts/firebase_const.dart';

class botellasController extends GetxController {
  TextEditingController cantidadtextController = TextEditingController();
  TextEditingController fechatextController = TextEditingController();
  TextEditingController clienteidtextController = TextEditingController();
  TextEditingController nombretextController = TextEditingController();
  TextEditingController clientenombretextController = TextEditingController();
  TextEditingController estadotextController = TextEditingController();
  TextEditingController montotextController = TextEditingController();
  var clienteslist = <Map<String, dynamic>>[].obs;
  limpiarCampos() {
    nombretextController.text = "";
    fechatextController.text = "";
    clienteidtextController.text = "";
    nombretextController.text = "";
    clientenombretextController.text = "";
    cantidadtextController.text = "1";
    estadotextController.text = "";
    montotextController.text = "";
  }

  var isloading = false.obs;

  updatebotellas({required String? id}) async {
    var store = firestore.collection("Botellas").doc(id);
    if (clienteidtextController.text.toString().isEmpty) {
      var clir = firestore.collection("Cliente").doc();
      await clir.set(
        {
          "id": clir.id,
          "informacion_adicional": "",
          "telefono": "",
          "email": "",
          "nombre": clientenombretextController.text,
          "direccion": ""
        },
      );

      await store.set({
        "id": store.id,
        "cantidad": int.parse(cantidadtextController.text),
        "id_venta": "",
        "nombre": nombretextController.text,
        "fecha_entrega": DateTime.parse(fechatextController.text),
        "estado": estadotextController.text,
        "monto": int.parse(montotextController.text),
        "cliente": {
          "direccion": "",
          "email": "",
          "id": clir.id,
          "informacion_adicional": "",
          "nombre": clientenombretextController.text,
          "telefono": ""
        }
      }, SetOptions(merge: true)).timeout(Duration(seconds: 15));
    } else {
      var clir = await firestore
          .collection("Cliente")
          .doc(clienteidtextController.text)
          .get();

      await store.set({
        "id": store.id,
        "cantidad": int.parse(cantidadtextController.text),
        "id_venta": "",
        "nombre": nombretextController.text,
        "fecha_entrega": DateTime.parse(fechatextController.text),
        "estado": estadotextController.text,
        "monto": int.parse(montotextController.text),
        "cliente": {
          "direccion": clir['direccion'],
          "email": clir['email'],
          "id": clir['id'],
          "informacion_adicional": clir['informacion_adicional'],
          "nombre": clir['nombre'],
          "telefono": clir['telefono'],
        }
      }, SetOptions(merge: true)).timeout(Duration(seconds: 15));
    }
  }

  getclientes() async {
    clienteslist.clear();
    var data0 = await firestore
        .collection("Cliente")
        .get()
        .timeout(Duration(seconds: 15));
    var list = data0.docs.toList();
    for (var item in list) {
      clienteslist.add({"id": item['id'], "nombre": item['nombre']});
    }
    print(clienteslist);
  }

  registrarbotellas() async {
    var store = firestore.collection("Botellas").doc();
    var user0 =
        firestore.collection("user").doc(auth.currentUser!.uid.toString());

    var user = await user0.get();

    if (clienteidtextController.text.toString().isEmpty) {
      var clir = firestore.collection("Cliente").doc();
      await clir.set({
        "id": clir.id,
        "informacion_adicional": "",
        "telefono": "",
        "email": "",
        "nombre": clientenombretextController.text,
        "direccion": "",
      });

      final fechaentrega = DateTime.now();
      await store.set({
        "id": store.id,
        "cantidad": int.parse(cantidadtextController.text),
        "id_venta": "",
        "nombre": nombretextController.text,
        "fecha_entrega": fechaentrega,
        "estado": "pendiente",
        "monto": int.parse(montotextController.text),
        "cliente": {
          "direccion": "",
          "email": "",
          "id": clir.id,
          "informacion_adicional": "",
          "nombre": clientenombretextController.text,
          "telefono": ""
        },
        "vendedor": {
          "id": user['id'],
          "email": user['email'],
          "nombre": user['nombre']
        }
      }).timeout(Duration(seconds: 15));
    } else {
      var clir = await firestore
          .collection("Cliente")
          .doc(clienteidtextController.text)
          .get()
          .timeout(Duration(seconds: 15));

      final fechaentrega = DateTime.now();
      await store.set({
        "id": store.id,
        "cantidad": int.parse(cantidadtextController.text),
        "id_venta": "",
        "nombre": nombretextController.text,
        "fecha_entrega": fechaentrega,
        "estado": "pendiente",
        "monto": int.parse(montotextController.text),
        "cliente": {
          "direccion": clir['direccion'],
          "email": clir['email'],
          "id": clir['id'],
          "informacion_adicional": clir['informacion_adicional'],
          "nombre": clir['nombre'],
          "telefono": clir['telefono']
        },
        "vendedor": {
          "id": user['id'],
          "email": user['email'],
          "nombre": user['name']
        }
      }).timeout(Duration(seconds: 15));
    }
  }

  removebotellas(String id) async {
    isloading.value = true;
    await firestore
        .collection("Botellas")
        .doc(id)
        .delete()
        .timeout(Duration(seconds: 15));
  }

  cambiarEstadobotellas(String id) async {
    isloading.value = true;
    var store = firestore.collection("Botellas").doc(id);

    await store.set({"estado": "devuelto"}, SetOptions(merge: true)).timeout(
        Duration(seconds: 15));
  }
}
