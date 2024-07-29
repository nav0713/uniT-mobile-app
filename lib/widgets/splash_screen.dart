import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/global.dart';
import 'dart:io' show Platform;
class UniTSplashScreen extends StatelessWidget {
  const UniTSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.black12,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SlideInUp(
              from: 50,
              duration: const Duration(milliseconds: 300),
              child: SvgPicture.asset(
                'assets/svgs/logo.svg',
                height: blockSizeVertical * 12.0,
                allowDrawingOutsideViewBox: true,
                color: primary,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SlideInDown(
              from: 100,
              duration: const Duration(milliseconds: 200),
              child: Text("uniT-App",
                  style: TextStyle(
                      fontSize: blockSizeVertical * 4,
                      fontWeight: FontWeight.w600,
                      letterSpacing: .2,
                      height: 1,
                      color: Colors.black)),
            ),
            const SizedBox(height: 150,),
            SizedBox(child:Platform.isAndroid?  const SpinKitCircle(color: primary,size: 42,):  const CupertinoActivityIndicator(radius: 14,),)
           
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Flexible(
          //         flex: 2,
          //         child: Text("Please Wait ",style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 18))),
          //         const SizedBox(width: 5,),
          //         const SpinKitDoubleBounce(color: primary,size: 32,)
          // ],)
          
          ],
        ),
      ),
    );
  }
}
