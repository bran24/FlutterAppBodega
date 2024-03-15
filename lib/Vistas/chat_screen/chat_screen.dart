import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Components/chat_bubble.dart';
import '../../Components/app_bar_widget.dart';
import '../../Components/drawer_custom.dart';
import '../../Components/internet_exeption_wiedget2.dart';

class chatscreen extends StatefulWidget {
  const chatscreen({super.key});
  @override
  State<chatscreen> createState() => _chatscreenState();
}

class _chatscreenState extends State<chatscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(children: [
        InternetExceptionWidget2(),
        Expanded(
            child: ListView.builder(
          itemCount: 20,
          itemBuilder: ((context, index) {
            return chatbubble();
          }),
        )),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 56,
          child: Row(children: [
            Expanded(
                child: TextFormField(
              decoration: const InputDecoration(
                  hintText: "Ingresar Mensaje",
                  isDense: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
            )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                  color: Colors.black,
                ))
          ]),
        )
      ]),
    ));
  }
}
