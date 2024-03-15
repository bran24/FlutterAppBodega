import 'package:flutter_login_taxi/Controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PrincipalBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<authController>(() => authController());
  }
}
