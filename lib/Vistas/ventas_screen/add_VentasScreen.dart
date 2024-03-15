import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Controllers/cliente_controller.dart';
import 'package:flutter_login_taxi/Controllers/product_controller.dart';
import 'package:flutter_login_taxi/Controllers/ventas_controller.dart';
import 'package:flutter_login_taxi/Controllers/ventas_controller.dart';
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

class addventasscreen extends StatefulWidget {
  const addventasscreen({super.key});
  @override
  State<addventasscreen> createState() => _addventasscreenState();
}

class _addventasscreenState extends State<addventasscreen> {
  var controller = Get.find<ventasController>();
  var controllerClie = Get.put(clienteController());
  final _formkeyCli = GlobalKey<FormState>();
  TextEditingController busquetextController = TextEditingController();
  String cliguard = "";
  bool enabletextfieldclie = true;

  @override
  void initState() {
    super.initState();
    controller.limpiarCampos();
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.orange;
    }
    return Colors.black;
  }

  _customDialogproduct({required BuildContext context}) {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          var busq = "";

          return StatefulBuilder(builder: (context, StateSetter setState) {
            var data = controller.productoslist.value;

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

            return AlertDialog(
                title: Text("Agregar Productos"),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Aceptar'),
                    onPressed: () async {
                      controller.productoslistcheck.value = controller
                          .productoslist
                          .where((data) => data['estado'] == true)
                          .toList();
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Cancelar'),
                    onPressed: () async {
                      await controller.getproductos();

                      Navigator.of(context).pop();
                    },
                  ),
                ],
                content: SingleChildScrollView(
                  child: Container(
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
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.orange)),
                                  )),
                            )),
                          ],
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    child: ListTile(
                                        onTap: () {},
                                        title: Text(
                                          data[index]['nombre'],
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
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
                                              Flexible(
                                                child: Text(
                                                  data[index]['codigo']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
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
                                        leading: Container(
                                            width: 100,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  checkColor: Colors.white,
                                                  fillColor:
                                                      MaterialStateProperty
                                                          .resolveWith(
                                                              getColor),
                                                  value: data[index]['estado'],
                                                  onChanged: (bool? value) {
                                                    data[index]['estado'] =
                                                        value;
                                                    setState(() {});
                                                  },
                                                ),
                                                data[index]['imagenurl'] == ""
                                                    ? Image.asset(
                                                        "assets/Imagenes/paquete.png",
                                                        width: 50,
                                                        height: 50,
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
                                                          width: 50,
                                                          height: 50,
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
                                              ],
                                            ))));
                              },
                            ))
                      ],
                    ),
                  ),
                ));
          });
        });
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
    const List<String> listtipoPago = <String>['Contado', 'Credito'];
    const List<String> listformaPago = <String>['Efectivo', 'Tarjeta', 'Yape'];
    @override
    void dispose() {
      super.dispose();
    }

    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                actions: [
                  Obx(() => controller.isloading.value
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
                                await controller.registrarventas();

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
                          }))
                ],
                leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.back();
                    }),
                title: Text(
                  "Registrar ventas",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ];
          },
          body: Padding(
              padding: EdgeInsets.all(15),
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
                              "Codigo de Venta",
                              controller.codigoVentatextController,
                              false,
                              TextInputType.text,
                              "text",
                              true,
                              false),
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
                                fieldViewBuilder: (context,
                                    textEditingController,
                                    focusNode,
                                    onFieldSubmitted) {
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
                                            borderSide: BorderSide(
                                                color: Colors.orange)),
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
                                          controller.clienteidtextController
                                              .text = "";
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
                                      await _customDialogclient(
                                          context: context);
                                    },
                                    icon: const Icon(
                                      Icons.add_rounded,
                                      color: Colors.black,
                                    ),
                                  )),
                            ],
                          ),
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
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none)),
                                value: null,
                                validator: (value) {
                                  if (controller
                                      .tipoVentatextController.text.isEmpty) {
                                    return "Seleccionar";
                                  }
                                },
                                hint: Text(
                                  "Tipo de Pago",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                                isExpanded: true,
                                onChanged: (newvalue) {
                                  controller.tipoVentatextController.text =
                                      newvalue.toString();
                                },
                                items: listformaPago.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                              ))),
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
                                value: null,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none)),
                                validator: (value) {
                                  if (controller
                                      .formaPagotextController.text.isEmpty) {
                                    return "Seleccionar";
                                  }
                                },
                                hint: Text(
                                  "Forma de Pago",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                                isExpanded: true,
                                onChanged: (newvalue) {
                                  controller.formaPagotextController.text =
                                      newvalue.toString();
                                },
                                items: listtipoPago.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                              ))),
                        ],
                      )),

                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,

                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // color: Color.fromARGB(255, 165, 165, 165),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Column(children: [
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Total: S/25",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ourButton(
                                color: Colors.orange,
                                onPress: () async {
                                  await _customDialogproduct(context: context);
                                },
                                textcolor: Colors.black,
                                title: "Agregar Productos"),
                          ],
                        ),
                      ),
                      Divider(color: Colors.black),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Productos",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      // Container(
                      //     height: 300,
                      //     child: ListView.builder(
                      //         physics: ScrollPhysics(),
                      //         itemCount: 6,
                      //         itemBuilder: (context, index) {
                      //           return Container(
                      //             child: Column(
                      //               children: [
                      //                 ListTile(
                      //                     title: Text('Producto'),
                      //                     leading: Image.asset(
                      //                       "assets/Imagenes/paquete.png",
                      //                       width: 80,
                      //                       height: 80,
                      //                       fit: BoxFit.cover,
                      //                     )),
                      //                 ListTile(
                      //                     title: Text("S/5"),
                      //                     trailing: Container(
                      //                         width: 120,
                      //                         child: Row(
                      //                           children: [
                      //                             IconButton(
                      //                               onPressed: () async {},
                      //                               icon: const Icon(
                      //                                 Icons.remove_circle,
                      //                                 color: Colors.black,
                      //                               ),
                      //                             ),
                      //                             Text("1"),
                      //                             IconButton(
                      //                               onPressed: () async {},
                      //                               icon: const Icon(
                      //                                 Icons.add_circle,
                      //                                 color: Colors.black,
                      //                               ),
                      //                             ),
                      //                           ],
                      //                         )))
                      //               ],
                      //             ),
                      //           );
                      //         }))
                    ]),
                  )

                  // customDropdownButton()
                ],
              ))),
    );
  }
}
