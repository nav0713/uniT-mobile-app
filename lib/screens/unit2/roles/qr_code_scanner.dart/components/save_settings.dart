import 'package:flutter/material.dart';

import '../../../../../theme-data.dart/colors.dart';

class SelectedState extends StatelessWidget {
  final String title;
  final String subtitle;
  const SelectedState({Key? key,required this.subtitle, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: third, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const Divider(),
           
              ]),
        ],
      ),
    );
  }
}
