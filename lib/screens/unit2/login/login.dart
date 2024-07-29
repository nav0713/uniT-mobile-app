import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:unit2/screens/unit2/login/components/update_required.dart';
import 'package:unit2/screens/unit2/login/qr_login.dart';
import 'package:unit2/utils/alerts.dart';
import 'package:unit2/utils/internet_time_out.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../utils/global_context.dart';
import '../../../widgets/splash_screen.dart';
import '../../../widgets/wave.dart';
import '../../../utils/global.dart';
import '../../../theme-data.dart/colors.dart';
import '../../../theme-data.dart/form-style.dart';
import '../../../theme-data.dart/btn-style.dart';
import './components/login-via-qr-label.dart';

class UniT2Login extends StatefulWidget {
  const UniT2Login({super.key});

  @override
  State<UniT2Login> createState() => _UniT2LoginState();
}

class _UniT2LoginState extends State<UniT2Login> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool showSuffixIcon = false;
  bool _showPassword = true;
  String? password;
  String? username;
  DateTime? ctime;
  @override
  Widget build(BuildContext context) {
    const secureStorage = FlutterSecureStorage();
    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();
        if (ctime == null ||
            now.difference(ctime!) > const Duration(seconds: 2)) {
          ctime = now;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
            'Press Again to Exit',
            textAlign: TextAlign.center,
          )));
          return Future.value(false);
        }

        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: LoadingProgress(
          child: BlocConsumer<UserBloc, UserState>(listener: (context, state) {
            if (state is UserLoggedIn ||
                state is UuidLoaded ||
                state is LoginErrorState) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }
            if (state is UserLoggedIn) {
              if (state.success == true) {
                if (!state.savedCredentials!) {
                  confirmAlertWithCancel(context, () async {
                    final encryptionKey = await secureStorage.read(key: 'key');
                    try {
                      if (encryptionKey == null) {
                        final key = Hive.generateSecureKey();
                        await secureStorage.write(
                            key: 'key', value: base64UrlEncode(key));
                      }
                      final key = await secureStorage.read(key: 'key');
                      final encryptionKeyUint8List = base64Url.decode(key!);
                      final encryptedBox = await Hive.openBox('vaultBox',
                          encryptionCipher:
                              HiveAesCipher(encryptionKeyUint8List));
                      encryptedBox.put('username',
                          state.userData!.user!.login!.user!.username!);
                      encryptedBox.put('password', password);
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                    await CREDENTIALS?.put('saved', "saved");
                    Fluttertoast.showToast(
                      msg: "Credentials Successfully saved",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black,
                    );
                    Navigator.pushReplacementNamed(
                        NavigationService.navigatorKey.currentContext!,
                        '/module-screen');
                  },
                      () => Navigator.pushReplacementNamed(
                          context, '/module-screen'),
                      "Save credentials?",
                      "Do you want to save your credentials so, you don't have to login again next time?.");
                } else {
                  Navigator.pushReplacementNamed(context, '/module-screen');
                }
              } else {
                final progress = ProgressHUD.of(context);
                progress!.dismiss();
                errorAlert(context, "Error Login", state.message, () {
                  context
                      .read<UserBloc>()
                      .add(LoadVersion(username: username, password: password));
                  Navigator.of(context).pop();
                });
              }
            }
            if (state is UuidLoaded) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return const QRLogin();
              }));
            }
          }, builder: (context, state) {
            if (state is VersionLoaded) {
              return Builder(builder: (context) {
                if (state.versionInfo?.id == state.apkVersion) {
                  return SizedBox(
                    height: blockSizeVertical * 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: blockSizeVertical * 100,
                          child: FormBuilder(
                            key: _formKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 42),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SlideInUp(
                                    from: 100,
                                    duration: const Duration(milliseconds: 300),
                                    child: SvgPicture.asset(
                                      'assets/svgs/logo.svg',
                                      height: blockSizeVertical * 12,
                                      allowDrawingOutsideViewBox: true,
                                      color: primary,
                                    ),
                                  ),

                                  SlideInUp(
                                    from: 120,
                                    duration: const Duration(milliseconds: 400),
                                    child: Text(
                                      welcome,
                                      style: TextStyle(
                                          fontSize: blockSizeVertical * 4,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SlideInUp(
                                    from: 140,
                                    duration: const Duration(milliseconds: 500),
                                    child: Text(unitApp,
                                        style: TextStyle(
                                            fontSize: blockSizeVertical * 6,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: .2,
                                            height: 1,
                                            color: primary)),
                                  ),

                                  Gap(
                                    blockSizeVertical * 3,
                                  ),
                                  //// USERNAME
                                  SlideInLeft(
                                    from: 100,
                                    duration: const Duration(milliseconds: 500),
                                    child: FormBuilderTextField(
                                        name: 'username',
                                        initialValue: state.username,
                                        validator:
                                            FormBuilderValidators.required(
                                                errorText: usernameRequired),
                                        autofocus: false,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                        decoration:
                                            loginTextFieldStyle().copyWith()),
                                  ),
                                  Gap(
                                    blockSizeVertical * 1.5,
                                  ),
                                  //// PASSWORD
                                  SlideInLeft(
                                    from: 100,
                                    duration: const Duration(milliseconds: 500),
                                    child: FormBuilderTextField(
                                      name: 'password',
                                      initialValue: state.password,
                                      validator: FormBuilderValidators.required(
                                          errorText: passwordRequired),
                                      onChanged: (value) {
                                        value!.isEmpty
                                            ? setState(() {
                                                showSuffixIcon = false;
                                              })
                                            : setState(() {
                                                showSuffixIcon = true;
                                              });
                                      },
                                      autofocus: false,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                      decoration:
                                          loginTextFieldStyle().copyWith(
                                              suffixIcon: Visibility(
                                                visible: showSuffixIcon,
                                                child: _showPassword
                                                    ? IconButton(
                                                        icon: Icon(
                                                            FontAwesome5
                                                                .eye_slash,
                                                            size: 24,
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .displayLarge
                                                                ?.color),
                                                        onPressed: () {
                                                          setState(() {
                                                            _showPassword =
                                                                false;
                                                          });
                                                        },
                                                      )
                                                    : IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _showPassword =
                                                                true;
                                                          });
                                                        },
                                                        icon: Icon(
                                                            FontAwesome5.eye,
                                                            size: 24,
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .displayLarge
                                                                ?.color)),
                                              ),
                                              prefixIcon: const Icon(
                                                Icons.lock,
                                                color: primary,
                                              ),
                                              labelText: "Password",
                                              hintText: enterPassword),
                                      obscureText: _showPassword ? true : false,
                                    ),
                                  ),
                                  Gap(
                                    blockSizeVertical * 2,
                                  ),
                                  SlideInLeft(
                                    from: 100,
                                    duration: const Duration(milliseconds: 500),
                                    child: SizedBox(
                                      height: blockSizeVertical * 7,
                                      //// Login Button
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ElevatedButton(
                                          style: mainBtnStyle(
                                              second,
                                              Colors.transparent,
                                              Colors.white54),
                                          child: const Text(
                                            login,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            final progress =
                                                ProgressHUD.of(context);
                                            FocusScope.of(context).unfocus();
                                            if (_formKey.currentState!
                                                .saveAndValidate()) {
                                              password = _formKey.currentState!
                                                  .value['password'];
                                              username = _formKey.currentState!
                                                  .value['username'];
                                              progress?.showWithText(
                                                'Logging in...',
                                              );
                                              BlocProvider.of<UserBloc>(context)
                                                  .add(UserLogin(
                                                      username: username,
                                                      password: password));
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Gap(
                                    blockSizeVertical * 1.5,
                                  ),
//// Login via Scan QR
                                  SlideInLeft(
                                    from: 100,
                                    duration: const Duration(milliseconds: 500),
                                    child: SizedBox(
                                        height: blockSizeVertical * 7,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ElevatedButton.icon(
                                            style: mainBtnStyle(
                                                Colors.white,
                                                second,
                                                primary.withOpacity(.4)),
                                            icon: const Icon(
                                              Icons.qr_code,
                                              color: second,
                                            ),
                                            label: const Text(
                                              loginViaQr,
                                              style: TextStyle(color: second),
                                            ),
                                            onPressed: () {
                                              context
                                                  .read<UserBloc>()
                                                  .add(GetUuid());
                                            },
                                          ),
                                        )),
                                  ),
                                  Gap(
                                    blockSizeVertical * 2,
                                  ),
                                  SlideInUp(
                                    from: 250,
                                    duration: const Duration(milliseconds: 600),
                                    child: const LoginViaQr(
                                        text: emergencyReponseLabel),
                                  ),
                                  Gap(
                                    blockSizeVertical * 2,
                                  ),
                                  // REQUEST SOS
                                  FadeInUpBig(
                                    delay: const Duration(milliseconds: 300),
                                    
                                    from: 100,
                                    duration: const Duration(milliseconds: 700),
                                    child: SizedBox(
                                      height: screenHeight * .07,
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton.icon(
                                          icon: const Icon(
                                            FontAwesome5.life_ring,
                                            color: Colors.white,
                                          ),
                                          style: mainBtnStyle(
                                              third,
                                              Colors.transparent,
                                              Colors.white38),
                                          onPressed: () {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "This feature is not available at this moment.",
                                                gravity: ToastGravity.CENTER);
                                            // Navigator.pushNamed(
                                            //     context, '/sos');
                                          },
                                          label: const Text(
                                            requestSOS,
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          bottom: 0,
                          child: WaveReverse(height: 57),
                        )
                      ],
                    ),
                  );
                } else {
                  //New update available
                  return Update(
                    apkVersion: state.apkVersion!,
                    versionInfo: state.versionInfo!,
                  );
                }
              });
            }
            if (state is UserError) {
              return SomethingWentWrong(
                message: onError,
                onpressed: () {
                  BlocProvider.of<UserBloc>(
                          NavigationService.navigatorKey.currentContext!)
                      .add(GetApkVersion(
                          username: username, password: password));
                  return MaterialPageRoute(builder: (_) {
                    return const UniT2Login();
                  });
                },
              );
            }

            if (state is InternetTimeout) {
              return const TimeOutError();
            }
            if (state is SplashScreen) {
              return const UniTSplashScreen();
            }
            if (state is LoginErrorState) {
              return SomethingWentWrong(
                message: state.message,
                onpressed: () {
                  BlocProvider.of<UserBloc>(
                          NavigationService.navigatorKey.currentContext!)
                      .add(GetApkVersion(
                          username: username, password: password));
                  return MaterialPageRoute(builder: (_) {
                    return const UniT2Login();
                  });
                },
              );
            }
            return Container();
          }),
        ),
      ),
    );
  }
}
