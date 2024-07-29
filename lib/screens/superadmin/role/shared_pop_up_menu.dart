import 'package:flutter/material.dart';

PopupMenuItem<int> popMenuItem({String? text, int? value, IconData? icon}) {
  return PopupMenuItem(
    value: value,
    child: Row(
      children: [
        Icon(
          icon,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          text!,
        ),
      ],
    ),
  );
}