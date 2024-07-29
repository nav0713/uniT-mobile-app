import 'package:flutter/material.dart';
import 'package:unit2/theme-data.dart/colors.dart';

InputDecoration normalTextFieldStyle(String labelText, String hintText) {
  return InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.grey,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Colors.black87,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      filled: false);
}



InputDecoration loginTextFieldStyle() {
  return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      prefixIcon: const Icon(
        Icons.person,
        color: primary,
      ),
      labelText: 'Username',
      hintText: 'Enter your username...',
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 2,
          color: Colors.black87,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.black87,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 2,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 2,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      filled: false);
}
