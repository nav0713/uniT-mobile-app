import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../../../../bloc/user/user_bloc.dart';
import 'menu-screen.dart';
import '../module-screen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);
  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {


  final zoomDrawerController = ZoomDrawerController();
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoggedIn) {
          return ZoomDrawer(
            controller: zoomDrawerController,
            menuScreen: MenuScreen(
              userData: state.userData,
            ),
            mainScreen: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const MainScreen()),
            style: DrawerStyle.defaultStyle,
            borderRadius: 24.0,
            showShadow: false,
            angle: -0.0,
            slideWidth: MediaQuery.of(context).size.width * .90,
            openCurve: Curves.fastOutSlowIn,
            closeCurve: Curves.easeOut,
            menuBackgroundColor: Colors.grey,
          );
        }
        return Container();
      },
    );
  }
}
