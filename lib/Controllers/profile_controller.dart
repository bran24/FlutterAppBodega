import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_taxi/Consts/conts.dart';
import 'package:flutter_login_taxi/Services/utils.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';

import 'auth_controller.dart';

class ProfileController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController oldpassController = TextEditingController();
  TextEditingController newpassController = TextEditingController();

  var profileImgPath = ''.obs;
  var profileImageLink = '';
  var isloading = false.obs;

  changeImage() async {
    final img = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    try {
      if (img == null) return;
      final imgcompress = await utils.compressImage(File(img.path));
      profileImgPath.value = imgcompress!.path;
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

  uploadProfileImage() async {
    var date = DateTime.now();
    var dat = date.year.toString() +
        date.month.toString() +
        date.day.toString() +
        date.hour.toString() +
        date.minute.toString() +
        date.second.toString() +
        date.microsecond.toString();

    var filename = basename(profileImgPath.value);
    var destination = 'images/${auth.currentUser!.uid}/${dat}_${filename}';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }

  updateProfile({name, password, imgurl}) async {
    var store = firestore.collection(userCollection).doc(auth.currentUser!.uid);
    await store.set({'name': name, 'password': password, 'imageUrl': imgurl},
        SetOptions(merge: true)).timeout(Duration(seconds: 15));
  }

  changeAuthPassword({email, password, newPassword}) async {
    final cred =
        await EmailAuthProvider.credential(email: email, password: password);

    await auth.currentUser!
        .reauthenticateWithCredential(cred)
        .then((value) => auth.currentUser!.updatePassword(newPassword))
        .catchError((onError) {
      print(onError.toString());

      Fluttertoast.showToast(
        msg: onError.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
        timeInSecForIosWeb: 1,
        gravity: ToastGravity.BOTTOM,
      );
    });
  }
}
