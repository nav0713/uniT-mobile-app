import 'package:flutter/material.dart';
import '../../../theme-data.dart/text-styles.dart';
import '../../../utils/global.dart';

class DocInfo extends StatelessWidget {
  final String title;
  final String subTitle;
  const DocInfo({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        title,
        style: titleTextStyle()
            .copyWith(color: Colors.black87, fontSize: blockSizeVertical * 2),
      ),
      subtitle: Text(subTitle),
    );
  }
}
