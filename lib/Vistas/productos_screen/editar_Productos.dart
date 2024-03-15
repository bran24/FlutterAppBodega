import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Controllers/product_controller.dart';
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
import '../../Components/app_bar_widget.dart';
import '../../Components/custom_dialog.dart';
import '../../Components/custom_dropbutton.dart';
import '../../Components/date_textfield.dart';
import '../../Components/our_button.dart';

class editarProductosscreen extends StatefulWidget {
  final dynamic data;
  const editarProductosscreen({super.key, this.data});
  @override
  State<editarProductosscreen> createState() =>
      _editarProductosscreenState(data);
}

class _editarProductosscreenState extends State<editarProductosscreen> {
  final dynamic data;
  var controller = Get.find<ProductController>();
  _editarProductosscreenState(this.data);

  @override
  void initState() {
    super.initState();
    controller.clavetextController.text = data['clave'];
    controller.cantidadtextController.text = data['cantidad'].toString();
    controller.descripciontextController.text = data['descripcion'];
    Timestamp t = data['fecha_vencimiento'] as Timestamp;
    DateTime date = t.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    controller.fechavencimienotextController.text = '${formattedDate}';
    controller.nombretextController.text = data['nombre'];
    controller.precioCompratextController.text =
        data['precio_compra'].toString();
    controller.precioVentatextController.text = data['precio_venta'].toString();
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
                Get.back();
              }),
          title: Text(
            "Actualizar Producto",
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
                          controller.profileImageLink = data['imagenurl'];
                          if (controller.productoImgPath.value.isNotEmpty) {
                            await controller.uploadProductoImage();
                          }

                          await controller.updateProducto(
                              id: data['id'].toString());

                          controller.isloading(false);
                          controller.limpiarCampos();
                          Fluttertoast.showToast(
                            msg: "Registro Exitoso",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.red,
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
                InternetExceptionWidget2(),
                SizedBox(
                  height: 10,
                ),
                data['imagenurl'] == '' && controller.productoImgPath.isEmpty
                    ? ClipOval(
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(48), // Image radius
                          child: Image.asset('assets/Imagenes/paquete.png',
                              width: 50, fit: BoxFit.cover),
                        ),
                      )
                    : data['imagenurl'] != '' &&
                            controller.productoImgPath.isEmpty
                        ? ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(48), // Image radius
                              child: Image.network(data['imagenurl'],
                                  width: 50, fit: BoxFit.cover),
                            ),
                          )
                        : ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(48), // Image radius
                              child: Image.file(
                                File(controller.productoImgPath.value),
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                SizedBox(
                  height: 5,
                ),
                ourButton(
                    color: Colors.orange,
                    onPress: () {
                      controller.changeImage();
                    },
                    textcolor: Colors.white,
                    title: "Seleccionar Imagen"),

                SizedBox(
                  height: 5,
                ),

                ourButton(
                    color: Colors.orange,
                    onPress: () {
                      controller.fotoImagen();
                    },
                    textcolor: Colors.white,
                    title: "Tomar Foto"),

                SizedBox(
                  height: 20,
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: customTextField(
                                    "Clave",
                                    controller.clavetextController,
                                    false,
                                    TextInputType.text,
                                    "password",
                                    false,
                                    true),
                              ),
                            ),
                            Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.only(left: 10),
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
                                        controller.clavetextController.text =
                                            res;
                                      }
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.barcode_reader,
                                    color: Colors.black,
                                  ),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        customTextField(
                            "Nombre",
                            controller.nombretextController,
                            false,
                            TextInputType.text,
                            "texto",
                            true,
                            true),
                        SizedBox(
                          height: 10,
                        ),
                        customTextField(
                            "Descripcion",
                            controller.descripciontextController,
                            false,
                            TextInputType.text,
                            "texto",
                            false,
                            true),
                        SizedBox(
                          height: 10,
                        ),
                        customTextField(
                            "Cantidad",
                            controller.cantidadtextController,
                            false,
                            TextInputType.number,
                            "texto",
                            true,
                            false),
                        SizedBox(
                          height: 10,
                        ),
                        customTextField(
                            "Precio de Compra",
                            controller.precioCompratextController,
                            false,
                            TextInputType.number,
                            "precio",
                            false,
                            false),
                        SizedBox(
                          height: 10,
                        ),
                        customTextField(
                            "Precio de venta",
                            controller.precioVentatextController,
                            false,
                            TextInputType.number,
                            "precio",
                            true,
                            false),
                        SizedBox(
                          height: 10,
                        ),
                        dateTextfield(controller.fechavencimienotextController,
                            context, "Fecha de Vencimiento"),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: customDropdownButton(
                                    "Categoria",
                                    controller.categorialist,
                                    controller.categoryvalue,
                                    controller),
                              ),
                            ),
                            Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.only(left: 10),
                                child: IconButton(
                                  onPressed: () async {
                                    await customDialog(
                                        context: context,
                                        controlador: controller
                                            .agregarCategoriatextController,
                                        labelfield: "Categoria",
                                        titulo: "Agregar Categoria",
                                        onPress: controller.agregarCategoria,
                                        actualizar: controller.getCategorias);
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
                        customDropdownButton("Unidad", controller.unidadlist,
                            controller.unidadvalue, controller),
                      ],
                    )),

                // customDropdownButton()
              ],
            )))));
  }
}
