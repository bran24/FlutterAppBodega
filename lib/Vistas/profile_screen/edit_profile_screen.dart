import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Consts/conts.dart';
import 'package:flutter_login_taxi/Controllers/profile_controller.dart';
import 'package:flutter_login_taxi/Vistas/Principal.dart';
import 'package:flutter_login_taxi/Vistas/home_screen/home_screen.dart';

import 'package:flutter_login_taxi/Components/custom_textfield.dart';
import 'package:flutter_login_taxi/Components/our_button.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Components/internet_exeption_wiedget2.dart';

class EditProfileScreen extends StatefulWidget {
  final dynamic data;
  const EditProfileScreen({super.key, this.data});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState(data);
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final dynamic data;
  _EditProfileScreenState(this.data);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return Scaffold(
        appBar: AppBar(),
        body: Obx(() => Container(
            margin: EdgeInsets.all(16),
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
              children: [
                InternetExceptionWidget2(),
                SizedBox(
                  height: 10,
                ),
                data['imageUrl'] == '' && controller.profileImgPath.isEmpty
                    ? ClipOval(
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(48), // Image radius
                          child: Image.asset('assets/Imagenes/perfil1.jpg',
                              width: 50, fit: BoxFit.cover),
                        ),
                      )
                    : data['imageUrl'] != '' &&
                            controller.profileImgPath.isEmpty
                        ? ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(48), // Image radius
                              child: Image.network(data['imageUrl'],
                                  width: 50, fit: BoxFit.cover),
                            ),
                          )
                        : ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(48), // Image radius
                              child: Image.file(
                                File(controller.profileImgPath.value),
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                SizedBox(
                  height: 10,
                ),
                ourButton(
                    color: Colors.orange,
                    onPress: () {
                      controller.changeImage();
                    },
                    textcolor: Colors.white,
                    title: "Actualizar"),
                Divider(),
                SizedBox(height: 20),
                customTextField("Nombre", controller.nameController, false,
                    TextInputType.text, "text", true, true),
                SizedBox(height: 20),
                customTextField(oldpass, controller.oldpassController, true,
                    TextInputType.text, "password", true, true),
                SizedBox(height: 20),
                customTextField(newpass, controller.newpassController, true,
                    TextInputType.text, "password", true, true),
                SizedBox(
                  height: 50,
                ),
                controller.isloading.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.red),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width - 60,
                        child: ourButton(
                            color: Colors.red,
                            onPress: () async {
                              try {
                                controller.isloading(true);

                                if (controller
                                    .profileImgPath.value.isNotEmpty) {
                                  await controller.uploadProfileImage();
                                } else {
                                  controller.profileImageLink =
                                      data["imageUrl"];
                                }

                                if (data["password"] ==
                                    controller.oldpassController.text) {
                                  await controller.updateProfile(
                                      imgurl: controller.profileImageLink,
                                      name: controller.nameController.text,
                                      password:
                                          controller.newpassController.text);

                                  await controller.changeAuthPassword(
                                      email: data["email"],
                                      password: data["password"],
                                      newPassword:
                                          controller.newpassController.text);

                                  Fluttertoast.showToast(
                                    msg: "Modificacion Exitosa",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                    timeInSecForIosWeb: 1,
                                    gravity: ToastGravity.BOTTOM,
                                  );
                                  Get.to(() => homescreen());
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Password antiguo Incorrecto",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                    timeInSecForIosWeb: 1,
                                    gravity: ToastGravity.BOTTOM,
                                  );
                                }
                              } catch (err, section) {
                                print(err);
                                print(section);
                                Fluttertoast.showToast(
                                  msg: err.toString(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                  timeInSecForIosWeb: 1,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              } finally {
                                controller.isloading(false);
                              }
                            },
                            textcolor: Colors.white,
                            title: "Guardar"),
                      )
              ],
            ))))));
  }
}
