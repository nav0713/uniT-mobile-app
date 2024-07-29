import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/utils/global.dart';

import '../theme-data.dart/colors.dart';

class SomethingWentWrong extends StatelessWidget {
  final String? message;
  final Function()? onpressed;
  const SomethingWentWrong({Key? key, required this.message, required this.onpressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SlideInLeft(
              from: 20,
              child: SvgPicture.asset(
                'assets/svgs/timeout.svg',
                height: 200.0,
                width: 200.0,
                allowDrawingOutsideViewBox: true,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SlideInRight(
              from: 20,
              child: Text(
                message??'',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              child: BounceInDown(
                from: 20,
                child: ElevatedButton.icon(
                    style: mainBtnStyle(
                        primary, Colors.transparent, primary.withOpacity(.5)),
                    onPressed: onpressed,
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "try again",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}