import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/global.dart';

class QRFullScreenImage extends StatelessWidget {
  final String uuid;
  const QRFullScreenImage({super.key, required this.uuid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primary,title: const Text("Profile QR Code"),),
      body:    Center(
      child: Hero(
        tag: 'qr',
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: QrImageView(
                  data: uuid,
                  size: blockSizeVertical * 50
                ),
        ),
      ),
    ),);
  }
}
