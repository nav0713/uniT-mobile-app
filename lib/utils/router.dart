// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:unit2/bloc/bloc/user_bloc.dart';
// import 'package:unit2/model/login_data/user_info/user_data.dart';
// import 'package:unit2/screens/unit2/login/qr_login.dart';
// import 'package:unit2/screens/unit2/roles/qr_code_scanner.dart/scan.dart';
// import 'package:unit2/screens/unit2/roles/qr_code_scanner.dart/settings_screen.dart';
// import 'package:unit2/screens/unit2/signature/signature_pad.dart';
// import 'package:unit2/utils/global_context.dart';
// import 'package:unit2/utils/scanner.dart';
// import '../screens/docsms/components/doc_info_tile.dart';
// import '../screens/docsms/request_receipt.dart';
// import '../screens/sos/add_mobile.dart';
// import '../screens/sos/request_sos.dart';
// import '../screens/unit2/login/login.dart';
// import '../screens/unit2/homepage.dart/components/drawer-screen.dart';
// import '../screens/unit2/profile/profile.dart';
// import '../screens/unit2/roles/registration_in_charge/home.dart';

// final GoRouter goRouter = GoRouter(routes: <GoRoute>[
//   GoRoute(
//       path: '/',
//       name: 'login',
//       builder: (context, state) {
//         return BlocProvider(
//           create: (context) => UserBloc()..add(GetApkVersion()),
//           child: const UniT2Login(),
//         );
//       },
//       routes: [
//         // GoRoute(
//         //     name: 'qr-login',
//         //     path: 'qr-login',
//         //     builder: ((context, state) => const QRLogin())),
//         GoRoute(
//             name: 'home',
//             path: 'home',
//             builder: (context, state) {
//               UserData userData = state.extra as UserData;
//               return BlocProvider<UserBloc>.value(
//                 value: UserBloc()..add((LoadLoggedInUser(userData: userData))),
//                 child: const DrawerScreen(),
//               );
//             },
//             routes: [
//               GoRoute(
//                   name: 'profile',
//                   path: 'profile',
//                   builder: (context, state) {
//                     UserData userData = state.extra as UserData;
//                     return BlocProvider<UserBloc>.value(
//                       value: UserBloc()
//                         ..add((LoadLoggedInUser(userData: userData))),
//                       child: const Profile(),
//                     );
//                   },
//                   routes: [
//                     GoRoute(
//                       name: 'signature',
//                       path: 'signature',
//                       builder: (context, state) => const SignaturePad(),
//                     )
//                   ])
//             ]),
//         GoRoute(
//             name: 'add-mobile',
//             path: 'add-moble',
//             builder: (context, state) => AddMobile(),
//             routes: [
//               GoRoute(
//                 name: 'request-sos',
//                 path: 'request-sos',
//                 builder: (context, state) => const RequestSOS(),
//               )
//             ]),
//       ]),
// ]);
