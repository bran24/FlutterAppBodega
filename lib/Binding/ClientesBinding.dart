import 'package:flutter_login_taxi/Controllers/cliente_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../Controllers/product_controller.dart';

class ClientesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<clienteController>(() => clienteController());
  }
}
