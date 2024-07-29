import 'package:flutter/cupertino.dart';

class RequestQR extends StatefulWidget {
  const RequestQR({super.key});

  @override
  State<RequestQR> createState() => _RequestQRState();
}

class _RequestQRState extends State<RequestQR> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(child: Text("Request QR")),
    );
  }
}
