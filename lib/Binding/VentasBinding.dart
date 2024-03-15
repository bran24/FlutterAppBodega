import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../Controllers/ventas_controller.dart';

class VentasBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ventasController>(() => ventasController());
  }
}
