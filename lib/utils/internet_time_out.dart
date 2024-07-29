import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';

import '../theme-data.dart/colors.dart';

class TimeOutError extends StatelessWidget {
  const TimeOutError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svgs/timeout.svg',
            height: 200.0,
            width: 200.0,
            allowDrawingOutsideViewBox: true,
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            'Connection Timeout! Pls check your internet connectivity.',
            textAlign: TextAlign.center,),
            
           const SizedBox(
            height: 25,
          ),
                  SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                  style: mainBtnStyle(
                      primary, Colors.transparent, primary.withOpacity(.5)),
                  onPressed:(){
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  label: const Text(
                     "try again",
                    style: TextStyle(color: Colors.white),
                  )),
            )
        ],
      ),
    );
  }
}