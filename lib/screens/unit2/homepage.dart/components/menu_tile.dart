import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unit2/model/login_data/user_info/user_data.dart';
import 'package:unit2/utils/alerts.dart';
import 'package:unit2/utils/global_context.dart';
import '../../../../theme-data.dart/colors.dart';
import '../../../../utils/global.dart';

Widget getTile(IconData icondata, String title, String route,
    BuildContext context, UserData userData) {
  return ListTile(
    dense: true,
    leading: Icon(
      icondata,
      color: primary,
    ),
    title: Text(
      title,
      style: const TextStyle(color: Colors.black),
    ),
    onTap: () async {
      if (title.toLowerCase() == "logout") {
        confirmAlert(context, () async {
          await CREDENTIALS!.clear();
          await OFFLINE!.clear();
          await CREDENTIALS!.deleteAll(['username', 'password', 'saved']);
          Navigator.pushReplacementNamed(
              NavigationService.navigatorKey.currentContext!, "/");
        }, "Logout", "Are You sure you want to logout?");
      }
      if (title.toLowerCase() == 'profile') {
        ProfileArguments profileArguments = ProfileArguments(
            token: userData.user!.login!.token!,
            userID: userData.user!.login!.user!.profileId!);
        Navigator.pushNamed(context, route, arguments: profileArguments);
      }
      if (title.toLowerCase() == 'basic info') {
        Navigator.pushNamed(context, '/basic-info');
      }if(title.toLowerCase() == 'communications'){
             ProfileArguments profileArguments = ProfileArguments(
            token: userData.user!.login!.token!,
            userID: userData.user!.login!.user!.profileId!);
                    Navigator.pushNamed(context, route, arguments: profileArguments);
      }
      if (title.toLowerCase() == 'request sos') {
        Fluttertoast.showToast(msg: "This feature is not available at this moment.",gravity: ToastGravity.CENTER);
        // Navigator.pushNamed(context, '/sos');
      }
    },
  );
}

class ProfileArguments {
  final int userID;
  final String token;
  const ProfileArguments({required this.token, required this.userID});
}
