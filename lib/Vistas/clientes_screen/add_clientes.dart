import 'dart:async';
import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Controllers/product_controller.dart';
import 'package:flutter_login_taxi/Controllers/cliente_controller.dart';
import 'package:flutter_login_taxi/Vistas/profile_screen/profile_screen.dart';
import 'package:flutter_login_taxi/Vistas/ventas_screen/ventas_screen%20.dart';
import 'package:flutter_login_taxi/Components/custom_dialog.dart';
import 'package:flutter_login_taxi/Components/custom_textfield.dart';
import 'package:flutter_login_taxi/Components/loading_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../Components/internet_exeption_wiedget2.dart';
import '../../Consts/lists.dart';
import '../../Components/app_bar_widget.dart';
import '../../Components/custom_dropbutton.dart';
import '../../Components/date_textfield.dart';
import '../../Components/our_button.dart';
import '../../Controllers/connection_status_controller.dart';
import '../../Services/check_internet_connection.dart';
import '../../data/app_exceptions.dart';

class addclientescreen extends StatefulWidget {
  const addclientescreen({super.key});
  @override
  State<addclientescreen> createState() => _addclientescreenState();
}

class _addclientescreenState extends State<addclientescreen> {
  var controller = Get.find<clienteController>();
  var controllerconn = Get.find<ConnectionStatusController>();
  void initState() {
    super.initState();
    controller.limpiarCampos();
  }

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    @override
    void dispose() {
      super.dispose();
    }

    return Obx(() => Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                controller.limpiarCampos();
                Get.back();
              }),
          title: Text(
            "Registrar cliente",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            controller.isloading.value
                ? loadingIndicador()
                : IconButton(
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      try {
                        if (_formkey.currentState!.validate()) {
                          controller.isloading(true);

                          await controller.registrarcliente();

                          controller.isloading(false);
                          Fluttertoast.showToast(
                            msg: "Registro Exitoso",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0,
                            timeInSecForIosWeb: 1,
                            gravity: ToastGravity.BOTTOM,
                          );

                          Get.back();
                        }
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
                    })
          ],
        ),
        body: Padding(
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                InternetExceptionWidget2(),
                SizedBox(
                  height: 10,
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        customTextField(
                            "Nombre",
                            controller.nombretextController,
                            false,
                            TextInputType.text,
                            "text",
                            true,
                            false),
                        SizedBox(
                          height: 10,
                        ),
                        customTextField(
                            "Telefono",
                            controller.telefonotextController,
                            false,
                            TextInputType.phone,
                            "telefono",
                            false,
                            false),
                        SizedBox(
                          height: 10,
                        ),
                        customTextField(
                            "Email",
                            controller.emailtextController,
                            false,
                            TextInputType.emailAddress,
                            "texto",
                            false,
                            false),
                        SizedBox(
                          height: 10,
                        ),
                        customTextField(
                            "Direccion",
                            controller.direccionextController,
                            false,
                            TextInputType.text,
                            "texto",
                            false,
                            false),
                        SizedBox(
                          height: 10,
                        ),
                        customTextField(
                            "Informacion Adicional",
                            controller.info_addtextController,
                            false,
                            TextInputType.text,
                            "texto",
                            false,
                            false),
                      ],
                    )),

                // customDropdownButton()
              ],
            )))));
  }
}
