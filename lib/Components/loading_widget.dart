import 'package:flutter/material.dart';

Widget loadingIndicador() {
  return Center(
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.orange)));
}
