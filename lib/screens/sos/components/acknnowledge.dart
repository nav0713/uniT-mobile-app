import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';

import '../../../model/sos/session.dart';
import '../../../theme-data.dart/colors.dart';
import '../../../utils/global.dart';

class SosAcknowledged extends StatelessWidget {
  final Function() onpressed;
  final SessionData sessionData;
  const SosAcknowledged({super.key, required this.onpressed, required this.sessionData});

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
                const SizedBox(
                  height: 18,
                ),
                SlideInDown(
                  child: AutoSizeText(
                    "SOS Acknowledged!",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 40,
                        color: success2,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SlideInDown(
                  child: const Icon(
                    Iconic.ok_circle,
                    color: success2,
                    size: 120,
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                SlideInUp(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Column(
                      children: [
    
                        
                        ListTile(
                          title: AutoSizeText(
                            sessionData.acknowledgedBy!.toUpperCase(),
                            maxLines: 2,
                            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: third),
                          ),
                          subtitle: Text(
                            "Acknowledge by",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            "NOTE: Please ensure that the mobile numbers you provided are still active, and look for an area with stable network. The response team will contact your mobile number.",
                            textAlign: TextAlign.justify,
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(child: Container()),
                SlideInUp(
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                        style:
                            mainBtnStyle(second, Colors.transparent, Colors.white54),
                        onPressed: onpressed,
                        child: const Text("DONE!")),
                  ),
                )
              ],
            ),
          ],
        ),
    );
  }
}