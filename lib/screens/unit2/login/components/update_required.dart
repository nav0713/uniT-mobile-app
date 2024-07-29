import 'dart:async';
import 'dart:io';

import 'package:better_open_file/better_open_file.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy_app_installer/easy_app_installer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unit2/model/login_data/version_info.dart';
import 'package:unit2/screens/unit2/login/components/showAlert.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/utils/global_context.dart';
import 'package:unit2/widgets/progress_hud.dart';
import '../../../../bloc/user/user_bloc.dart';
import '../../../../theme-data.dart/colors.dart';
import '../../../../widgets/wave.dart';
class Update extends StatefulWidget {
  final String apkVersion;
  final VersionInfo versionInfo;
  const Update(
      {super.key, required this.apkVersion, required this.versionInfo});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  String progressRating = '0';
  bool downloading = false;
  bool isDownloaded = false;
  bool asyncCall = false;
  Dio dio = Dio();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(children: [
        BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is VersionLoaded) {
              return LoadingProgress(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 25),
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svgs/download.svg',
                              height: 200.0,
                              width: 200.0,
                              allowDrawingOutsideViewBox: true,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("UPDATE REQUIRED!",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: primary, fontSize: 28)),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                                text: 'Your app version ',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: widget.apkVersion,
                                      style: const TextStyle(
                                          color: primary,
                                          fontWeight: FontWeight.bold)),
                                  const TextSpan(
                                      text:
                                          " did not match with the latest version ",
                                      style: TextStyle(color: Colors.black)),
                                  TextSpan(
                                      text: widget.versionInfo.versionInfo,
                                      style: const TextStyle(
                                          color: primary,
                                          fontWeight: FontWeight.bold)),
                                  const TextSpan(
                                      text:
                                          ". Download the app latest version to procceed using the uniT-App.",
                                      style: TextStyle(color: Colors.black)),
                                ])),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          child: downloading
                              ? FittedBox(
                                child: Text(
                                    'Downloading application $progressRating%',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Container(),
                        ),
                        SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          child: downloading
                              ? Container()
                              : ElevatedButton.icon(
                                  icon:  Platform.isAndroid? const Icon(FontAwesome5.android):const Icon(FontAwesome5.app_store_ios),
                                  style: mainBtnStyle(
                                      primary, Colors.transparent, second),
                                   onPressed: () async {
                                     if(Platform.isAndroid){
                                           setState(() {
                                            downloading = true;
                                            progressRating = '0';
                                          });
                                          try {
                                            await openFile();
                                          } catch (e) {
                                            showAlert(NavigationService.navigatorKey.currentContext, () {
                                              setState(() {
                                                downloading = false;
                                                progressRating = '0';
                                              });
                                            });
                                          }
                                     }else{
////Code for ios

                                     }
                                        },
                                  label: const Text(
                                      "Download Latest App Version.")),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            if (state is UserError) {
              showAlert(context, () {
                setState(() {
                  downloading = false;
                });
              });
            }
            return Container();
          },
        ),
         Positioned(bottom: 0, child: Platform.isAndroid?const WaveReverse(height: 80):const SizedBox())
      ]),
    );
  }

  Future<void> openFile() async {
    try {
      final filePath = await downloadFile();
      await OpenFile.open(filePath);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> openAPK(String path) async {
    PermissionStatus result = await Permission.storage.request();
    if (result.isGranted) {
      await EasyAppInstaller.instance.installApk(path);
    }
  }


  Future<String> getCPUArchitecture() async {
    String downloadURL = "";
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    try{
List<String> cpuArchitecture = androidDeviceInfo.supportedAbis;
    if (cpuArchitecture.first == 'arm64-v8a') {
      downloadURL = widget.versionInfo.arm64v8aDownloadUrl!;
    }
    else if (cpuArchitecture.first == 'armeabi-v7a') {
      downloadURL = widget.versionInfo.armeabiv7aDownloadUrl!;
    } else {
      downloadURL = widget.versionInfo.x8664DownloadUrl!;
    }
    print(downloadURL);
    }catch(e){
      throw e.toString();
    }
        return downloadURL;
  }

  Future<String?> downloadFile() async {
    final appStorage = await getApplicationDocumentsDirectory();
    String? appDir;
    try {
      String url = await getCPUArchitecture();
      final response = await dio.download(url, '${appStorage.path}/uniT.apk',
          deleteOnError: true,
          options: Options(
              receiveDataWhenStatusError: true,
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              }), onReceiveProgress: (recv, total) {
        setState(() {
          progressRating = ((recv / total) * 100).toStringAsFixed(0);
          downloading = true;
        });
        if (progressRating == '100') {
          setState(() {
            downloading = false;
            isDownloaded = true;
          });
        }
        appDir = '${appStorage.path}/uniT.apk';
      });
    } on TimeoutException catch (e) {
      throw e.toString();
    } on SocketException catch (e) {
      throw e.toString();
    } on Error catch (e) {
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }

    return appDir!;
  }
  
}
