import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonWidget {
  static shortToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 13.0,
    );
  }
}
