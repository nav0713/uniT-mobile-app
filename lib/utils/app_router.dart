import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unit2/bloc/communication/communication_bloc.dart';
import 'package:unit2/bloc/profile/profile_bloc.dart';
import 'package:unit2/bloc/role/pass_check/pass_check_bloc.dart';
import 'package:unit2/bloc/sos/sos_bloc.dart';
import 'package:unit2/screens/communication/communication_screen.dart';
import 'package:unit2/screens/sos/index.dart';
import 'package:unit2/screens/unit2/homepage.dart/components/dashboard/dashboard.dart';
import 'package:unit2/screens/unit2/login/login.dart';
import 'package:unit2/screens/unit2/roles/rbac/rbac.dart';
import 'package:unit2/utils/global_context.dart';
import '../bloc/rbac/rbac_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../screens/profile/profile.dart';
import '../screens/unit2/basic-info/basic-info.dart';
import '../screens/unit2/homepage.dart/components/drawer-screen.dart';
import '../screens/unit2/homepage.dart/components/menu_tile.dart';
import '../screens/unit2/login/qr_login.dart';
import '../screens/unit2/roles/qr_code_scanner.dart/settings_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        BlocProvider.of<UserBloc>(
                NavigationService.navigatorKey.currentContext!)
            .add(GetApkVersion(username: "", password: ""));
        return MaterialPageRoute(builder: (_) {
          return const UniT2Login();
        });
      case '/module-screen':
        // BlocProvider.of<UserBloc>( NavigationService.navigatorKey.currentContext!).add(LoadLoggedInUser());
        return MaterialPageRoute(builder: (_) {
          return const DrawerScreen();
        });
      case '/basic-info':
        return MaterialPageRoute(builder: (_) {
          return const BasicInfo();
        });
      case '/qr-login':
        return MaterialPageRoute(builder: (_) {
          return const QRLogin();
        });
      case '/profile':
        ProfileArguments arguments =
            routeSettings.arguments as ProfileArguments;
        BlocProvider.of<ProfileBloc>(
                NavigationService.navigatorKey.currentContext!)
            .add(LoadProfile(token: arguments.token, userID: arguments.userID));
        return MaterialPageRoute(builder: (_) {
          return const ProfileInfo();
        });
      case '/sos':
        return MaterialPageRoute(builder: (BuildContext context) {
          return BlocProvider(
            create: (_) => SosBloc()..add(LoadUserLocation()),
            child: const SosScreen(),
          );
        });
      case '/pass-check':
        PassCheckArguments arguments =
            routeSettings.arguments as PassCheckArguments;
        return MaterialPageRoute(builder: (BuildContext context) {
          return BlocProvider(
            create: (context) => PassCheckBloc()
              ..add(GetPassCheckAreas(
                  roleIdRoleName: RoleIdRoleName(
                      roleId: arguments.roleIdRoleName.roleId,
                      roleName: arguments.roleIdRoleName.roleName),
                  userId: arguments.userId)),
            child: QRCodeScannerSettings(
              roleIdRoleName: arguments.roleIdRoleName,
              userId: arguments.userId,
            ),
          );
        });

      // BlocProvider.of<UserBloc>( NavigationService.navigatorKey.currentContext!).add(LoadLoggedInUser());
      // return MaterialPageRoute(builder: (_) {
      //   return const PassoHome();
      // });
      case '/rbac':
        return MaterialPageRoute(builder: (BuildContext context) {
          return BlocProvider(
            create: (_) => RbacBloc()..add(SetRbacScreen()),
            child: const RBACScreen(),
          );
        });
      case '/communications':
        ProfileArguments arguments =
            routeSettings.arguments as ProfileArguments;
        return MaterialPageRoute(builder: (BuildContext context){
          return BlocProvider(
            create: (context) => CommunicationBloc()..add(GetAllMessages(profileId: arguments.userID, token: arguments.token, page: 1)),
            child: const CommunicationsScreen(),
          );
        });
      default:
        return MaterialPageRoute(builder: (context) {
          return Container();
        });
    }
  }
}
