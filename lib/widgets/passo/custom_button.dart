import 'package:flutter/material.dart';
import 'package:unit2/theme-data.dart/colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;

  const CustomButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(30),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      child: icon,
    );
  }
}
