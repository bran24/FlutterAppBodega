import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Clases/Usuario.dart';

import 'package:flutter_login_taxi/Vistas/home_screen/home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Components/internet_exeption_wiedget2.dart';
import '../Controllers/auth_controller.dart';

class Registrar extends StatefulWidget {
  const Registrar({super.key});

  @override
  State<Registrar> createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
  @override
  void initState() {
    _emailController = TextEditingController();
    _contrasenaController = TextEditingController();
    _nameController = TextEditingController();
    _passwordRetype = TextEditingController();

    super.initState();
  }

  var controller = Get.find<authController>();

//text controller

  bool? isCheck = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _contrasenaController;
  late TextEditingController _passwordRetype;

  bool _loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  stops: [0.1, 0.9],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 255, 226, 129),
                    Colors.orange,
                  ])),
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Center(
              child: SingleChildScrollView(
                  child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InternetExceptionWidget2(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Registrar",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      prefixIcon: Icon(Icons.person),
                      labelText: "Correo",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Colors.black), //<-- SEE HERE
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.black)),
                    ),
                    controller: _emailController,
                    onSaved: (value) {},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Campo obligatorio";
                      }
                    }),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      prefixIcon: Icon(Icons.person),
                      labelText: "Nombre de Usuario",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Colors.black), //<-- SEE HERE
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.black)),
                    ),
                    controller: _nameController,
                    onSaved: (value) {},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Campo obligatorio";
                      }
                    }),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(Icons.password),
                    labelText: "Contraseña",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.black), //<-- SEE HERE
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.black)),
                  ),
                  controller: _contrasenaController,
                  onSaved: (value) {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Campo obligatorio";
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _passwordRetype,
                  obscureText: true,
                  onSaved: (value) {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Campo obligatorio";
                    } else if (value != _contrasenaController.text) {
                      return "Contraseña no Coincide";
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(Icons.password),
                    labelText: "Confirmar Contraseña",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.black), //<-- SEE HERE
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.black)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Checkbox(
                    activeColor: Colors.black,
                    checkColor: Colors.white,
                    value: isCheck,
                    onChanged: (newvalue) {
                      setState(() {
                        isCheck = newvalue;
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: RichText(
                    text: const TextSpan(children: [
                      TextSpan(
                          text: "He leido y acepto los",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: " Terminos y Condiciones",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold))
                    ]),
                  ))
                ]),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor:
                            isCheck == true ? Colors.black : Colors.grey,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10)),
                    onPressed: (() {
                      setState(() {
                        _loading = true;
                      });
                      if (isCheck != false) registroNuevoUsuario(context);
                    }),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Registrar",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        if (_loading) ...[
                          Container(
                            height: 20,
                            width: 20,
                            margin: const EdgeInsets.only(left: 20),
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          )
                        ]
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("¿Ya tienes una cuenta?"),
                    SizedBox(
                      width: 6,
                    ),
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          "Iniciar Sesion",
                          style: TextStyle(color: Colors.red),
                        ))
                  ],
                )
              ],
            ),
          )))),
    );
  }

  Future<void> registroNuevoUsuario(BuildContext context) async {
    User usuario;
    try {
      await controller.signup(
          email: _emailController.text.trim(),
          password: _contrasenaController.text.trim());

      await controller.storeUserData(
          name: _nameController.text,
          password: _contrasenaController.text,
          email: _emailController.text);
      mostrarSnackBar("Usuario creado correctamente", context);
      Get.offAll(() => homescreen());
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
        timeInSecForIosWeb: 1,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e, s) {
      print(e);
      print(s);

      auth.signOut();
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}

void mostrarSnackBar(String msj, BuildContext context) {
  final snackBar = SnackBar(content: Text(msj));

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
