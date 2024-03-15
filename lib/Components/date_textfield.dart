import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget dateTextfield(TextEditingController controller, context, String label) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      // labelStyle: TextStyle(color: Colors.orange, fontSize: 20),
      filled: true,
      prefixIcon: Icon(Icons.calendar_today),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
    ),
    validator: (value) {
      if (controller.text.isEmpty) {
        return "Seleccionar fecha";
      }
    },

    readOnly: true, //set it true, so that user will not able to edit text
    onTap: () async {
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(
              2000), //DateTime.now() - not to allow to choose before today.
          lastDate: DateTime(2101));
      if (pickedDate != null) {
        //pickedDate output format => 2021-03-10 00:00:00.000
        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        print(formattedDate);
        controller.text = formattedDate;

        //set output date to TextField value.
      } else {
        print("Date is not selected");
      }
    },
  );
}
