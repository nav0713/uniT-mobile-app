import 'package:flutter/material.dart';

class CostumDivider extends StatelessWidget {
  const CostumDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey.withOpacity(.5),
      height: 1,
      thickness: 1,
    );
  }
}
