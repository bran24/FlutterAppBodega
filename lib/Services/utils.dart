import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';

class utils {
  static Future<XFile?> compressImage(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r'.png|.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

    if (lastIndex == filePath.lastIndexOf(RegExp(r'.png'))) {
      final compressedImage = await FlutterImageCompress.compressAndGetFile(
          filePath, outPath,
          minWidth: 200,
          minHeight: 200,
          quality: 50,
          format: CompressFormat.png);
      return compressedImage;
    } else {
      final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        minWidth: 200,
        minHeight: 200,
        quality: 50,
      );
      return compressedImage;
    }
  }

  // static toastMessage(String message) {
  //   Fluttertoast.showToast(
  //       msg: message.toString(),
  //       toastLength: Toast.LENGTH_SHORT,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //       timeInSecForIosWeb: 1,
  //       gravity: ToastGravity.BOTTOM,
  //     );

  // }
}
