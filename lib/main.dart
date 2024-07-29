import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unit2/bloc/profile/profile_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/model/login_data/user_info/module.dart';
import 'package:unit2/model/login_data/user_info/module_object.dart';
import 'package:unit2/model/offline/offlane_modules.dart';
import 'package:unit2/model/offline/offline_profile.dart';
import 'package:unit2/utils/app_router.dart';
import 'package:unit2/utils/global_context.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import './utils/global.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDirectory = await path_provider.getApplicationDocumentsDirectory();

  await Hive.initFlutter(appDirectory.path);
  Hive.registerAdapter<OfflineProfile>(OfflineProfileAdapter());
  Hive.registerAdapter<Module>(ModuleAdapter());
  Hive.registerAdapter<ModuleObject>(ModuleObjectAdapter());
  Hive.registerAdapter<OfflineModules>(OfflineModulesAdapter());
  CREDENTIALS = await Hive.openBox<dynamic>('credentials');
  SOS = await Hive.openBox<dynamic>('soscontacts');
  OFFLINE = await Hive.openBox<dynamic>('offline');

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

// void main() => runApp(
//       DevicePreview(
//         enabled: !kReleaseMode,
//         builder: (context) => const MyApp(), // Wrap your app
//       ),
//     );

class MyApp extends StatelessWidget {
  AppRouter? _appRouter;

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _appRouter = AppRouter();
    final mediaQueryData =
        MediaQueryData.fromView(WidgetsBinding.instance.window);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    safeAreaHorizontal =
        mediaQueryData.padding.left + mediaQueryData.padding.right;
    safeAreaVertical =
        mediaQueryData.padding.top + mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - safeAreaVertical) / 100;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserBloc(),
        ),
        BlocProvider(
          create: (_) => ProfileBloc(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        // useInheritedMediaQuery: true,
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
        // routeInformationParser: goRouter.routeInformationParser,
        // routerDelegate: goRouter.routerDelegate,
        // routeInformationProvider: goRouter.routeInformationProvider,

        title: 'uniT2 - Universal Tracker and Tracer',
        theme: ThemeData(
          useMaterial3: false,
          brightness: Brightness.light,
          primarySwatch: Colors.red,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark,
                statusBarColor: Colors.black),
          ),
          fontFamily: 'LexendDeca',
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: _appRouter!.onGenerateRoute,
      ),
    );
  }
}
