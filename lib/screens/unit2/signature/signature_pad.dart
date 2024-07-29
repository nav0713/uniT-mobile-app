import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:unit2/theme-data.dart/colors.dart';

class SignaturePad extends StatefulWidget {
  const SignaturePad({super.key});

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  SignatureController? _signatureController;

  @override
  void initState() {
    _signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black87,
    );
    super.initState();
  }

  @override
  void dispose() {
    _signatureController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Signature"),
        centerTitle: true,
        backgroundColor: primary,
        automaticallyImplyLeading: true,
      ),
      body: Signature(
        controller: _signatureController!,
        backgroundColor: Colors.white,
      ),
    );
  }
}
