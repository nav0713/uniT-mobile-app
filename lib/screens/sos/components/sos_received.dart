import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/utils/text_container.dart';
import '../../../theme-data.dart/colors.dart';
import '../../../utils/global.dart';

class SOSreceived extends StatelessWidget {
  final Function() onpressed;
  const SOSreceived({super.key,  required this.onpressed});

  @override
  Widget build(BuildContext context) {
 
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 35),
        height: screenHeight,
        child: Stack(
          children: [
            Positioned(
                bottom: 0,
                child: SizedBox(
                  width: screenWidth,
                  height: screenHeight / 2,
                  child: Opacity(
                    opacity: .2,
                    child: Image.asset(
                      "assets/pngs/emergency.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: blockSizeVertical * 6,
                ),
                Bounce(
                  from: 20,
                  infinite: true,
                  delay: const Duration(milliseconds: 800),
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: CircleAvatar(
                          radius: blockSizeVertical * 8,
                          backgroundColor: second,
                          child: Container(
                            margin: const EdgeInsets.only(top: 25),
                            child: SvgPicture.asset(
                              'assets/svgs/sos.svg',
                              height: blockSizeHorizontal * 17,
                              color: Colors.white,
                              allowDrawingOutsideViewBox: true,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: blockSizeVertical * 3,
                        child: const SpinKitPulse(
                          color: primary,
                          size: 120,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SlideInUp(
                  from: 50,
                  child: AutoSizeText(
                    sosReceived,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontSize: 40,
                          color: third,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SlideInUp(
                  from: 50,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: AutoSizeText(
                      sOSReceivedMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Expanded(child: Container()),
                SlideInUp(
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: TextButton(
                      style: mainBtnStyle(second, Colors.transparent, second),
                      onPressed: onpressed,
                      child: const Text(cancelRequest,
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
    );
  }
}
