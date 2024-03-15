import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'custom_textfield.dart';

customDialog(
    {required BuildContext context,
    titulo,
    controlador,
    labelfield,
    onPress,
    actualizar}) {
  return showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titulo),
        content: Container(
          child: customTextField(labelfield, controlador, false,
              TextInputType.text, "texto", true, false),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Agregar'),
            onPressed: () async {
              try {
                if (controlador.text.toString().isNotEmpty) {
                  await onPress();
                  await actualizar();
                  controlador.text = '';
                  Fluttertoast.showToast(
                    msg: "Registro Exitoso",
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 16.0,
                    timeInSecForIosWeb: 1,
                    gravity: ToastGravity.BOTTOM,
                  );
                  Navigator.of(context).pop();
                } else {
                  Fluttertoast.showToast(
                    msg: "Llenar Campo",
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                    timeInSecForIosWeb: 1,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
              } catch (e, s) {
                Fluttertoast.showToast(
                  msg: e.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                  timeInSecForIosWeb: 1,
                  gravity: ToastGravity.BOTTOM,
                );
                print(e);
                print(s);
              }
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cancelar'),
            onPressed: () {
              controlador.text = '';
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
