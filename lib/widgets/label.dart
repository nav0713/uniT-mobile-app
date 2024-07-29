import 'package:flutter/material.dart';

import '../utils/global.dart';

class Label extends StatelessWidget {
  final String text;
  const Label({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return  Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(text,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: blockSizeVertical * 2.5)),
              );
  }
}