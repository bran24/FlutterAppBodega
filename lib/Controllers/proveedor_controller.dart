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

class ProveedorController extends GetxController {
  TextEditingController nombretextController = TextEditingController();
  TextEditingController telefonotextController = TextEditingController();
  TextEditingController emailtextController = TextEditingController();
  TextEditingController cometariotextController = TextEditingController();

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

  limpiarCampos() {
    nombretextController.text = "";
    telefonotextController.text = "";
    emailtextController.text = "";
    cometariotextController.text = "";
  }

  updateProveedor({required String? id}) async {
    isloading.value = false;
    var store = firestore.collection("Proveedor").doc(id);

    await store.set({
      "id": store.id,
      "comentario": cometariotextController.text,
      "telefono": int.parse(telefonotextController.text),
      "email": emailtextController.text,
      "nombre": nombretextController.text,
    }).timeout(Duration(seconds: 15));
  }

  registrarProveedor() async {
    var store = firestore.collection("Proveedor").doc();

    await store.set({
      "id": store.id,
      "comentario": cometariotextController.text,
      "telefono": int.parse(telefonotextController.text),
      "email": emailtextController.text,
      "nombre": nombretextController.text,
    }).timeout(Duration(seconds: 15));
  }

  removeProveedor(String id) async {
    isloading.value = true;
    await firestore.collection("Proveedor").doc(id).delete();
  }
}
