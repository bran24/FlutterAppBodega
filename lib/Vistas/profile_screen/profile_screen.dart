import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Consts/conts.dart';
import 'package:flutter_login_taxi/Controllers/profile_controller.dart';
import 'package:flutter_login_taxi/Services/Firebase_service.dart';
import 'package:flutter_login_taxi/Vistas/messages_screen/messages_screen.dart';
import 'package:flutter_login_taxi/Vistas/profile_screen/edit_profile_screen.dart';
import 'package:get/get.dart';

import '../../Components/internet_exeption_wiedget.dart';
import '../../Components/internet_exeption_wiedget2.dart';
import '../../Controllers/auth_controller.dart';
import '../../Components/app_bar_widget.dart';
import '../../Components/drawer_custom.dart';
import '../../Controllers/connection_status_controller.dart';
import '../../Services/check_internet_connection.dart';
import '../Login.dart';
import '../../Consts/lists.dart';

class profilescreen extends StatefulWidget {
  const profilescreen({super.key});
  @override
  State<profilescreen> createState() => _profilescreenState();
}

class _profilescreenState extends State<profilescreen> {
  var controller = Get.find<authController>();
  var controller2 = Get.find<ProfileController>();
  var controllerconn = Get.put(ConnectionStatusController());
  void _Salir(BuildContext context) async {
    await controller.signoutMethod();
    Get.offAll(() => Login());
  }

  @override
  Widget build(BuildContext context) {
    // final User? usuario = FirebaseAuth.instance.currentUser;
    // print("iddddddddddd");
    // print(usuario!.uid);
    // String? email;
    // if (usuario != null) {
    //   email = usuario.email;
    // }

    return Scaffold(
        appBar: appbarWidget(title: "Configuracion"),
        drawer: DrawerCuston(),
        body: StreamBuilder(
            stream: FirestorServices.getUser(auth.currentUser!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.red)));
              } else {
                var data = snapshot.data!.docs[0];

                return SafeArea(
                  child: Column(
                    children: [
                      InternetExceptionWidget2(),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {
                              controller2.nameController.text = data['name'];
                              // controller2.passController.text =
                              //     data['password'];

                              Get.to(() => EditProfileScreen(data: data));
                            },
                            icon: Icon(
                              Icons.edit,
                            )),
                      ),

                      //Users details section
                      Row(
                        children: [
                          data['imageUrl'] == ''
                              ? CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                  radius: 50,
                                )
                              : CachedNetworkImage(
                                  imageUrl: data['imageUrl'],
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  imageBuilder: (context, image) =>
                                      CircleAvatar(
                                    backgroundImage: image,
                                    radius: 50,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${data['name']}",
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(data['email']!,
                                  style: TextStyle(color: Colors.black))
                            ],
                          )),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.black)),
                              onPressed: () {
                                _Salir(context);
                              },
                              child: Text("Cerrar Sesion"))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 5,
                              )
                            ],
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return const Divider(color: Colors.white);
                            },
                            itemCount: profiButtonslist.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(profiButtonslist[index]),
                                leading: Icon(Icons.arrow_forward),
                                onTap: () {
                                  if (profiButtonslist[index] == "Mensajes")
                                    Get.to(() => messagesscreen());
                                },
                              );
                            }),
                      ),
                    ],
                  ),
                );
              }
            }));
  }
}
