import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Consts/lists.dart';

Widget chatbubble() {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
          color: Colors.pinkAccent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            " brndo feoooooooooooooooo🤮🤮",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            "10:45pm",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ],
      ),
    ),
  );
}
