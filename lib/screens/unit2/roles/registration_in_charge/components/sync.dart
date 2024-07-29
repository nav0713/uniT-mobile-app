import 'package:flutter/material.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:unit2/widgets/label.dart';

import '../../../../../theme-data.dart/btn-style.dart';
import '../../../../../theme-data.dart/colors.dart';
import '../../../../../utils/global.dart';
import '../../../../../utils/text_container.dart';

class SyncData extends StatefulWidget {
  const SyncData({super.key});

  @override
  State<SyncData> createState() => _SyncDataState();
}

class _SyncDataState extends State<SyncData> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Label(text: syncTitle),
          Icon(
            Octicons.sync_icon,
            size: blockSizeVertical * 25,
            color: success2,
          ),
          Column(
            children: [
              const Text(syncSubTittle),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: screenHeight * .06,
                child: ElevatedButton(
                  style: secondaryBtnStyle(
                      second, Colors.transparent, Colors.white54),
                  child: const Text(
                    syncNow,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
