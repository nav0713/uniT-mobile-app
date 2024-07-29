import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unit2/utils/global.dart';


class EmptyData extends StatelessWidget {
  final String message;
  const EmptyData({Key? key, required this.message,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SlideInDown(
              child: SvgPicture.asset(
                'assets/svgs/empty.svg',
                height: 200.0,
                width: 200.0,
                allowDrawingOutsideViewBox: true,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FadeInUp(
              child: Text(
                message,style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: blockSizeVertical * 2),
                textAlign: TextAlign.center,
              ),
            ),

          ],
        ),
      ),
    );
  }
}