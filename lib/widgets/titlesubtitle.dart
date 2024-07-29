import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:unit2/theme-data.dart/colors.dart';

class TitleSubtitle extends StatelessWidget {
  final String title;
  final String sub;
  const TitleSubtitle({super.key, required this.title, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),

      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
                color: Colors.black38, blurRadius: 32, offset: Offset(0, 5))
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const Gap(3),
          Text(
            sub,
            style: const TextStyle(fontSize: 9,color: Colors.black87,fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}