import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Consts/lists.dart';

Widget featuredButton(String? img, String? text) {
  return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: 230,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Row(
        children: [
          Image.asset(img!, height: 70, width: 70, fit: BoxFit.fill),
          SizedBox(
            height: 10,
          ),
          Text(
            text!,
            style: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
          ),
        ],
      ));
}
