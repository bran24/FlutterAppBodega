import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Consts/conts.dart';
import 'package:flutter_login_taxi/Controllers/product_controller.dart';
import 'package:flutter_login_taxi/Controllers/proveedor_controller.dart';
import 'package:flutter_login_taxi/Vistas/productos_screen/add_Productos.dart';
import 'package:flutter_login_taxi/Vistas/profile_screen/profile_screen.dart';
import 'package:flutter_login_taxi/Vistas/proveedores_screen/add_proveedor.dart';
import 'package:flutter_login_taxi/Vistas/ventas_screen/ventas_screen%20.dart';
import 'package:flutter_login_taxi/Components/dialog_confirmation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../Components/internet_exeption_wiedget.dart';
import '../../Components/internet_exeption_wiedget2.dart';
import '../../Consts/lists.dart';
import '../../Controllers/connection_status_controller.dart';
import '../../Services/Firebase_service.dart';
import '../../Components/app_bar_widget.dart';
import '../../Components/custom_textfield.dart';
import '../../Components/drawer_custom.dart';
import '../../Components/loading_widget.dart';
import '../../Services/check_internet_connection.dart';
import 'editar_proveedor.dart';

class proveedorscreen extends StatefulWidget {
  const proveedorscreen({super.key});
  @override
  State<proveedorscreen> createState() => _proveedorscreenState();
}

class _proveedorscreenState extends State<proveedorscreen> {
  int countNombreFilter = 0;
  String clave = "";

  var listaCategorias;
  List<DocumentSnapshot> data = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProveedorController>();
    var controllerconn = Get.put(ConnectionStatusController());
    return Scaffold(
      appBar: appbarWidget(title: "Proveedores"),
      drawer: DrawerCuston(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () async {
            Get.to(() => addproveedorsscreen());
          },
          child: const Icon(Icons.add)),
      body: StreamBuilder(
          stream: FirestorServices.getProveedor(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return loadingIndicador();
            } else {
              data = snapshot.data!.docs;

              if (clave.length > 0) {
                data = data.where((element) {
                  return element['nombre']
                      .toString()
                      .toLowerCase()
                      .contains(clave.toLowerCase());
                }).toList();
              }

              if (countNombreFilter == 1) {
                data.sort((a, b) => a['nombre']
                    .toString()
                    .toLowerCase()
                    .compareTo(b['nombre'].toString().toLowerCase()));
              }

              if (countNombreFilter == 2) {
                data.sort((a, b) => b['nombre']
                    .toString()
                    .toLowerCase()
                    .compareTo(a['nombre'].toString().toLowerCase()));
              }

              // Timestamp t = data['fecha_vencimiento'] as Timestamp;
              // DateTime date = t.toDate();
              // String formattedDate =
              //     DateFormat('yyyy-MM-dd').format(date);

              return Obx(() => controller.isloading.value
                  ? loadingIndicador()
                  : Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          InternetExceptionWidget2(),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                height: 40,
                                child: TextField(
                                    onChanged: (val) {
                                      setState(() {
                                        clave = val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Buscar',
                                      // labelStyle: TextStyle(color: Colors.orange, fontSize: 20),
                                      filled: true,
                                      prefixIcon: Icon(Icons.search),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.orange)),
                                    )),
                              )),
                              Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: EdgeInsets.only(left: 10),
                                  child: PopupMenuButton(
                                    icon: Icon(
                                      Icons.filter_alt_rounded,
                                    ),
                                    itemBuilder: (BuildContext context) => [
                                      PopupMenuItem(
                                        value: 'Nombre',
                                        child: Row(
                                          children: [
                                            Icon(
                                              countNombreFilter == 0
                                                  ? Icons.paste_rounded
                                                  : countNombreFilter == 1
                                                      ? Icons.arrow_downward
                                                      : Icons.arrow_upward,
                                              color: Colors.black,
                                              size: 18,
                                            ),
                                            Text(
                                              'Nombre',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) async {
                                      if (value == "Nombre") {
                                        setState(() {
                                          countNombreFilter++;
                                        });
                                        if (countNombreFilter > 2) {
                                          setState(() {
                                            countNombreFilter = 0;
                                          });
                                        }
                                      }
                                    },
                                  ))
                            ],
                          ),
                          SizedBox(height: 20),
                          Expanded(
                              child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: ListTile(
                                          onTap: () async {
                                            Get.to(() => editarproveedorscreen(
                                                  data: data[index],
                                                ));
                                          },
                                          title: Text(
                                            data[index]['nombre'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Column(children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Telefono: ",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  data[index]['telefono']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ]),
                                          leading: Icon(
                                            Icons.person_2_rounded,
                                            color: Colors.orange,
                                            size: 30,
                                          ),
                                          trailing: PopupMenuButton(
                                            itemBuilder:
                                                (BuildContext context) => [
                                              _buildPopupMenuItem(
                                                  'Editar', Icons.edit),
                                              _buildPopupMenuItem(
                                                  'Eliminar', Icons.delete)
                                            ],
                                            onSelected: (value) async {
                                              if (value == "Editar") {
                                                Get.to(
                                                    () => editarproveedorscreen(
                                                          data: data[index],
                                                        ));
                                              }

                                              if (value == "Eliminar") {
                                                try {
                                                  await dialogConfirmation(
                                                    context: context,
                                                    titulo: 'Confirmacion',
                                                    content:
                                                        '¿Quiere Eliminar el Item?',
                                                    msg: 'Eliminacion Exitosa',
                                                    onPress: controller
                                                        .removeProveedor,
                                                    datos: data[index]['id']
                                                        .toString(),
                                                  );
                                                  controller.isloading.value =
                                                      false;
                                                } catch (e, s) {
                                                  controller.isloading(false);
                                                  Fluttertoast.showToast(
                                                    msg: e.toString(),
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                    timeInSecForIosWeb: 1,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                  );
                                                  print(e);
                                                  print(s);
                                                }
                                              }
                                            },
                                          ),
                                        ));
                                  }))
                        ],
                      ),
                    ));
            }
          }),
    );
  }

  PopupMenuItem _buildPopupMenuItem(String title, IconData iconData) {
    return PopupMenuItem(
      value: title,
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.black,
            size: 18,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItemNoIcon(String title) {
    return PopupMenuItem(
      value: title,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
