import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:unit2/model/login_data/user_info/module_object.dart';
import 'package:unit2/screens/unit2/homepage.dart/components/dashboard/dashboard.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/text_container.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../model/login_data/user_info/role.dart';
import 'components/empty_module.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Role> roles = [];
  List<DisplayCard> cards = [];
  int? userId;
     DateTime? ctime;
  @override
  Widget build(BuildContext context) {
    
       setState(() {
          cards.clear();
         cards=[];
         roles.clear();
         roles = [];
       });
    return PopScope(
      canPop: true,
      child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
        if (state is UserLoggedIn) {
          userId = state.userData!.user!.login!.user!.id;
          for (var role in state.userData!.user!.login!.user!.roles!) {
            Role? getRole = role;
            roles.add(getRole!);
          }
          for (var role in roles) {
            for (var module in role.modules!) {
              for (var object in module!.objects!) {
                DisplayCard newCard = DisplayCard(
                  roleId: role.id!,
                    moduleName: module.name!.toLowerCase(),
                    object: object!,
                    roleName: role.name!.toLowerCase());
                cards.add(newCard);
              }
            }
          }

          return WillPopScope(
                  onWillPop: () {
                DateTime now = DateTime.now();
                if (ctime == null || now.difference(ctime!) > const Duration(seconds: 2)) { 
                     //add duration of press gap
                    ctime = now;
                    ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text('Press Again to Exit',textAlign: TextAlign.center,)) 
                    ); 
                    return Future.value(false);
                }

                return Future.value(true);
             },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: primary,
                leading: IconButton(
                  onPressed: () {
                    ZoomDrawer.of(context)!.toggle();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                title: const Text(
                  unit2ModuleScreen,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
              body: state.userData!.user!.login!.user!.roles!.isNotEmpty
                  ? DashBoard(
                    estPersonAssignedArea: state.estPersonAssignedArea,
                      userId: userId!,
                      cards: cards,
                    )
                  : const NoModule(),
            ),
          );
        }
        return Container();
      }),
    );
  }
}

class DisplayCard {
  final String roleName;
  final String moduleName;
  final ModuleObject object;
  final int roleId;
  const DisplayCard(
      {required this.moduleName, required this.object, required this.roleName,required this.roleId});
}

class Module {
  final String name;
  final List<Roles> roles;
  Module({required this.name, required this.roles});
}

class Roles {
  final IconData? icon;
  final Role role;
  Roles({required this.role, required this.icon});
}
