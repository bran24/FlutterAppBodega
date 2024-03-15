import 'package:flutter_login_taxi/Controllers/auth_controller.dart';
import 'package:flutter_login_taxi/Controllers/botellas_controller.dart';
import 'package:flutter_login_taxi/Controllers/cliente_controller.dart';
import 'package:flutter_login_taxi/Controllers/product_controller.dart';
import 'package:flutter_login_taxi/Controllers/profile_controller.dart';
import 'package:flutter_login_taxi/Controllers/proveedor_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../Controllers/drawer_controller.dart';

class AllBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<authController>(() => authController());
    Get.lazyPut<botellasController>(() => botellasController());
    Get.lazyPut<clienteController>(() => clienteController());
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<ProveedorController>(() => ProveedorController());
  }
}
