import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'dart:io' show Platform;
class ProgressModalHud extends StatelessWidget {
  final bool inAsyncCall;
  final Widget child;
  const ProgressModalHud({super.key,required this.child, required this.inAsyncCall});

  @override
  Widget build(BuildContext context) {
    return  ModalProgressHUD(
      progressIndicator: Platform.isAndroid? const SpinKitFadingCircle(color: Colors.black):const CupertinoActivityIndicator(radius: 14,color: Colors.white,),
      inAsyncCall: inAsyncCall,color: Colors.transparent, child: child,);
  }
}