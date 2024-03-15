import 'package:flutter/material.dart';

Widget customTextField(String? title, TextEditingController controller,
    bool isPass, TextInputType type, String icono, bool obl, bool cant) {
  return TextFormField(
      validator: (value) {
        if (obl) {
          if (value!.isEmpty) {
            return "Campo obligatorio";
          }
        }
        if (cant) {
          if (icono == "telefono") {
            if (value!.length < 9) {
              return "Se debe contar con 9 numeros";
            }
          } else {
            if (value!.length < 4) {
              return "Se debe contar con al menos 4 caracteres";
            }
          }

          ;
        }
      },
      keyboardType: type,
      obscureText: isPass,
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        // labelStyle: TextStyle(color: Colors.orange, fontSize: 20),
        filled: true,
        prefixIcon: Icon(icono == "password"
            ? Icons.password
            : icono == "precio"
                ? Icons.paid_rounded
                : icono == "busqueda"
                    ? Icons.search
                    : icono == "telefono"
                        ? Icons.phone
                        : Icons.paste_rounded),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
      )

//         decoration: InputDecoration(
//             hintStyle: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Color.fromARGB(255, 165, 165, 165)),
//             hintText: hint,
//             isDense: true,
//             fillColor: Color.fromARGB(255, 235, 235, 235),
//             filled: true,
//             border: InputBorder.none,
//             focusedBorder: const OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.red))

//             ),

      );
}
