import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/product_controller.dart';

Widget customDropdownButton(
    hint, List<String> list, dropdownValue, ProductController controller) {
  // const List<String> list = <String>['Litro', 'Gramos', 'Kilogramos', 'Metros'];
  // String dropdownValue = "";
  return Obx(() => Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      // color: Color.fromARGB(255, 165, 165, 165),
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField(
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none)),
        value: dropdownValue == '' ? null : dropdownValue.value,
        validator: (value) {
          if (controller.categoryvalue.value.isEmpty) {
            return "Seleccionar";
          } else if (controller.unidadvalue.value.isEmpty) {
            return "Seleccionar";
          }
        },
        hint: Text(
          hint,
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        isExpanded: true,
        onChanged: (newvalue) {
          if (hint == "Categoria") {
            controller.categoryvalue.value = newvalue.toString();
          }

          if (hint == "Unidad") {
            controller.unidadvalue.value = newvalue.toString();
          }
        },
        items: list.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
      ))));
}
