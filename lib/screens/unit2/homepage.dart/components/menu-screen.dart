import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:unit2/screens/unit2/homepage.dart/components/menu_tile.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:fluttericon/web_symbols_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import '../../../../model/login_data/user_info/user_data.dart';
import '../../../../utils/global.dart';

class MenuScreen extends StatefulWidget {
  final UserData? userData;
  const MenuScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SizedBox(
        height: screenHeight,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  currentAccountPictureSize: const Size.square(90),
                  decoration: const BoxDecoration(
                      color: primary,
                      image: DecorationImage(
                          image: AssetImage('assets/pngs/bg.png'),
                          fit: BoxFit.cover)),
                  accountName: null,
                  accountEmail: null,
                  currentAccountPicture: CircleAvatar(
                    radius: 100,
                    backgroundColor: fifth,
                    child: CircleAvatar(
                        radius: 100,
                        backgroundColor: third,
                        child: CachedNetworkImage(
                            imageUrl:
                                "https://firebasestorage.googleapis.com/v0/b/return-lost-0713.appspot.com/o/capitol.png?alt=media&token=e03b2e0a-9d95-4d89-9179-6fadf106e176",placeholder: (context, url) => Text(globalCurrentProfile!.fullname[0],style: const TextStyle(fontSize: 24),),)),
                  ),
                ),
                getTile(FontAwesome5.user, "Basic Info", '/basic-info', context,
                    widget.userData!),
                const Divider(),
                getTile(FontAwesome5.user_circle, "Profile", '/profile',
                    context, widget.userData!),
                const Divider(),
                getTile(FontAwesome5.life_ring, "Request SOS", '/sos', context,
                    widget.userData!),
                const Divider(),
                getTile(Entypo.megaphone, "Communications", '/communications',
                    context, widget.userData!),
                const Divider(),
              ],
            ),
            const Expanded(child: SizedBox()),
            const Divider(),
            Align(
              alignment: FractionalOffset.bottomLeft,
              child: getTile(
                  WebSymbols.logout, "Logout", '/', context, widget.userData!),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
