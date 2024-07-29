import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../utils/global.dart';
import '../../../../utils/text_container.dart';

class NoModule extends StatelessWidget {
  const NoModule({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      width: double.infinity,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlipInX(
              child: SvgPicture.asset(
                'assets/svgs/no_module.svg',
                height: blockSizeVertical * 30,
                allowDrawingOutsideViewBox: true,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            FlipInX(
              delay: const Duration(milliseconds: 400),
              child: Text(
                noModule,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(fontSize: blockSizeVertical * 5, height: .8),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            FlipInX(
                            delay: const Duration(milliseconds: 400),
              child: Text(
                noModuleSubTitle,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: blockSizeVertical * 1.5),
                textAlign: TextAlign.center,
              ),
            )
          ]),
    );
  }
}
