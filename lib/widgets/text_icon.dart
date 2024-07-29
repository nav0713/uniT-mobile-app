import 'package:flutter/material.dart';
import 'package:unit2/theme-data.dart/text-styles.dart';

import '../theme-data.dart/colors.dart';

class TextIcon extends StatelessWidget {
  final String title;
  final IconData icon;

  const TextIcon({Key? key, required this.title, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          title,
          style: titleTextStyle().copyWith(color: primary, fontSize: 18),
        ),
        Icon(
          icon,
          color: primary,
          size: 24,
        ),
      ],
    );
  }
}
