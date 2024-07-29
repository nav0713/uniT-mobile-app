import 'package:flutter/material.dart';

const primary = Color(0xff99191a);
const second = Color(0xffd92828);
const third = Color(0xffeb8b1e);
const fourth = Color(0xfff6c359);
const fifth = Color(0xfffdfefd);
const success = Color(0xffa5d6a7);
const success2 = Color(0xff66bb6a);
const primary2 = Color(0xff039be5);

LinearGradient primaryGradient() {
  return const LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [second, Color(0xffFF5151)]);
}
