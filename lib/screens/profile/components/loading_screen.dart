
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/brandico_icons.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:unit2/screens/profile/components/main_menu.dart';
import 'package:unit2/screens/profile/components/submenu.dart';
import 'package:unit2/utils/global.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../theme-data.dart/colors.dart';
import 'dart:io' show Platform;
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: ListView(
            children: [
              const Text(
                "View and Update your Profile Information",
                textAlign: TextAlign.center,
              ),
                 MainMenu(
                icon:                   Elusive.address_book,
                title: "Basic Information",
                onTap: () {},
              ),
      
              const Divider(),
              MainMenu(
                icon: Elusive.group,
                title: "Family",
                onTap: () {},
              ),
              const Divider(),
              MainMenu(
                icon: FontAwesome5.graduation_cap,
                title: "Education",
                onTap: () {},
              ),
              const Divider(),
              MainMenu(
                icon: Icons.stars,
                title: "Eligibility",
                onTap: () {},
              ),
              const Divider(),
              MainMenu(
                icon: FontAwesome5.shopping_bag,
                title: "Work History",
                onTap: () {},
              ),
              const Divider(),
              MainMenu(
                icon: FontAwesome5.walking,
                title: "Voluntary Work & Civic Services",
                onTap: () {},
              ),
              const Divider(),
              MainMenu(
                icon: Elusive.lightbulb,
                title: "Learning & Development",
                onTap: () {},
              ),
              const Divider(),
              MainMenu(
                icon: Brandico.codepen,
                title: "Personal References",
                onTap: () {},
              ),
                MainMenu(
                icon:            Icons.info,
                title: "Other Information",
                onTap: () {},
              ),
           MainMenu(
                icon:             FontAwesome5.laptop_house,
                title: "Assets",
                onTap: () {},
              ),
   
            ],
          ),
        ),
        Container(
          width: screenWidth,
          height: screenHeight,
          color: Colors.white70,
        ),
        Center(
          child: Container(
            height: 120,
            width: 120,
            decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               SizedBox(child: Platform.isAndroid?const SpinKitFadingCircle(size: 42, color: Colors.white): const CupertinoActivityIndicator(radius: 14,color: Colors.white,),) ,
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "Please wait..",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
