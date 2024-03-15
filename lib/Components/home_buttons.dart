import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

Widget homeButtons({width, height, icon, String? title, onPress, count = "0"}) {
  return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                title!,
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold),
              ),
              Text(
                count,
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold),
              )
            ],
          )),
          Icon(
            icon,
            color: Colors.orange,
            size: 23,
          ),
        ],
      ));
}
