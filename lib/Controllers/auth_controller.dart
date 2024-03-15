import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter_login_taxi/Consts/conts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class authController extends GetxController {
//login method
  var recuerdame = false.obs;

  Future<UserCredential?> loginMethod({email, password}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Obtain shared preferences.
      final SharedPreferences prefs = await SharedPreferences.getInstance();

// Save an list of strings to 'items' key.
      if (recuerdame.value) {
        await prefs.setBool('remember', true);
        await prefs.setStringList(
            'Credenciales', <String>[email.toString(), password.toString()]);
      } else {
        await prefs.setBool('remember', false);
        if (prefs.getStringList('Credenciales') != null) {
// Remove data for the 'counter' key.
          await prefs.remove('Credenciales');
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
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

  Future<UserCredential?> signup({email, password}) async {
    UserCredential? userCredential;

    userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    return userCredential;
  }

//storig data method
  storeUserData({name, password, email}) async {
    var id = await auth.currentUser!.uid;
    DocumentReference store =
        await firestore.collection(userCollection).doc(id);
    await store.set({
      'name': name,
      'password': password,
      'email': email,
      'imageUrl': '',
      'id': id,
      'cart_count': "00",
      'wishlist_count': "00",
      'order_count': "00",
    }).timeout(Duration(seconds: 15));
  }

  signoutMethod() async {
    try {
      await auth.signOut();
      Get.delete(force: true);
      // User? currentUser = await auth.currentUser;

      // print(currentUser!.uid);
    } catch (e) {
      print(e.toString());
    }
  }
}
