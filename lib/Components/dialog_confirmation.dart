import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

dialogConfirmation({
  required BuildContext context,
  titulo,
  content,
  onPress,
  datos,
  msg,
}) {
  return showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titulo),
        content: Container(child: Text(content)),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Aceptar'),
            onPressed: () async {
              Navigator.of(context).pop();
              await onPress(datos);
              Fluttertoast.showToast(
                msg: msg,
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0,
                timeInSecForIosWeb: 1,
                gravity: ToastGravity.BOTTOM,
              );
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
