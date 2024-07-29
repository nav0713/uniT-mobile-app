
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/utils/global_context.dart';
import 'package:unit2/utils/internet_time_out.dart';
import 'package:unit2/widgets/progress_hud.dart';
import 'package:unit2/widgets/wave.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../theme-data.dart/colors.dart';
import '../../../theme-data.dart/form-style.dart';
import '../../../utils/alerts.dart';
import '../../../utils/global.dart';
import '../../../utils/text_container.dart';
import '../../../utils/validators.dart';
import '../../../widgets/error_state.dart';

class QRLogin extends StatefulWidget {
  const QRLogin({super.key});

  @override
  State<QRLogin> createState() => _QRLoginState();
}

class _QRLoginState extends State<QRLogin> {
  bool showSuffixIcon = false;
  bool _showPassword = true;
  final _formKey = GlobalKey<FormBuilderState>();
  String? password;
  @override
  Widget build(BuildContext context) {
        const secureStorage = FlutterSecureStorage();
    return WillPopScope(
      onWillPop: ()async{
       Navigator.pushReplacementNamed(context,"/");
        return true;
      },
      child: SafeArea(
        child: Scaffold(
           resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: primary,
            elevation: 0,
            title: const Text("Login via QR"),
            centerTitle: true,
          ),
          body: LoadingProgress(
            child: BlocConsumer<UserBloc, UserState>(
              listener: (context,state){
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
                      .add(LoadUuid());
                  Navigator.of(context).pop();
                });
              }
            }
              },
              builder: (context, state) {
                if (state is UuidLoaded) {
                  return Stack(
                    children: [
                      Positioned(
                          bottom: 0,
                          child: WaveReverse(height: blockSizeVertical * 8)),
                      Container(
                        height: screenHeight * .90,
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: FormBuilder(
                          key: _formKey,
                          child: Column(
                        
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Gap(screenHeight *.10),
                              SvgPicture.asset(
                                'assets/svgs/logo.svg',
                                height: blockSizeVertical * 12,
                                allowDrawingOutsideViewBox: true,
                                
                                color: primary,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(unitApp,
                                  style: TextStyle(
                                      fontSize: blockSizeVertical * 5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: .2,
                                      height: 1,
                                      color: Colors.black87)),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Enter your password",
                                style: TextStyle(
                                    fontSize: blockSizeVertical * 1.5,
                                    height: 1.5,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              // Password
                              FormBuilderTextField(
                                name: 'password',
                                validator: registerPasswordValidator,
                                // initialValue: state.password,
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
                                decoration: loginTextFieldStyle().copyWith(
                                    suffixIcon: Visibility(
                                      visible: showSuffixIcon,
                                      child: _showPassword
                                          ? IconButton(
                                              icon: Icon(FontAwesome5.eye_slash,
                                                  size: 24,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge
                                                      ?.color),
                                              onPressed: () {
                                                setState(() {
                                                  _showPassword = false;
                                                });
                                              },
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _showPassword = true;
                                                });
                                              },
                                              icon: Icon(FontAwesome5.eye,
                                                  size: 24,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge
                                                      ?.color)),
                                    ),
                                    prefixIcon: const Icon(Icons.lock),
                                    labelText: "Password",
                                    hintText: enterPassword),
                                obscureText: _showPassword ? true : false,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: blockSizeVertical * 8,
                                child: ElevatedButton(
                                    style: mainBtnStyle(
                                     second,
                                              Colors.transparent,
                                              Colors.white54),
                                    onPressed: () {
                                      if (_formKey.currentState!
                                          .saveAndValidate()) {
                                            password = _formKey.currentState!.value['password'];
                                                final progress =
                                            ProgressHUD.of(context);
                                             progress?.showWithText(
                                            'Logging in...',
                                          );
                                        context.read<UserBloc>().add(UuidLogin(uuid: state.uuid,password: _formKey.currentState!.value['password']));
                              
                                      }
                                    },
                                    child: const Text("LOGIN")),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }    if (state is InternetTimeout) {
            return SomethingWentWrong(message: state.message, onpressed: () {
                  context
                      .read<UserBloc>()
                      .add(LoadUuid());
                  Navigator.of(context).pop();
                },);
            }if (state is InternetTimeout) {
              return const TimeOutError();
            }
        
        
         
            if(state is LoginErrorState){
              return SomethingWentWrong(message: state.message, onpressed: () {
                  context
                      .read<UserBloc>()
                      .add(LoadUuid());
                  Navigator.of(context).pop();
                },);
            }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
