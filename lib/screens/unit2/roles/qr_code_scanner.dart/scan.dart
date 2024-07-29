import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:unit2/bloc/role/pass_check/pass_check_bloc.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/theme-data.dart/form-style.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/utils/validators.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import '../../../../theme-data.dart/colors.dart';
import '../../../../utils/global.dart';
import 'components/save_settings.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({super.key});

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
final formKey = GlobalKey<FormBuilderState>();
AudioPlayer? player;

class _QRCodeScannerState extends State<QRCodeScanner> {
  @override
  void initState() {
    player = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text(qrScannerTitle),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: LoadingProgress(
        child: BlocConsumer<PassCheckBloc, PassCheckState>(
          listener: (context, state) {
            if (state is PassCheckLoadingState) {
              final progress = ProgressHUD.of(context);
              progress!.showWithText("Please wait...");
            }
            if (state is SettingSaved ||
                state is IncomingScanState ||
                state is OutGoingScanState ||
                state is ScanSuccess ||
                state is ScanFailed ||
                state is PassCheckErrorState || state is QRScanfailed) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }
            if (state is ScanSuccess) {
              Future.delayed(const Duration(seconds: 1), () async {
                await player?.play(AssetSource("success.mp3"));
              });
              context.read<PassCheckBloc>().add(ScanQr(token: state.token));
            }
            if (state is QRInvalid) {
              Future.delayed(const Duration(seconds: 1), () async {
                await player?.play(AssetSource("invalid.mp3"));
              });
              context.read<PassCheckBloc>().add(ScanQr(token: state.token));
            }
            if (state is ScanFailed) {
              Future.delayed(const Duration(seconds: 1), () async {
                await player?.play(AssetSource("fail.mp3"));
              });

              context.read<PassCheckBloc>().add(ScanQr(token: state.token));
            }
            if (state is IncomingScanState) {
              AwesomeDialog(
                dismissOnBackKeyPress: false,
                context: context,
                dialogType: DialogType.info,
                dismissOnTouchOutside: false,
                body: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: FormBuilder(
                      key: formKey,
                      child: Column(
                        children: [
                          const Text(
                            "Enter Temperature",
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          FormBuilderTextField(
                              keyboardType: TextInputType.number,
                              name: "temp",
                              decoration:
                                  normalTextFieldStyle("Temperature", ""),
                              validator: numericRequired),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: mainBtnStyle(
                                  primary, Colors.transparent, second),
                              child: const Text(submit),
                              onPressed: () {
                                if (formKey.currentState!.saveAndValidate()) {
                                  double temperature = double.parse(
                                      formKey.currentState!.value['temp']);
                                  context.read<PassCheckBloc>().add(
                                      PerformIncomingPostLog(
                                          temp: temperature));
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          )
                        ],
                      )),
                ),
              ).show();
            }
            if (state is OutGoingScanState) {
              AwesomeDialog(
                  dismissOnBackKeyPress: false,
                  context: context,
                  dialogType: DialogType.info,
                  dismissOnTouchOutside: false,
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    child: FormBuilder(
                        key: formKey,
                        child: Column(
                          children: [
                            const Text("Enter Destination"),
                            const SizedBox(
                              height: 24,
                            ),
                            FormBuilderTextField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                name: "destination",
                                decoration:
                                    normalTextFieldStyle("Destination", ""),
                                validator: FormBuilderValidators.required(
                                    errorText: "This field is required")),
                            const SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: mainBtnStyle(
                                    primary, Colors.transparent, second),
                                child: const Text(submit),
                                onPressed: () {
                                  if (formKey.currentState!.saveAndValidate()) {
                                    String destination = formKey
                                        .currentState!.value['destination'];
                                    context.read<PassCheckBloc>().add(
                                        PerformOutgoingPostLog(
                                            destination: destination));
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            )
                          ],
                        )),
                  )).show();
            }
          },
          builder: (context, state) {
            if (state is SettingSaved) {
              return SizedBox(
                height: screenHeight * 100,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 160,
                              child: GestureDetector(
                                  child: Image.asset('assets/pngs/qr-scan.png'),
                                  onTap: () {
                                    context
                                        .read<PassCheckBloc>()
                                        .add(ScanQr(token: state.token));
                                  })),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            tapToScanQR,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    fontSize: 22,
                                    color: primary,
                                    fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          //TODO add API data
                          state.io == "INCOMING"
                              ? SizedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        incoming,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                                fontSize: 20,
                                                color: success2,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const Icon(
                                        Entypo.down_bold,
                                        color: success2,
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "OUTGOING",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                                fontSize: 20,
                                                color: second,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const Icon(
                                        Entypo.up_bold,
                                        color: second,
                                      )
                                    ],
                                  ),
                                )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 12),
                      decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 30,
                              offset: Offset(-5, 0),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SelectedState(
                              title: state.roleIdRoleName.roleName
                                              .toLowerCase() ==
                                          "41" ||
                                      state.roleIdRoleName.roleName
                                              .toLowerCase() ==
                                          'qr code scanner' ||
                                      state.roleIdRoleName.roleName
                                              .toLowerCase() ==
                                          'office/branch chief' ||
                                      state.roleIdRoleName.roleName
                                              .toLowerCase() ==
                                          'registration in-charge'
                                  ? state.assignedArea.stationName
                                  : state.roleIdRoleName.roleName
                                              .toLowerCase() ==
                                          'barangay chairperson'
                                      ? state.assignedArea.brgydesc
                                      : state.roleIdRoleName.roleName
                                                  .toLowerCase() ==
                                              'purok president'
                                          ? state.assignedArea.purokdesc
                                          : state.roleIdRoleName.roleName
                                                      .toLowerCase() ==
                                                  'establishment point-person'
                                              ? "Agency"
                                              : "",
                              subtitle: state.roleIdRoleName.roleName
                                              .toLowerCase() ==
                                          "41" ||
                                      state.roleIdRoleName.roleName
                                              .toLowerCase() ==
                                          'qr code scanner' ||
                                      state.roleIdRoleName.roleName
                                              .toLowerCase() ==
                                          'office/branch chief' ||
                                      state.roleIdRoleName.roleName
                                              .toLowerCase() ==
                                          'registration in-charge'
                                  ? "Station"
                                  : state.roleIdRoleName.roleName
                                              .toLowerCase() ==
                                          'barangay chairperson'
                                      ? "Barangay"
                                      : state.roleIdRoleName.roleName
                                                  .toLowerCase() ==
                                              'purok president'
                                          ? "Purok"
                                          : state.roleIdRoleName.roleName
                                                      .toLowerCase() ==
                                                  'establishment point-person'
                                              ? "Agency"
                                              : "",
                            ),
                            SelectedState(
                              title: state.otherInputs ? "YES" : "NO",
                              subtitle: "Include other inputs",
                            ),
                            const SizedBox(
                              height: 54,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            if(state is QRScanfailed){
    return SomethingWentWrong(message: "Scan Failed. Please try again!", onpressed: (){
                    context.read<PassCheckBloc>().add(ScanQr(token: state.token));
    });
                    }
            if (state is PassCheckErrorState) {
              return SomethingWentWrong(
                  message: state.message,
                  onpressed: () {
                    context.read<PassCheckBloc>().add(ScanError());
                  });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
