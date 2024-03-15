import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Vistas/clientes_screen/clientes_screen.dart';
import 'package:flutter_login_taxi/Vistas/home_screen/home_screen.dart';
import 'package:flutter_login_taxi/Vistas/messages_screen/messages_screen.dart';
import 'package:flutter_login_taxi/Vistas/profile_screen/profile_screen.dart';
import 'package:flutter_login_taxi/Vistas/proveedores_screen/proveedor_screen.dart';
import 'package:flutter_login_taxi/Components/loading_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../Consts/firebase_const.dart';
import '../Controllers/auth_controller.dart';
import '../Controllers/drawer_controller.dart';
import '../Services/Firebase_service.dart';
import '../Vistas/Login.dart';

import '../Vistas/botellas_screen/botellas_screen.dart';

import '../Vistas/productos_screen/productos_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DrawerCuston extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(authController());
    var controllerD = Get.put(drawerController(), permanent: true);

    return StreamBuilder(
        stream: FirestorServices.getUser(auth.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Drawer();
          } else {
            var data = snapshot.data!.docs[0];
            return Drawer(
              child: ListView(padding: EdgeInsets.zero, children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          stops: [0.1, 0.9],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 255, 226, 129),
                            Colors.orange,
                          ])),
                  accountName: Text(
                    data['name'],
                    style: TextStyle(color: Colors.black),
                  ),
                  accountEmail: Text(
                    data['email'],
                    style: TextStyle(color: Colors.black),
                  ),
                  currentAccountPicture: data['imageUrl'] == ''
                      ? CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: data['imageUrl'],
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageBuilder: (context, image) => CircleAvatar(
                            backgroundImage: image,
                            radius: 30,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                ),
                ListTile(
                    title: Text("Inicio"),
                    leading: Icon(Icons.home),
                    selected: (0 == controllerD.currentNavIndex.value),
                    selectedColor: Colors.orange,
                    onTap: () {
                      controllerD.currentNavIndex.value = 0;
                      Get.back();
                      Get.offNamed('/Home');
                    }),
                ListTile(
                    title: Text("Productos"),
                    selected: (1 == controllerD.currentNavIndex.value),
                    selectedColor: Colors.orange,
                    leading: Icon(Icons.card_travel),
                    onTap: () {
                      controllerD.currentNavIndex.value = 1;
                      Get.back();
                      Get.offNamed('/Producto');
                    }),
                ListTile(
                    title: Text("Clientes"),
                    selected: (2 == controllerD.currentNavIndex.value),
                    selectedColor: Colors.orange,
                    leading: Icon(Icons.person),
                    onTap: () {
                      controllerD.currentNavIndex.value = 2;
                      Get.back();
                      Get.offNamed('/Clientes');
                    }),
                ListTile(
                    title: Text("Ventas"),
                    selected: (3 == controllerD.currentNavIndex.value),
                    selectedColor: Colors.orange,
                    leading: Icon(Icons.paid),
                    onTap: () {
                      controllerD.currentNavIndex.value = 3;
                      Get.back();
                      Get.offNamed('/Ventas');
                    }),
                ListTile(
                    title: Text("Proveedores"),
                    selected: (4 == controllerD.currentNavIndex.value),
                    selectedColor: Colors.orange,
                    leading: Icon(Icons.person_pin_rounded),
                    onTap: () {
                      controllerD.currentNavIndex.value = 4;
                      Get.back();
                      Get.offNamed('/Proveedor');
                    }),
                ListTile(
                    title: Text("Botellas"),
                    selected: (5 == controllerD.currentNavIndex.value),
                    selectedColor: Colors.orange,
                    leading: Icon(Icons.battery_0_bar),
                    onTap: () {
                      controllerD.currentNavIndex.value = 5;
                      Get.back();
                      Get.offNamed('/Botella');
                    }),
                ListTile(
                    title: Text("Mensajes"),
                    selected: (6 == controllerD.currentNavIndex.value),
                    selectedColor: Colors.orange,
                    leading: Icon(Icons.message),
                    onTap: () {
                      controllerD.currentNavIndex.value = 6;
                      Get.back();
                      Get.to(() => messagesscreen());
                    }),
                ListTile(
                    title: Text("Configuracion"),
                    selected: (7 == controllerD.currentNavIndex.value),
                    selectedColor: Colors.orange,
                    leading: Icon(Icons.person),
                    onTap: () {
                      controllerD.currentNavIndex.value = 7;
                      Get.back();
                      Get.offNamed('/Profile');
                    }),
                ListTile(
                    title: Text("Cerrar Sesion"),
                    leading: Icon(Icons.exit_to_app),
                    onTap: () async {
                      controllerD.currentNavIndex.value = 0;
                      await controller.signoutMethod();
                      Get.back();
                      Get.offAll(() => Login());
                    })
              ]),
            );
          }
        });
  }
}
