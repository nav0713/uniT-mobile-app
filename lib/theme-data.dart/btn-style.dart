import 'package:flutter/material.dart';

ButtonStyle mainBtnStyle(Color background, Color borderColor, Color overlay) {
  return ButtonStyle(
    
      elevation: MaterialStateProperty.all<double>(0),
      backgroundColor: MaterialStateProperty.all<Color>(background),
      overlayColor: MaterialStateProperty.all<Color>(overlay),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
              side: BorderSide(
                width: 2,
                color: borderColor,
              ))));
}

ButtonStyle secondaryBtnStyle(
    Color background, Color borderColor, Color overlay) {
  return ButtonStyle(
      elevation: MaterialStateProperty.all<double>(0),
      backgroundColor: MaterialStateProperty.all<Color>(background),
      overlayColor: MaterialStateProperty.all<Color>(overlay),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(
                width: 2,
                color: borderColor,
              ))));
}
