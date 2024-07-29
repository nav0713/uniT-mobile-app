import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:unit2/model/login_data/user_info/user_data.dart';
import 'package:unit2/screens/unit2/basic-info/components/qr_image.dart';
import 'package:http/http.dart' as http;
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/request.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/progress_hud.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../theme-data.dart/colors.dart';
import '../../../utils/urls.dart';
import '../../../widgets/splash_screen.dart';
import '../signature/signature_pad.dart';
import './components/cover-image.dart';

String? personUuid;

class BasicInfo extends StatefulWidget {
  const BasicInfo({super.key});

  @override
  State<BasicInfo> createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  @override
  Widget build(BuildContext context) {
    String? token;
    return PopScope(
      canPop: true,
      child: LoadingProgress(
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoggedIn) {
              token = state.userData!.user!.login!.token!;
              String? fileUrl;
              if (state.userData?.profile?.photoPath != null) {
                fileUrl =
                    '${Url.instance.prefixHost()}://${Url.instance.host()}/media/${state.userData?.profile?.photoPath}';
              }
              fileUrl = null;

              return SafeArea(
                child: Scaffold(
                  body: SizedBox(
                    width: screenWidth,
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            const CoverImage(),
                            Positioned(
                              top: blockSizeVertical * 15.5,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  FadeInDown(
                                    child: Container(
                                      child: fileUrl == null
                                          ? Container(
                                              width: 160,
                                              height: 160,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 3),
                                                shape: BoxShape.circle,
                                              ),
                                              child: globalCurrentProfile!.sex!
                                                          .toLowerCase() ==
                                                      "male"
                                                  ? SvgPicture.asset(
                                                      'assets/svgs/male.svg',
                                                    )
                                                  : SvgPicture.asset(
                                                      'assets/svgs/female.svg',
                                                    ))
                                          : CachedNetworkImage(
                                              imageUrl: fileUrl,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: 160,
                                                height: 160,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black26,
                                                      width: 3),
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Container(
                                                      width: 160,
                                                      height: 160,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 3),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: globalCurrentProfile!
                                                                  .sex!
                                                                  .toLowerCase() ==
                                                              "male"
                                                          ? SvgPicture.asset(
                                                              'assets/svgs/male.svg',
                                                            )
                                                          : SvgPicture.asset(
                                                              'assets/svgs/female.svg',
                                                            )),
                                            ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                                top: 10,
                                left: 20,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    FontAwesome5.arrow_left,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                )),
                            Positioned(
                                top: 10,
                                right: 20,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: blockSizeVertical * 5,
                        ),
                        BuildInformation(
                          userData: state.userData!,
                          token: token!,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const UniTSplashScreen();
          },
        ),
      ),
    );
  }
}

class BuildInformation extends StatelessWidget {
  final String token;
  final UserData userData;
  const BuildInformation(
      {super.key, required this.userData, required this.token});
  @override
  Widget build(BuildContext context) {
    DateFormat dteFormat2 = DateFormat.yMMMMd('en_US');
    String? uuid = globalCurrentProfile?.uuidQrcode;
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        width: screenWidth,
        child: Column(
          children: [
            const SizedBox(
              height: 49,
            ),
            FadeInLeft(
              from: 50,
              delay: const Duration(milliseconds: 100),
              child: Text(
                globalCurrentProfile!.fullname,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const Gap(20),
            FadeInRight(
              from: 50,
              delay: const Duration(milliseconds: 300),
              child: Text(
                "${dteFormat2.format(globalCurrentProfile!.birthdate!)} | ${globalCurrentProfile!.sex}",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 18),
              ),
            ),
            SizedBox(
              height: uuid == null ? 20 : 15,
            ),
            FadeInUp(
              from: 50,
              delay: const Duration(milliseconds: 500),
              child: Container(
                child: uuid == null
                    ? SizedBox(
                        width: screenWidth * .60,
                        height: blockSizeVertical * 24,
                        child: GestureDetector(
                          onTap: () async {
                            String? personUuid = await generateUUID(
                                profileId: globalCurrentProfile!.id!,
                                token: token);
                            setState(() {
                              if (personUuid == null) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Error Generating QR Code. Please try again!",
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white);
                              } else {
                                uuid = personUuid;
                                globalCurrentProfile?.uuidQrcode = personUuid;
                              }
                            });
                          },
                          child: Container(
                            height: 400,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15))),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.qr_code_2,
                                    color: Colors.black54,
                                    size: 100,
                                  ),
                                  Gap(10),
                                  Text(
                                    "click here to generate your QR code",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return QRFullScreenImage(uuid: uuid!);
                          }));
                        },
                        child: Hero(
                          tag: 'qr',
                          child: QrImageView(
                            data: uuid!,
                            size: blockSizeVertical * 24,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 700),
              child: SizedBox(
                width: screenWidth * .60,
                height: blockSizeVertical * 7,
                child: SizedBox(
                  child: ElevatedButton.icon(
                      style: mainBtnStyle(
                          third, Colors.transparent, Colors.white54),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const SignaturePad();
                        }));
                      },
                      icon: const Icon(
                        FontAwesome5.signature,
                        size: 15,
                      ),
                      label: const Text(signature)),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      );
    });
  }

  Future<String?> generateUUID(
      {required int profileId, required String token}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Token $token"
    };
    String? uuid;
    try {
      http.Response response = await Request.instance.patch(
          body: {},
          param: {},
          path: '${Url.instance.generateQRCode()}$profileId',
          headers: headers);
      if (response.statusCode == 200) {
        Map body = jsonDecode(response.body);
        uuid = body['data'];
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error Generating QR Code. Please try again!",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black,
          textColor: Colors.white);
    }

    return uuid;
  }
}
