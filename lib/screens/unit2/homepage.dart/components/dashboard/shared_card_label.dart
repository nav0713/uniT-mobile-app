import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../../../theme-data.dart/colors.dart';
import '../../../../../utils/global.dart';

class CardLabel extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Function()? ontap;
  const CardLabel(
      {super.key,
      required this.icon,
      required this.title,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: second,
      onTap: ontap,
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 5, 8, 13),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 2)
            ],
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Icon(
                  icon,
                  size: 20,
                  weight: 100,
                  grade: 100,
                  color: second,
                ),
              ),
              const Expanded(child: SizedBox()),
              Flexible(
                flex: 2,
                child: AutoSizeText(
                  minFontSize: 10,
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontSize: blockSizeVertical * 1.2,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
      ),
    );
  }
}