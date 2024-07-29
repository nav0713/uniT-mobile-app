import 'package:flutter/material.dart';

class AddLeading extends StatelessWidget {
  final Function() onPressed;
  const AddLeading({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: const Icon(Icons.add));
  }
}