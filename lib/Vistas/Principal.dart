import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Consts/conts.dart';
import 'package:flutter_login_taxi/Vistas/productos_screen/productos_screen.dart';
import 'package:flutter_login_taxi/Vistas/profile_screen/profile_screen.dart';
import 'package:flutter_login_taxi/Vistas/proveedores_screen/proveedor_screen.dart';
import 'package:flutter_login_taxi/Components/drawer_custom.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../Controllers/auth_controller.dart';
import '../Services/Firebase_service.dart';
import '../Components/app_bar_widget.dart';
import '../Components/loading_widget.dart';
import 'Login.dart';
import 'botellas_screen/botellas_screen.dart';
import 'clientes_screen/clientes_screen.dart';
import 'home_screen/home_screen.dart';
import 'messages_screen/messages_screen.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  var controller = Get.find<authController>();
  int _selectDrawerItem = 0;
  String _selectDrawerItemName = "Dashboard";
  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return homescreen();
      case 1:
        return productosscreen();
      case 2:
        return clientescreen();
      case 3:
        return proveedorscreen();
      case 4:
        return botellasscreen();
      case 5:
        return messagesscreen();
      case 6:
        return profilescreen();
    }
  }

  _onSelectItem(int pos, String name) {
    Navigator.of(context).pop();
    setState(() {
      _selectDrawerItemName = name;
      _selectDrawerItem = pos;
    });
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirestorServices.getUser(auth.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicador();
          } else {
            var data = snapshot.data!.docs[0];
            return Scaffold(
                appBar: appbarWidget(title: _selectDrawerItemName),
                drawer: Drawer(
                  child: ListView(padding: EdgeInsets.zero, children: [
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(color: Colors.orange),
                      accountName: Text(data['name']),
                      accountEmail: Text(data['email']),
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
                        selected: (0 == _selectDrawerItem),
                        onTap: () {
                          _onSelectItem(0, 'inicio');
                          Get.back();
                        }),
                    ListTile(
                        title: Text("Productos"),
                        leading: Icon(Icons.card_travel),
                        selected: (1 == _selectDrawerItem),
                        onTap: () {
                          _onSelectItem(1, 'Productos');
                        }),
                    ListTile(
                        title: Text("Clientes"),
                        selected: (2 == _selectDrawerItem),
                        leading: Icon(Icons.person),
                        onTap: () {
                          _onSelectItem(2, 'Clientes');
                        }),
                    ListTile(
                        title: Text("Proveedores"),
                        selected: (3 == _selectDrawerItem),
                        leading: Icon(Icons.person_pin_rounded),
                        onTap: () {
                          _onSelectItem(3, 'Proveedores');
                        }),
                    ListTile(
                        title: Text("Botellas"),
                        selected: (4 == _selectDrawerItem),
                        leading: Icon(Icons.battery_0_bar),
                        onTap: () {
                          _onSelectItem(4, 'Botellas');
                        }),
                    ListTile(
                        title: Text("Mensajes"),
                        leading: Icon(Icons.message),
                        selected: (5 == _selectDrawerItem),
                        onTap: () {
                          _onSelectItem(5, 'Mensajes');
                        }),
                    ListTile(
                        title: Text("Configuracion"),
                        leading: Icon(Icons.person),
                        selected: (6 == _selectDrawerItem),
                        onTap: () {
                          _onSelectItem(6, 'Configuracion');
                        }),
                    ListTile(
                        title: Text("Cerrar Sesion"),
                        leading: Icon(Icons.exit_to_app),
                        onTap: () async {
                          await controller.signoutMethod();
                          Get.offAll(() => const Login());
                        })
                  ]),
                ),
                body: _getDrawerItemWidget(_selectDrawerItem));
          }
        });
  }
}
