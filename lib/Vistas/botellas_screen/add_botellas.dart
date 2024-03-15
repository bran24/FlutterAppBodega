import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Controllers/cliente_controller.dart';
import 'package:flutter_login_taxi/Controllers/product_controller.dart';
import 'package:flutter_login_taxi/Controllers/botellas_controller.dart';
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

class addbotellasscreen extends StatefulWidget {
  const addbotellasscreen({super.key});
  @override
  State<addbotellasscreen> createState() => _addbotellasscreenState();
}

class _addbotellasscreenState extends State<addbotellasscreen> {
  var controller = Get.find<botellasController>();
  var controllerClie = Get.put(clienteController());
  final _formkeyCli = GlobalKey<FormState>();
  String cliguard = "";
  bool enabletextfieldclie = true;

  @override
  void initState() {
    super.initState();
    controller.limpiarCampos();
  }

  _customDialogclient({required BuildContext context}) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Registrar Cliente"),
          content: SingleChildScrollView(
              child: Container(
            child: Form(
                key: _formkeyCli,
                child: Column(
                  children: [
                    customTextField(
                        "Nombre",
                        controllerClie.nombretextController,
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
                        controllerClie.telefonotextController,
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
                        controllerClie.emailtextController,
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
                        controllerClie.direccionextController,
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
                        controllerClie.info_addtextController,
                        false,
                        TextInputType.text,
                        "texto",
                        false,
                        false),
                  ],
                )),
          )),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Agregar'),
              onPressed: () async {
                try {
                  if (_formkeyCli.currentState!.validate()) {
                    controllerClie.isloading(true);

                    await controllerClie.registrarcliente();

                    controller.getclientes();
                    Fluttertoast.showToast(
                      msg: "Registro Exitoso",
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0,
                      timeInSecForIosWeb: 1,
                      gravity: ToastGravity.BOTTOM,
                    );
                    controllerClie.limpiarCampos();
                    Navigator.of(context).pop();
                  }
                } catch (e, s) {
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
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                controllerClie.limpiarCampos();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                controller.nombretextController.text = '';
                controller.cantidadtextController.text = '';
                controller.clienteidtextController.text = '';

                Get.back();
              }),
          title: Text(
            "Registrar botellas",
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
                      if (_formkey.currentState!.validate()) {
                        try {
                          controller.isloading(true);
                          await controller.registrarbotellas();

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
                      }
                    })
          ],
        ),
        body: Padding(
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
                child: Column(
              children: [
                InternetExceptionWidget2(),
                SizedBox(
                  height: 10,
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        customTextField(
                            "Nombre de Botella",
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
                            "Cantidad",
                            controller.cantidadtextController,
                            false,
                            TextInputType.number,
                            "text",
                            true,
                            false),
                        SizedBox(
                          height: 10,
                        ),
                        customTextField("Monto", controller.montotextController,
                            false, TextInputType.number, "text", true, false),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                                    child: Autocomplete<Map>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return List.empty();
                                } else {
                                  return controller.clienteslist.where(
                                      (element) => element['nombre']
                                          .toString()
                                          .toLowerCase()
                                          .contains(textEditingValue.text
                                              .toLowerCase()));
                                }
                              },
                              onSelected: (cli) {
                                controller.clienteidtextController.text =
                                    cli['id'];
                                setState(() {
                                  enabletextfieldclie = false;
                                  cliguard = cli['nombre'];
                                });
                              },
                              displayStringForOption: (cli) => cli['nombre'],
                              fieldViewBuilder: (context, textEditingController,
                                  focusNode, onFieldSubmitted) {
                                textEditingController.text = cliguard;
                                return TextField(
                                    enabled: enabletextfieldclie,
                                    onChanged: (value) {
                                      controller.clientenombretextController
                                          .text = value.toString();
                                    },
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    onEditingComplete: onFieldSubmitted,
                                    decoration: InputDecoration(
                                      labelText: "Cliente",
                                      // labelStyle: TextStyle(color: Colors.orange, fontSize: 20),
                                      filled: true,
                                      prefixIcon: Icon(Icons.person),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.orange)),
                                    ));
                              },
                            ))),
                            !enabletextfieldclie
                                ? IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        cliguard = "";
                                        enabletextfieldclie = true;
                                        controller
                                            .clienteidtextController.text = "";
                                      });
                                    },
                                  )
                                : SizedBox(width: 5),
                            Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.only(left: 10),
                                child: IconButton(
                                  onPressed: () async {
                                    await _customDialogclient(context: context);
                                  },
                                  icon: const Icon(
                                    Icons.add_rounded,
                                    color: Colors.black,
                                  ),
                                ))
                          ],
                        ),
                      ],
                    )),

                // customDropdownButton()
              ],
            )))));
  }
}
