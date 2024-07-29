import 'package:flutter/material.dart';
import 'package:unit2/utils/global.dart';

TextStyle titleTextStyle() {
  return TextStyle(
      fontSize: blockSizeVertical * 2.5, fontWeight: FontWeight.w500);
}

TextStyle personInitials() {
  return TextStyle(
      fontSize: blockSizeVertical * 2,
      fontWeight: FontWeight.w500,
      color: Colors.white);
}

TextStyle personInfo() {
  return TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.black54,
      fontSize: blockSizeVertical * 2.5);
}
