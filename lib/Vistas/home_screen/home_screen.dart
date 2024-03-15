import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Components/drawer_custom.dart';
import 'package:flutter_login_taxi/data/app_exceptions.dart';
import 'package:get/get.dart';
import 'package:card_swiper/card_swiper.dart';

import '../../Components/featured_button.dart';
import '../../Components/internet_exeption_wiedget.dart';
import '../../Components/internet_exeption_wiedget2.dart';
import '../../Consts/lists.dart';

import '../../Controllers/connection_status_controller.dart';
import '../../Services/Firebase_service.dart';
import '../../Components/home_buttons.dart';
import '../../Components/app_bar_widget.dart';
import '../../Components/loading_widget.dart';
import '../../Services/check_internet_connection.dart';

class homescreen extends StatefulWidget {
  const homescreen({super.key});
  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  var controllerconn = Get.put(ConnectionStatusController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appbarWidget(title: "Inicio"),
        drawer: DrawerCuston(),
        body: StreamBuilder(
            stream: FirestorServices.getProveedor(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshotprov) {
              if (!snapshotprov.hasData) {
                return loadingIndicador();
              } else {
                var dataprov = snapshotprov.data!.docs.length;
                return StreamBuilder(
                    stream: FirestorServices.getCliente(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshotcli) {
                      if (!snapshotcli.hasData) {
                        return loadingIndicador();
                      } else {
                        var datacli = snapshotcli.data!.docs.length;
                        return StreamBuilder(
                            stream: FirestorServices.getBotellasPendientes(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshotbot) {
                              if (!snapshotbot.hasData) {
                                return loadingIndicador();
                              } else {
                                var databot = snapshotbot.data!.docs.length;
                                return StreamBuilder(
                                    stream: FirestorServices.getProduct(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot>
                                            snapshotprod) {
                                      if (!snapshotprod.hasData) {
                                        return loadingIndicador();
                                      } else {
                                        var dataprod =
                                            snapshotprod.data!.docs.length;
                                        return SafeArea(
                                            child: SingleChildScrollView(
                                          physics: BouncingScrollPhysics(),
                                          child: Column(
                                            children: [
                                              InternetExceptionWidget2(),
                                              SizedBox(height: 10),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    homeButtons(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                        title: "Productos",
                                                        icon: Icons.category,
                                                        count: dataprod
                                                            .toString()),
                                                    homeButtons(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                        title: "Ventas Totales",
                                                        icon: Icons
                                                            .point_of_sale_sharp,
                                                        count: "0")
                                                  ]),
                                              SizedBox(height: 10),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    homeButtons(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                        title: "Proveedores",
                                                        icon: Icons.category,
                                                        count: dataprov
                                                            .toString()),
                                                    homeButtons(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                        title: "Clientes",
                                                        icon: Icons.person,
                                                        count:
                                                            datacli.toString())
                                                  ]),
                                              SizedBox(height: 10),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    homeButtons(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                        title:
                                                            "Ventas a Cobrar",
                                                        icon: Icons
                                                            .content_paste_rounded,
                                                        count: "0"),
                                                    homeButtons(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                        title:
                                                            "Envases a Cobrar",
                                                        icon:
                                                            Icons.battery_0_bar,
                                                        count:
                                                            databot.toString())
                                                  ]),
                                              SizedBox(height: 10),
                                              homeButtons(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.5,
                                                  title: "Deudas",
                                                  icon: Icons
                                                      .monetization_on_outlined,
                                                  count: "0"),
                                            ],
                                          ),
                                        ));
                                      }
                                    });
                              }
                            });
                      }
                    });
              }
            }));
  }
}
