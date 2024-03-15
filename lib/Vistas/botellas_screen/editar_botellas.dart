import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Controllers/product_controller.dart';
import 'package:flutter_login_taxi/Controllers/botellas_controller.dart';
import 'package:flutter_login_taxi/Vistas/profile_screen/profile_screen.dart';
import 'package:flutter_login_taxi/Vistas/ventas_screen/ventas_screen%20.dart';
import 'package:flutter_login_taxi/Components/custom_textfield.dart';
import 'package:flutter_login_taxi/Components/loading_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:intl/intl.dart';
import '../../Components/internet_exeption_wiedget2.dart';
import '../../Consts/lists.dart';
import '../../Controllers/cliente_controller.dart';
import '../../Components/app_bar_widget.dart';
import '../../Components/custom_dialog.dart';
import '../../Components/custom_dropbutton.dart';
import '../../Components/date_textfield.dart';
import '../../Components/our_button.dart';

class editarbotellasscreen extends StatefulWidget {
  final dynamic data;
  const editarbotellasscreen({super.key, this.data});
  @override
  State<editarbotellasscreen> createState() => _editarbotellasscreenState(data);
}

class _editarbotellasscreenState extends State<editarbotellasscreen> {
  final dynamic data;
  _editarbotellasscreenState(this.data);
  final _formkey = GlobalKey<FormState>();
  var controller = Get.find<botellasController>();
  var controllerClie = Get.put(clienteController());
  final _formkeyCli = GlobalKey<FormState>();
  bool enabletextfieldclie = true;

  @override
  void initState() {
    super.initState();
    controller.nombretextController.text = data['nombre'];
    controller.cantidadtextController.text = data['cantidad'].toString();
    Timestamp t = data['fecha_entrega'] as Timestamp;
    DateTime date = t.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    controller.fechatextController.text = formattedDate;
    controller.clienteidtextController.text = data['cliente']['id'];
    controller.estadotextController.text =
        data['estado'].toString().toLowerCase();
    controller.montotextController.text = data['monto'].toString();
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
                        "Nombre de Botella",
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
    String cliguard = data['cliente']['nombre'];
    int contid = 0;
    const List<String> list = <String>['pendiente', 'devuelto'];

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
            "Actualizar botellas",
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
                        controller.isloading(true);

                        await controller.updatebotellas(
                            id: data['id'].toString());
                        controller.isloading(false);
                        Fluttertoast.showToast(
                          msg: "Actualizacion Exitosa",
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                          timeInSecForIosWeb: 1,
                          gravity: ToastGravity.BOTTOM,
                        );
                        controller.limpiarCampos();
                        Get.back();
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
                            "Cantidad",
                            controller.cantidadtextController,
                            false,
                            TextInputType.number,
                            "text",
                            false,
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
                                      if (contid < 1) {
                                        controller
                                            .clienteidtextController.text = "";
                                      }
                                      contid++;

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
                        SizedBox(
                          height: 10,
                        ),
                        dateTextfield(controller.fechatextController, context,
                            "Fecha de entrega"),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // color: Color.fromARGB(255, 165, 165, 165),
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField(
                              value: controller.estadotextController.text == ''
                                  ? null
                                  : controller.estadotextController.text,
                              validator: (value) {
                                if (controller
                                    .estadotextController.text.isEmpty) {
                                  return "Seleccionar";
                                }
                              },
                              hint: Text(
                                "Estado",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                              isExpanded: true,
                              onChanged: (newvalue) {
                                controller.estadotextController.text =
                                    newvalue.toString();
                              },
                              items: list.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.toString()),
                                );
                              }).toList(),
                            )))
                      ],
                    )),

                // customDropdownButton()
              ],
            )))));
  }
}
