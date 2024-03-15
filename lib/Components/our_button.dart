import 'package:flutter/material.dart';

Widget ourButton({onPress, color, textcolor, title}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: color, padding: const EdgeInsets.all(12)),
      onPressed: () {
        onPress();
      },
      child: Text(
        title,
        style: TextStyle(color: textcolor, fontWeight: FontWeight.bold),
      ));
}
