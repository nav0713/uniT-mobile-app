

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool> pressAgainToExit() async {
  DateTime? currentBackPressTime;
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime) > const Duration(seconds: 1)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(
        msg: "Press again to exit",
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black);
    return Future.value(false);
  }
  return true;
}
