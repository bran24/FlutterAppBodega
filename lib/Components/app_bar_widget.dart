import 'package:flutter/material.dart';

AppBar appbarWidget({title}) {
  return AppBar(
      // automaticallyImplyLeading: false,
      title: Text(
    title,
    style: TextStyle(
        fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
  ));
}
