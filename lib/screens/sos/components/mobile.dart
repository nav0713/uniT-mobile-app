import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

import '../../../theme-data.dart/colors.dart';

class Mobile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onPressed;
  const Mobile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        FontAwesome5.sim_card,
        color: second,
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
