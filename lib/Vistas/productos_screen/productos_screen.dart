import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Consts/conts.dart';
import 'package:flutter_login_taxi/Controllers/product_controller.dart';
import 'package:flutter_login_taxi/Vistas/productos_screen/add_Productos.dart';
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

import '../../Components/drawer_custom.dart';
import '../../Components/loading_widget.dart';
import '../../Services/check_internet_connection.dart';
import 'editar_Productos.dart';

class productosscreen extends StatefulWidget {
  const productosscreen({super.key});
  @override
  State<productosscreen> createState() => _productosscreenState();
}

class _productosscreenState extends State<productosscreen> {
  int countNombreFilter = 0;
  int countFechaFilter = 0;
  String idCategoria = "";
  var busq = "";

  var controller = Get.find<ProductController>();

  var listaCategorias;

  List<DocumentSnapshot> data = [];

  @override
  void initState() {
    super.initState();
    controller.busquetextController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    var controllerconn = Get.put(ConnectionStatusController());
    return Scaffold(
        appBar: appbarWidget(title: "Productos"),
        drawer: DrawerCuston(),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: () async {
              try {
                controller.isloading.value = true;
                await controller.getCategorias();
                await controller.getunidades();
                controller.isloading.value = false;
                Get.to(() => addProductosscreen());
              } catch (e, s) {
                controller.isloading(false);
                Fluttertoast.showToast(
                  msg: e.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                  timeInSecForIosWeb: 1,
                  gravity: ToastGravity.BOTTOM,
                );
                print(e);
                print(s);
              }
            },
            child: const Icon(Icons.add)),
        body: StreamBuilder(
            stream: FirestorServices.getProduct(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return loadingIndicador();
              } else {
                data = snapshot.data!.docs;
                return StreamBuilder(
                    stream: FirestorServices.getCategorias(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshotc) {
                      if (!snapshotc.hasData) {
                        return loadingIndicador();
                      } else {
                        if (busq.length > 0) {
                          data = data.where((element) {
                            var datanombre = element['nombre']
                                .toString()
                                .toLowerCase()
                                .contains(busq.toLowerCase());

                            var dataclave = element['clave']
                                .toString()
                                .toLowerCase()
                                .contains(busq.toLowerCase());

                            if (datanombre) {
                              return datanombre;
                            } else {
                              if (dataclave) {
                                return dataclave;
                              } else {
                                return false;
                              }
                            }
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

                        if (countFechaFilter == 1) {
                          data.sort((a, b) => a['fecha_vencimiento']
                              .compareTo(b['fecha_vencimiento']));
                        }

                        if (countFechaFilter == 2) {
                          data.sort((a, b) => b['fecha_vencimiento']
                              .compareTo(a['fecha_vencimiento']));
                        }

                        // Timestamp t = data['fecha_vencimiento'] as Timestamp;
                        // DateTime date = t.toDate();
                        // String formattedDate =
                        //     DateFormat('yyyy-MM-dd').format(date);

                        if (idCategoria != "") {
                          data = data.where((element) {
                            var cat_id = "/Categorias/" + idCategoria;
                            DocumentReference catref =
                                FirebaseFirestore.instance.doc(cat_id);

                            if (element['categoria'] == catref) {
                              return true;
                            } else {
                              return false;
                            }
                          }).toList();
                        }

                        var dataCategorias = snapshotc.data!.docs;
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
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                            child: Container(
                                          height: 40,
                                          child: TextField(
                                              controller: controller
                                                  .busquetextController,
                                              onChanged: (val) {
                                                setState(() {
                                                  busq = val;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'Buscar',

                                                // labelStyle: TextStyle(color: Colors.orange, fontSize: 20),
                                                filled: true,
                                                prefixIcon: Icon(Icons.search),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.orange)),
                                              )),
                                        )),
                                        Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: IconButton(
                                              onPressed: () async {
                                                var res = await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const SimpleBarcodeScannerPage(),
                                                    ));
                                                setState(() {
                                                  if (res is String) {
                                                    controller
                                                        .busquetextController
                                                        .text = res;
                                                    busq = res;
                                                  }
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.barcode_reader,
                                                color: Colors.black,
                                              ),
                                            )),
                                        Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            margin: EdgeInsets.only(left: 10),
                                            child: PopupMenuButton(
                                              icon: Icon(
                                                Icons.filter_alt_rounded,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context) => [
                                                PopupMenuItem(
                                                  value: 'Fecha de Vencimiento',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        countFechaFilter == 0
                                                            ? Icons.timelapse
                                                            : countFechaFilter ==
                                                                    1
                                                                ? Icons
                                                                    .arrow_downward
                                                                : Icons
                                                                    .arrow_upward,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      Text(
                                                        'Fecha de Vencimiento',
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'Nombre',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        countNombreFilter == 0
                                                            ? Icons
                                                                .paste_rounded
                                                            : countNombreFilter ==
                                                                    1
                                                                ? Icons
                                                                    .arrow_downward
                                                                : Icons
                                                                    .arrow_upward,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      const Text(
                                                        'Nombre',
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'Categoria',
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.category_outlined,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      const Text(
                                                        'Categoria',
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      idCategoria != ""
                                                          ? IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  idCategoria =
                                                                      "";
                                                                });
                                                              },
                                                              icon: Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            )
                                                          : SizedBox(
                                                              width: 1,
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              onSelected: (value) async {
                                                if (value ==
                                                    "Fecha de Vencimiento") {
                                                  setState(() {
                                                    countFechaFilter++;
                                                  });
                                                  if (countFechaFilter > 2) {
                                                    setState(() {
                                                      countFechaFilter = 0;
                                                    });
                                                  }
                                                }

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

                                                if (value == "Categoria") {
                                                  await _listDialog(
                                                      data: dataCategorias);
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
                                                try {
                                                  controller.isloading(true);
                                                  await controller
                                                      .getCategorias();
                                                  await controller
                                                      .getunidades();
                                                  var respu = await data[index]
                                                          ['unidad']
                                                      .get();

                                                  var datu = respu
                                                      .data()['nombre']
                                                      .toString();

                                                  var respc = await data[index]
                                                          ['categoria']
                                                      .get();
                                                  var datc = respc
                                                      .data()['nombre']
                                                      .toString();

                                                  controller.unidadvalue.value =
                                                      datu;
                                                  controller.categoryvalue
                                                      .value = datc;
                                                  controller.isloading(false);
                                                  Get.to(() =>
                                                      editarProductosscreen(
                                                        data: data[index],
                                                      ));
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
                                              },
                                              title: Text(
                                                data[index]['nombre'],
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Column(children: [
                                                Row(
                                                  children: [
                                                    const Text(
                                                      "Codigo: ",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      data[index]['clave']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "S/${data[index]['precio_venta'].toString()}",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Cantidad: ${data[index]['cantidad'].toString()}",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                              leading: data[index]
                                                          ['imagenurl'] ==
                                                      ""
                                                  ? Image.asset(
                                                      "assets/Imagenes/paquete.png",
                                                      width: 80,
                                                      height: 80,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : CachedNetworkImage(
                                                      imageUrl: data[index]
                                                          ['imagenurl'],
                                                      placeholder: (context,
                                                              url) =>
                                                          CircularProgressIndicator(),
                                                      imageBuilder:
                                                          (context, image) =>
                                                              Container(
                                                        width: 80,
                                                        height: 80,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: image,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
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
                                                    try {
                                                      controller
                                                          .isloading(true);
                                                      await controller
                                                          .getCategorias();
                                                      await controller
                                                          .getunidades();
                                                      var respu =
                                                          await data[index]
                                                                  ['unidad']
                                                              .get();

                                                      var datu = respu
                                                          .data()['nombre']
                                                          .toString();

                                                      var respc =
                                                          await data[index]
                                                                  ['categoria']
                                                              .get();
                                                      var datc = respc
                                                          .data()['nombre']
                                                          .toString();

                                                      controller.unidadvalue
                                                          .value = datu;
                                                      controller.categoryvalue
                                                          .value = datc;
                                                      controller
                                                          .isloading(false);
                                                      Get.to(() =>
                                                          editarProductosscreen(
                                                            data: data[index],
                                                          ));
                                                    } catch (e, s) {
                                                      controller
                                                          .isloading(false);
                                                      Fluttertoast.showToast(
                                                        msg: e.toString(),
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        backgroundColor:
                                                            Colors.red,
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

                                                  if (value == "Eliminar") {
                                                    try {
                                                      await dialogConfirmation(
                                                        context: context,
                                                        titulo: 'Confirmacion',
                                                        content:
                                                            '¿Quiere Eliminar el Item?',
                                                        msg:
                                                            'Eliminacion Exitosa',
                                                        onPress: controller
                                                            .removeProduct,
                                                        datos: data[index]['id']
                                                            .toString(),
                                                      );
                                                      controller.isloading
                                                          .value = false;
                                                    } catch (e, s) {
                                                      Fluttertoast.showToast(
                                                        msg: e.toString(),
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        backgroundColor:
                                                            Colors.red,
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
                                      },
                                    ))
                                  ],
                                ),
                              ));
                      }
                    });
              }
            }));
  }

  Future<void> _listDialog({data}) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: const Text('Seleccionar Categoria'),
              children: List.generate(
                data.length,
                (index) => SimpleDialogOption(
                  onPressed: () {
                    setState(() {
                      idCategoria = data[index]['id'];
                    });

                    Navigator.of(context).pop();
                  },
                  child: Text(data[index]['nombre']),
                ),
              ));
        });
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
