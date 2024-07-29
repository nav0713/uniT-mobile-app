import 'package:flutter/material.dart';
import 'package:unit2/theme-data.dart/colors.dart';

class MainMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function() onTap;
  const MainMenu({
    required this.icon,
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: primary,
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: onTap,
    );
  }
}
