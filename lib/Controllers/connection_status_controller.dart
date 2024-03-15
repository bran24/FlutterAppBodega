import 'dart:async';

import 'package:flutter_login_taxi/main.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../Services/check_internet_connection.dart';

class ConnectionStatusController extends GetxController {
  late StreamSubscription _connectionSubscription;
  final status = ConnectionStatus.online.obs;

  ConnectionStatusController() {
    _connectionSubscription = internetChecker.internetStatus().listen((event) {
      status.value = event;
    });
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }
}
