import 'dart:io';
import 'package:flutter_login_taxi/Controllers/auth_controller.dart';
import 'package:flutter_login_taxi/Vistas/Principal.dart';

import 'package:flutter_login_taxi/Vistas/Registrar.dart';
import 'package:flutter_login_taxi/Vistas/home_screen/home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Clases/Usuario.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var controller = Get.find<authController>();

  bool _showPass = false;
  bool _loading = false;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  final _formkey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  void _estadoUsuarioAutenticado() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null)
        print("Usuario no autenticado");
      else
        print("Usuario autenticado");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        body: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    stops: [0.1, 0.9],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 255, 226, 129),
                      Colors.orange,
                    ])),
            child: Center(
                child: SingleChildScrollView(
                    child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/Imagenes/bodebrand.png",
                    height: 180,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        prefixIcon: Icon(Icons.person),
                        labelText: "Usuario",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Colors.black), //<-- SEE HERE
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.black)),
                      ),
                      controller: usernameController,
                      onSaved: (value) {},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Campo obligatorio";
                        } else if (!value.contains('@')) {
                          return "Formato de Email Incorrecto";
                        }
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: !_showPass,
                    controller: passwordController,
                    onSaved: (value) {},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Campo obligatorio";
                      } else if (value.length < 6)
                        return " La Contraseña debe contar con al menos 6 caracteres";
                    },
                    decoration: InputDecoration(
                        filled: true,
                        prefixIcon: Icon(Icons.password),
                        labelText: "Password",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Colors.black), //<-- SEE HERE
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.black)),
                        suffixIcon: IconButton(
                          icon: Icon(_showPass
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _showPass = !_showPass;
                            });
                          },
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    Container(
                      child: Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: controller.recuerdame.value,
                        onChanged: (bool? value) {
                          controller.recuerdame.value = value!;
                        },
                      ),
                    ),
                    SizedBox(width: 2),
                    Container(
                        child: Text("Recuerdame",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ))),
                  ]),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10)),
                      onPressed: (() {
                        _login(context);
                      }),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Iniciar Sesion",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          if (_loading) ...[
                            Container(
                              height: 20,
                              width: 20,
                              margin: const EdgeInsets.only(left: 20),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          ]
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("¿No estas registrado?"),
                      Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: TextButton(
                            child: Text(
                              "Registrate",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Get.toNamed("RegistrarUser");
                            },
                          )),
                    ],
                  )
                ],
              ),
            ))))));
  }

  _verificarRemenber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    controller.recuerdame.value = (prefs.getBool('remember') != null
        ? prefs.getBool('remember')
        : false)!;
    if (prefs.getStringList('Credenciales') != null) {
      List<String>? cred = prefs.getStringList('Credenciales');

      usernameController.text = cred![0];
      passwordController.text = cred[1];
    }
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

  Future<void> _login(BuildContext context) async {
    if (_formkey.currentState!.validate()) {
      if (_loading == false) {
        setState(() {
          _loading = true;
        });
        await controller
            .loginMethod(
                email: usernameController.text,
                password: passwordController.text)
            .then((value) => {
                  setState(() {
                    _loading = false;
                  }),
                  if (value != null)
                    {
                      Fluttertoast.showToast(
                        msg: "Loggeo Exitoso",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Color.fromARGB(255, 115, 168, 247),
                        textColor: Colors.white,
                        fontSize: 16.0,
                        timeInSecForIosWeb: 1,
                        gravity: ToastGravity.BOTTOM,
                      ),
                      Get.offAll(() => const homescreen()),
                    }
                });
      }
    }
  }

  void mostrarSnackBar(String msj, BuildContext context) {
    final snackBar = SnackBar(content: Text(msj));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    _estadoUsuarioAutenticado();
    _verificarRemenber();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }
}
