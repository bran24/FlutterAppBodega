import 'package:flutter_login_taxi/Controllers/botellas_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../Controllers/product_controller.dart';

class BotellasBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<botellasController>(() => botellasController());
  }
}
