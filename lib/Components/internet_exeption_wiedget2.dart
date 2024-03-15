import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Components/our_button.dart';
import 'package:get/get.dart';

import '../Controllers/connection_status_controller.dart';
import '../Services/check_internet_connection.dart';

class InternetExceptionWidget2 extends StatefulWidget {
  // final VoidCallback onPress;
  const InternetExceptionWidget2({Key? key}) : super(key: key);

  @override
  State<InternetExceptionWidget2> createState() =>
      _InternetExceptionWidgetState2();
}

class _InternetExceptionWidgetState2 extends State<InternetExceptionWidget2> {
  final controller = Get.put(ConnectionStatusController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
        visible: controller.status != ConnectionStatus.online,
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 60,
          color: Colors.red,
          child: Row(
            children: [
              const Icon(Icons.wifi_off),
              SizedBox(width: 8),
              const Text("Sin Conexion a Internet")
            ],
          ),
        )));
  }
}
