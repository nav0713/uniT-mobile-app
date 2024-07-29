import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CitizenshipLoading extends StatelessWidget {
  const CitizenshipLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:    Center(
          child: Container(
            height: 120,
            width: 120,
            decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpinKitFadingCircle(size: 42, color: Colors.white),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Please wait..",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
    );
  }
}