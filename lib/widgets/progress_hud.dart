import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io' show Platform;
class LoadingProgress extends StatelessWidget {
  final Widget child;
  const LoadingProgress({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      padding: const EdgeInsets.all(24),
      backgroundColor: Colors.black87,
      indicatorWidget: Platform.isAndroid? const SpinKitFadingCircle(color: Colors.white):const CupertinoActivityIndicator(radius: 14,color: Colors.white,),
      child: child,
    );
  }
}
