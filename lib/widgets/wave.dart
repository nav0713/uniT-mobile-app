import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import '../theme-data.dart/colors.dart';


class Wave extends StatelessWidget {
  final double height;
  const Wave({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
        clipper: WaveClipperOne(),
        child: Container(
          height: height,
          width: MediaQuery.of(context).size.width,
          color: primary,
        ));
  }
}

class WaveReverse extends StatelessWidget {
  final double height;
  const WaveReverse({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
        clipper: WaveClipperTwo(reverse: true),
        child: Container(
          height: height,
          width: MediaQuery.of(context).size.width,
          color: primary,
        ));
  }
}
