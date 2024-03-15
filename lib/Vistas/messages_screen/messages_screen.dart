import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Vistas/chat_screen/chat_screen.dart';
import 'package:get/get.dart';

import '../../Components/app_bar_widget.dart';
import '../../Components/drawer_custom.dart';

class messagesscreen extends StatefulWidget {
  const messagesscreen({super.key});
  @override
  State<messagesscreen> createState() => _messagesscreenState();
}

class _messagesscreenState extends State<messagesscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(title: "Mensajes"),
      drawer: DrawerCuston(),
      body: ListView(
          physics: const BouncingScrollPhysics(),
          children: List.generate(
              20,
              (index) => ListTile(
                    onTap: () {
                      Get.to(() => chatscreen());
                    },
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      "Username",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "mesaage....",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Text(
                      "10:21 Pm",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ))),
    );
  }
}
