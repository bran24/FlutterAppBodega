import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login_taxi/Services/check_internet_connection.dart';

import 'package:flutter_login_taxi/res/Routes/routes.dart';

import 'package:get/get.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final internetChecker = CheckInternetConnection();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'BodeBrand',
        theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.light()
                .copyWith(primary: Colors.black, secondary: Colors.white)),
        debugShowCheckedModeBanner: false,
        initialRoute: '/Login',
        getPages: AppRoutes.appRoutes());

    //  GetPage(name: '/', page: () => Login(), binding: HomeBinding())
//         Get.to(HomePage(), binding: HomeBinding()); // or like this!
// Get.toNamed("/", binding: HomeBinding()); // and this!
  }
}
