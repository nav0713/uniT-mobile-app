import 'package:flutter/material.dart';
import 'package:unit2/theme-data.dart/colors.dart';

ListTile subMenu(IconData icon, String title,Function() onTap) {
  return ListTile(
    leading: Container(
        margin: const EdgeInsets.only(left: 20),
        child: Icon(
          icon,
          size: 20,
          color: primary,
        )),
    title: Text(
      title,
      style: const TextStyle(),
    ),
    trailing: const Icon(Icons.keyboard_arrow_right),
    onTap: onTap,
  );
}
