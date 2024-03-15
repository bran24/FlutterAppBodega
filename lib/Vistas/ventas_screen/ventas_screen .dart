import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Components/loading_widget.dart';
import 'package:flutter_login_taxi/Consts/conts.dart';
import 'package:flutter_login_taxi/Vistas/ventas_screen/add_VentasScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Components/app_bar_widget.dart';
import '../../Components/dialog_confirmation.dart';
import '../../Components/drawer_custom.dart';
import '../../Components/internet_exeption_wiedget2.dart';
import '../../Controllers/connection_status_controller.dart';
import '../../Controllers/ventas_controller.dart';

class ventasscreen extends StatefulWidget {
  const ventasscreen({super.key});
  @override
  State<ventasscreen> createState() => _ventasscreenState();
}

class _ventasscreenState extends State<ventasscreen> {
  var controller = Get.find<ventasController>();
  // var controller = Get.put(ventasController());
  var controllerconn = Get.put(ConnectionStatusController());
  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
        appBar: appbarWidget(title: "Ventas"),
        drawer: DrawerCuston(),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: () async {
              controller.isloading.value = true;
              await controller.getclientes();
              await controller.getproductos();
              controller.isloading.value = false;
              Get.to(() => addventasscreen());
            },
            child: const Icon(Icons.add)),
        body: RefreshIndicator(
            color: Colors.black,
            backgroundColor: Colors.orange,
            strokeWidth: 4.0,
            onRefresh: () async {
              setState(() {});
              // Replace this delay with the code to be executed during refresh
              // and return a Future when code finishes execution.
              await Future<void>.delayed(const Duration(seconds: 2));
            },
            child: FutureBuilder(
                future: controller.getVentas(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Column(children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    ]);
                  } else if (!snapshot.hasData) {
                    return loadingIndicador();
                  } else {
                    var data = snapshot.data!.docs;

                    return Obx(() => controller.isloading.value
                        ? loadingIndicador()
                        : Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(children: [
                              InternetExceptionWidget2(),
                              SizedBox(height: 10),
                              Expanded(
                                  child: ListView.builder(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            margin: EdgeInsets.only(bottom: 4),
                                            child: ListTile(
                                                onTap: () {
                                                  // Get.to(() => editarVentaScreen());
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                tileColor: grisColor,
                                                title: Text(
                                                  "Cod: " +
                                                      data[index]
                                                              ['codigo_venta']
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                subtitle: Column(children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons
                                                          .calendar_month_outlined),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(data[index][
                                                                    'fecha_emision']
                                                                .toDate())
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.payment),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        data[index]
                                                                ['estado_venta']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  )
                                                ]),
                                                trailing: Container(
                                                    width: 130,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "Tipo: " +
                                                                    data[index][
                                                                            'tipo_venta']
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                "Total: S/" +
                                                                    data[index][
                                                                            'total_venta']
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        PopupMenuButton(
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context) =>
                                                                  [
                                                            _buildPopupMenuItem(
                                                                'Editar',
                                                                Icons.edit),
                                                            _buildPopupMenuItem(
                                                                'Eliminar',
                                                                Icons.delete)
                                                          ],
                                                          onSelected:
                                                              (value) async {
                                                            if (value ==
                                                                "Editar") {
                                                              // Get.to(() =>
                                                              //     editarVentaScreen(
                                                              //       data: data[index],
                                                              //     ));
                                                            }

                                                            if (value ==
                                                                "Eliminar") {
                                                              // try {
                                                              //   await dialogConfirmation(
                                                              //     context: context,
                                                              //     titulo:
                                                              //         'Confirmacion',
                                                              //     content:
                                                              //         '¿Quiere Eliminar el Item?',
                                                              //     msg:
                                                              //         'Eliminacion Exitosa',
                                                              //     onPress: controller
                                                              //         .removebotellas,
                                                              //     datos: data[index]
                                                              //             ['id']
                                                              //         .toString(),
                                                              //   );
                                                              //   controller.isloading
                                                              //       .value = false;
                                                              // } catch (e, s) {
                                                              //   controller
                                                              //       .isloading(false);
                                                              //   Fluttertoast.showToast(
                                                              //     msg: e.toString(),
                                                              //     toastLength: Toast
                                                              //         .LENGTH_SHORT,
                                                              //     backgroundColor:
                                                              //         Colors.red,
                                                              //     textColor:
                                                              //         Colors.white,
                                                              //     fontSize: 16.0,
                                                              //     timeInSecForIosWeb: 1,
                                                              //     gravity: ToastGravity
                                                              //         .BOTTOM,
                                                              //   );
                                                              //   print(e);
                                                              //   print(s);
                                                              // }
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ))));
                                      }))
                            ])));
                  }
                })));
  }
}
