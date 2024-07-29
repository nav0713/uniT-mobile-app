import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:unit2/screens/unit2/roles/registration_in_charge/components/add.dart';
import 'package:unit2/screens/unit2/roles/registration_in_charge/components/request_qr.dart';
import 'package:unit2/screens/unit2/roles/registration_in_charge/components/sync.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/text_container.dart';

import 'components/view.dart';

class RegistrationInCharge extends StatefulWidget {
  const RegistrationInCharge({super.key});

  @override
  State<RegistrationInCharge> createState() => _RegistrationInChargeState();
}

class _RegistrationInChargeState extends State<RegistrationInCharge> {
  final List<Widget> _pages = [
    const ViewList(),
    const AddPerson(),
    const SyncData(),
    const RequestQR()
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(registrationInChargeTitle),
        backgroundColor: second,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            // ##SEARCH BUTTON
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              // Navigator.pushNamed(context, '/Registration Search');
            },
          ),
          PopupMenuButton(
              onSelected: (value) {
                // SORT VIA DATE ADDED
                if (value == 1) {
                }
                // SORT VIA LAST NAME
                else if (value == 2) {}
              },
              itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: <Widget>[Text('Sort By Date Added')],
                        )),
                    const PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: <Widget>[Text('Sort by Lastname')],
                        )),
                  ]),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
          color: Colors.white70,
          gradient: primaryGradient(),
          style: TabStyle.react,
          items: const [
            TabItem(icon: Entypo.home, title: "Home"),
            TabItem(icon: Iconic.plus_circle, title: "Add"),
            TabItem(icon: Iconic.loop, title: "Sync"),
            TabItem(icon: FontAwesome.qrcode, title: "Request QR"),
          ],
          initialActiveIndex: 0,
          onTap: (int i) {
            setState(() {
              currentIndex = i;
            });
          }),
      body: _pages[currentIndex],
    );
  }
}
