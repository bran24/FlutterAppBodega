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

class clienteController extends GetxController {
  TextEditingController direccionextController = TextEditingController();
  TextEditingController nombretextController = TextEditingController();
  TextEditingController telefonotextController = TextEditingController();
  TextEditingController emailtextController = TextEditingController();
  TextEditingController info_addtextController = TextEditingController();

  limpiarCampos() {
    nombretextController.text = "";
    telefonotextController.text = "";
    emailtextController.text = "";
    info_addtextController.text = "";
    direccionextController.text = "";
  }

  var isloading = false.obs;

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

  updatecliente({required String? id}) async {
    isloading.value = false;
    var store = firestore.collection("Cliente").doc(id);

    await store.set({
      "id": store.id,
      "informacion_adicional": info_addtextController.text,
      "telefono": telefonotextController.text,
      "email": emailtextController.text,
      "nombre": nombretextController.text,
      "direccion": direccionextController.text,
    }).timeout(Duration(seconds: 15));
    ;
  }

  registrarcliente() async {
    var store = firestore.collection("Cliente").doc();

    await store.set({
      "id": store.id,
      "informacion_adicional": info_addtextController.text,
      "telefono": telefonotextController.text,
      "email": emailtextController.text,
      "nombre": nombretextController.text,
      "direccion": direccionextController.text,
    }).timeout(Duration(seconds: 15));
  }

  removecliente(String id) async {
    isloading.value = true;
    await firestore
        .collection("Cliente")
        .doc(id)
        .delete()
        .timeout(Duration(seconds: 15));
    ;
  }
}
