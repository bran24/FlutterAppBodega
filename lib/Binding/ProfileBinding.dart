import 'package:flutter_login_taxi/Controllers/botellas_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../Controllers/auth_controller.dart';
import '../Controllers/product_controller.dart';
import '../Controllers/profile_controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<authController>(() => authController());
  }
}
