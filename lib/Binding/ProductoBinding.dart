import 'package:flutter_login_taxi/Controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../Controllers/product_controller.dart';

class ProductoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
