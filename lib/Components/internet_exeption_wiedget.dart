import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Components/our_button.dart';
import 'package:get/get.dart';

import '../Controllers/connection_status_controller.dart';

class InternetExceptionWidget extends StatefulWidget {
  // final VoidCallback onPress;
  const InternetExceptionWidget({Key? key}) : super(key: key);

  @override
  State<InternetExceptionWidget> createState() =>
      _InternetExceptionWidgetState();
}

class _InternetExceptionWidgetState extends State<InternetExceptionWidget> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off,
            color: Colors.orange,
            size: 30,
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child: Text('Sin Conexion',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          ),
          SizedBox(
            height: height * 0.15,
          ),
          // Container(
          //   height: 44,
          //   width: 160,
          //   child: ourButton(
          //       color: Colors.orange,
          //       textcolor: Colors.white,
          //       title: 'Recargar',
          //       onPress: widget.onPress),
          // )
        ],
      ),
    );
  }
}
