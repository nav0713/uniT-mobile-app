import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

import '../../../../theme-data.dart/colors.dart';

showAlert(context,Function confirm) {
  CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      title: 'Download Failed!',
      text: 'Make sure you have internet connection. Please try again.',
      loopAnimation: false,
      confirmBtnText: "Try again",
      confirmBtnColor: primary,
      onConfirmBtnTap: confirm(),
      backgroundColor: Colors.black);
}
