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

class ventasController extends GetxController {
  TextEditingController codigoVentatextController = TextEditingController();
  TextEditingController estadoVentatextController = TextEditingController();
  TextEditingController fechatextController = TextEditingController();
  TextEditingController formaPagotextController = TextEditingController();
  TextEditingController saldoDeudatextController = TextEditingController();
  TextEditingController tipoVentatextController = TextEditingController();
  TextEditingController totalVentatextController = TextEditingController();
  TextEditingController clientenombretextController = TextEditingController();
  TextEditingController clienteidtextController = TextEditingController();
  var productoslist = <Map<String, dynamic>>[].obs;
  var productoslistcheck = <Map<String, dynamic>>[].obs;
  var botellaslist = <Map<String, dynamic>>[].obs;

  var clienteslist = <Map<String, dynamic>>[].obs;
  limpiarCampos() {
    fechatextController.text = "";
    clienteidtextController.text = "";
    clientenombretextController.text = "";
    codigoVentatextController.text = "";
    estadoVentatextController.text = "";
    fechatextController.text = "";
    formaPagotextController.text = "";
    saldoDeudatextController.text = "";
    tipoVentatextController.text = "";
    totalVentatextController.text = "";
  }

  var isloading = false.obs;

  // updateventas({required String? id}) async {
  //   var store = firestore.collection("ventas").doc(id);
  //   if (clienteidtextController.text.toString().isEmpty) {
  //     var clir = firestore.collection("Cliente").doc();
  //     await clir.set(
  //       {
  //         "id": clir.id,
  //         "informacion_adicional": "",
  //         "telefono": "",
  //         "email": "",
  //         "nombre": clientenombretextController.text,
  //         "direccion": ""
  //       },
  //     );

  //     await store.set({
  //       "id": store.id,
  //       "cantidad": int.parse(cantidadtextController.text),
  //       "id_venta": "",
  //       "nombre": nombretextController.text,
  //       "fecha_entrega": DateTime.parse(fechatextController.text),
  //       "estado": estadotextController.text,
  //       "monto": int.parse(montotextController.text),
  //       "cliente": {
  //         "direccion": "",
  //         "email": "",
  //         "id": clir.id,
  //         "informacion_adicional": "",
  //         "nombre": clientenombretextController.text,
  //         "telefono": ""
  //       }
  //     }, SetOptions(merge: true)).timeout(Duration(seconds: 15));
  //   } else {
  //     var clir = await firestore
  //         .collection("Cliente")
  //         .doc(clienteidtextController.text)
  //         .get();

  //     await store.set({
  //       "id": store.id,
  //       "cantidad": int.parse(cantidadtextController.text),
  //       "id_venta": "",
  //       "nombre": nombretextController.text,
  //       "fecha_entrega": DateTime.parse(fechatextController.text),
  //       "estado": estadotextController.text,
  //       "monto": int.parse(montotextController.text),
  //       "cliente": {
  //         "direccion": clir['direccion'],
  //         "email": clir['email'],
  //         "id": clir['id'],
  //         "informacion_adicional": clir['informacion_adicional'],
  //         "nombre": clir['nombre'],
  //         "telefono": clir['telefono'],
  //       }
  //     }, SetOptions(merge: true)).timeout(Duration(seconds: 15));
  //   }
  // }

  Future<dynamic> getVentas() {
    return firestore.collection("Ventas").get();
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

  getproductos() async {
    productoslist.clear();
    productoslistcheck.clear();
    var data0 = await firestore
        .collection("Producto")
        .get()
        .timeout(Duration(seconds: 15));
    var list = data0.docs.toList();
    for (var item in list) {
      productoslist.add({
        "id": item['id'],
        "codigo": item['clave'],
        "nombre": item['nombre'],
        "precio_venta": item['precio_venta'],
        "cantidad": item['cantidad'],
        "imagenurl": item['imagenurl'],
        "cantidadProd": 0,
        "estado": false
      });
    }
  }

  registrarventas() async {
    var store = firestore.collection("Ventas").doc();
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

      int saldoDeuda = 0;
      if (tipoVentatextController.text == 'credito') {
        saldoDeuda = int.parse(totalVentatextController.text);
      }
      await store.set({
        "id": store.id,
        "codigo_venta": codigoVentatextController.text,
        "estado_venta": estadoVentatextController.text,
        "fecha_emision": fechaentrega,
        "forma_pagos": formaPagotextController.text,
        "tipo_venta": tipoVentatextController.text,
        "total_venta": int.parse(totalVentatextController.text),
        "saldo_deuda": saldoDeuda,
        "productos": productoslist.toList(),
        "botellas": botellaslist.toList(),
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
          "name": user['nombre']
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
        "codigo_venta": codigoVentatextController.text,
        "estado_venta": estadoVentatextController.text,
        "fecha_emision": fechaentrega,
        "forma_pagos": formaPagotextController.text,
        "tipo_venta": tipoVentatextController.text,
        "total_venta": int.parse(totalVentatextController.text),
        "saldo_deuda": int.parse(saldoDeudatextController.text),
        "productos": productoslist.toList(),
        "botellas": botellaslist.toList(),
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
          "name": user['name']
        }
      }).timeout(Duration(seconds: 15));
    }
  }

  removeventas(String id) async {
    isloading.value = true;
    await firestore
        .collection("ventas")
        .doc(id)
        .delete()
        .timeout(Duration(seconds: 15));
  }

  cambiarEstadoventas(String id) async {
    isloading.value = true;
    var store = firestore.collection("ventas").doc(id);

    await store.set({"estado": "devuelto"}, SetOptions(merge: true)).timeout(
        Duration(seconds: 15));
  }
}
