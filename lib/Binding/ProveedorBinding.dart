import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../Controllers/proveedor_controller.dart';

class ProveedorBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProveedorController>(() => ProveedorController());
  }
}
