import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../../theme-data.dart/box_shadow.dart';
import '../../../theme-data.dart/btn-style.dart';
import '../../../theme-data.dart/colors.dart';
import '../../../theme-data.dart/form-style.dart';
import '../../../utils/formatters.dart';

class EmptyWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function()? onpressed;
  final String title;
  const EmptyWidget(
      {super.key,
      required this.controller,
      required this.onpressed,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Container(
        decoration: box1(),
        width: double.maxFinite,
        height: 100,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text("No result found..."),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    ////ADD POSITION DIALOG
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(title),
                            content: SizedBox(
                              height: 130,
                              child: Column(
                                children: [
                                  TextFormField(
                                    inputFormatters: [UpperCaseTextFormatter()],
                                    controller: controller,
                                    decoration: normalTextFieldStyle("", ""),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                          style: mainBtnStyle(primary,
                                              Colors.transparent, second),
                                          onPressed: onpressed,
                                          child: const Text("Add"))),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Text(title))
            ]),
      ),
    );
  }
}
