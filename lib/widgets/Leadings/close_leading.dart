import 'package:flutter/material.dart';

class CloseLeading extends StatelessWidget {
  final Function() onPressed;
  const CloseLeading({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: const Icon(Icons.close));
  }
}