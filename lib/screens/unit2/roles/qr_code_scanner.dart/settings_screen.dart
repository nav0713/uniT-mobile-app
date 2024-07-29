import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:unit2/bloc/role/pass_check/pass_check_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/screens/unit2/homepage.dart/components/dashboard/dashboard.dart';
import 'package:unit2/screens/unit2/roles/qr_code_scanner.dart/components/custom_switch.dart';
import 'package:unit2/screens/unit2/roles/qr_code_scanner.dart/components/view_logs_screen.dart';
import 'package:unit2/screens/unit2/roles/qr_code_scanner.dart/scan.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import '../../../../theme-data.dart/btn-style.dart';
import '../../../../theme-data.dart/colors.dart';
import '../../../../theme-data.dart/form-style.dart';
import '../../../../utils/global.dart';

class QRCodeScannerSettings extends StatefulWidget {
  final RoleIdRoleName roleIdRoleName;
  final int userId;
  const QRCodeScannerSettings(
      {super.key, required this.roleIdRoleName, required this.userId});

  @override
  State<QRCodeScannerSettings> createState() => _QRCodeScannerSettingsState();
}

class _QRCodeScannerSettingsState extends State<QRCodeScannerSettings> {
  bool _includeOtherInputs = false;
  String scanMode = 'INCOMING';
  String selectedLevel = '';
  String selectedEstablishment = '';
  String selectedArea = '';
  dynamic assignedArea;
  int? checkerId;
  String? token;
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(qrScannerTitle),
          centerTitle: true,
          backgroundColor: primary,
          actions: context.watch<PassCheckBloc>().state
                      is PassCheckLoadingState ||
                  context.watch<PassCheckBloc>().state is PassCheckErrorState
              ? []
              : [
                  IconButton(
                      tooltip: "View Logs",
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return BlocProvider<PassCheckBloc>.value(
                            value: PassCheckBloc()
                              ..add(ViewPassCheckLogs(webUserId: checkerId!)),
                            child: const PassCheckLogs(),
                          );
                        })));
                      },
                      icon: const Icon(Typicons.doc_text))
                ],
        ),
        body: LoadingProgress(
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoggedIn) {
                token = state.userData!.user!.login!.token;
                checkerId = state.userData!.user!.login!.user!.id;
                return BlocConsumer<PassCheckBloc, PassCheckState>(
                  listener: (context, state) {
                    if (state is PassCheckLoadingState) {
                      final progress = ProgressHUD.of(context);
                      progress!.showWithText("Please wait...");
                    }
                    if (state is AssignAreaLoaded ||
                        state is PassCheckErrorState) {
                      final progress = ProgressHUD.of(context);
                      progress!.dismiss();
                    }
                  },
                  builder: (context, state) {
                    if (state is AssignAreaLoaded) {
                      return Container(
                        height: screenHeight * .90,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 42, vertical: 10),
                        child: FormBuilder(
                          key: _formKey,
                          child: Column(
                            children: [
                              Flexible(
                                child: ListView(
                                  children: [
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    FadeInLeft(
                                      child: SvgPicture.asset(
                                        'assets/svgs/switch.svg',
                                        height: blockSizeVertical * 14,
                                        allowDrawingOutsideViewBox: true,
                                      ),
                                    ),
                                    FadeInLeft(
                                      delay: const Duration(milliseconds: 100),
                                      child: ListTile(
                                        title: Text(
                                          setQRScannerSettings,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(color: third),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    FadeInLeft(
                                      delay: const Duration(milliseconds: 300),
                                      child: Text(includeOtherInputs,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                    ),
                                    FadeInLeft(
                                      delay: const Duration(milliseconds: 300),
                                      child: Text(
                                        includeOtherInputsSubTitle,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                    FadeInLeft(
                                      delay: const Duration(milliseconds: 300),
                                      child: SizedBox(
                                        child: FittedBox(
                                          child: CostumToggleSwitch(
                                            activeBGColors: [
                                              Colors.green[800]!,
                                              Colors.red[800]!
                                            ],
                                            initialLabelIndex:
                                                _includeOtherInputs ? 0 : 1,
                                            icons: const [
                                              Entypo.check,
                                              ModernPictograms.cancel
                                            ],
                                            labels: const ['YES', 'NO'],
                                            onToggle: (value) {
                                              value == 0
                                                  ? _includeOtherInputs = true
                                                  : _includeOtherInputs = false;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Incoming or outgoing
                                    FadeInLeft(
                                      delay: const Duration(milliseconds: 500),
                                      child: Text(incomingORoutgoing,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                    ),
                                    FadeInLeft(
                                      delay: const Duration(milliseconds: 500),
                                      child: Text(
                                        incomingORoutgoingSubTitle,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                    FadeInLeft(
                                      delay: const Duration(milliseconds: 500),
                                      child: FittedBox(
                                        child: CostumToggleSwitch(
                                          activeBGColors: [
                                            Colors.red[800]!,
                                            Colors.green[800]!
                                          ],
                                          initialLabelIndex:
                                              scanMode == 'INCOMING' ? 0 : 1,
                                          icons: const [
                                            Entypo.down_bold,
                                            Entypo.up_bold,
                                          ],
                                          labels: const [
                                            'INCOMING',
                                            'OUTGOING'
                                          ],
                                          onToggle: (value) {
                                            value == 0
                                                ? scanMode = 'INCOMING'
                                                : scanMode = 'OUTGOING';
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),

                                    ////STATION
                                    FadeInLeft(
                                      delay: const Duration(milliseconds: 700),
                                      child: Container(
                                          child: state.roleIdRoleName.roleName
                                                      .toLowerCase() ==
                                                  "41"
                                              ? DropdownButtonFormField(
                                                  isExpanded: true,
                                                  validator: FormBuilderValidators
                                                      .required(
                                                          errorText:
                                                              fieldIsRequired),
                                                  decoration:
                                                      normalTextFieldStyle(
                                                          "station", "station"),
                                                  items: state.assignedArea
                                                      .map((station) {
                                                    if (station.motherStation) {
                                                      return DropdownMenuItem<
                                                          dynamic>(
                                                        enabled: false,
                                                        value: station,
                                                        child: Text(
                                                          station.stationName
                                                              .toUpperCase(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                      );
                                                    } else {
                                                      return DropdownMenuItem<
                                                          dynamic>(
                                                        value: station,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10),
                                                          child: Text(station
                                                              .stationName),
                                                        ),
                                                      );
                                                    }
                                                  }).toList(),
                                                  // value: selectedLevel,
                                                  onChanged: (value) async {
                                                    assignedArea = value;
                                                  },
                                                  ////BARANGAY
                                                )
                                              : state.roleIdRoleName.roleName
                                                          .toLowerCase() ==
                                                      'barangay nurse'
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Select Barangay",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        DropdownButtonFormField(
                                                          isExpanded: true,
                                                          decoration:
                                                              normalTextFieldStyle(
                                                                  "Barangay",
                                                                  "Barangay"),
                                                          items: state
                                                              .assignedArea
                                                              .map((barangay) {
                                                            return DropdownMenuItem<
                                                                dynamic>(
                                                              value: barangay,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            5),
                                                                child: Text(
                                                                    barangay
                                                                        .brgydesc),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged: (value) {
                                                            assignedArea =
                                                                value;
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                  :
                                                  ////PUROK
                                                  state.roleIdRoleName.roleName
                                                              .toLowerCase() ==
                                                          'checkpoint in-charge'
                                                      ? Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Select Purok",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                            ),
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            DropdownButtonFormField(
                                                              isExpanded: true,
                                                              decoration:
                                                                  normalTextFieldStyle(
                                                                      "Purok",
                                                                      "Purok"),
                                                              items: state
                                                                  .assignedArea
                                                                  .map((purok) {
                                                                return DropdownMenuItem<
                                                                    dynamic>(
                                                                  value: purok,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            5),
                                                                    child: Text(
                                                                        purok
                                                                            .purokdesc),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                              onChanged:
                                                                  (value) {
                                                                assignedArea =
                                                                    value;
                                                              },
                                                            ),
                                                          ],
                                                        )
                                                      :
                                                      ////Registration InCharge
                                                      state.roleIdRoleName
                                                                  .roleName
                                                                  .toLowerCase() ==
                                                              'registration in-charge'
                                                          ? Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Select Station",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium,
                                                                ),
                                                                const SizedBox(
                                                                  height: 12,
                                                                ),
                                                                DropdownButtonFormField(
                                                                  isExpanded:
                                                                      true,
                                                                  validator: FormBuilderValidators
                                                                      .required(
                                                                          errorText:
                                                                              fieldIsRequired),
                                                                  decoration: normalTextFieldStyle(
                                                                      "station",
                                                                      "station"),
                                                                  items: state
                                                                      .assignedArea
                                                                      .map(
                                                                          (station) {
                                                                    if (station
                                                                        .motherStation) {
                                                                      return DropdownMenuItem<
                                                                          dynamic>(
                                                                        enabled:
                                                                            false,
                                                                        value:
                                                                            station,
                                                                        child:
                                                                            Text(
                                                                          station
                                                                              .stationName
                                                                              .toUpperCase(),
                                                                          style:
                                                                              const TextStyle(color: Colors.grey),
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      return DropdownMenuItem<
                                                                          dynamic>(
                                                                        value:
                                                                            station,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 5),
                                                                          child:
                                                                              Text(station.stationName),
                                                                        ),
                                                                      );
                                                                    }
                                                                  }).toList(),
                                                                  // value: selectedLevel,
                                                                  onChanged:
                                                                      (value) async {
                                                                    assignedArea =
                                                                        value;
                                                                  },
                                                                ),
                                                              ],
                                                            )
                                                          : ////QR Code Scanner
                                                          state.roleIdRoleName
                                                                      .roleName
                                                                      .toLowerCase() ==
                                                                  'qr code scanner'
                                                              ? Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Select Station",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium,
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          12,
                                                                    ),
                                                                    DropdownButtonFormField(
                                                                      isExpanded:
                                                                          true,
                                                                      validator:
                                                                          FormBuilderValidators.required(
                                                                              errorText: fieldIsRequired),
                                                                      decoration: normalTextFieldStyle(
                                                                          "station",
                                                                          "station"),
                                                                      items: state
                                                                          .assignedArea
                                                                          .map(
                                                                              (station) {
                                                                        if (station
                                                                            .motherStation) {
                                                                          return DropdownMenuItem<
                                                                              dynamic>(
                                                                            enabled:
                                                                                false,
                                                                            value:
                                                                                station,
                                                                            child:
                                                                                Text(
                                                                              station.stationName.toUpperCase(),
                                                                              style: const TextStyle(color: Colors.grey),
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          return DropdownMenuItem<
                                                                              dynamic>(
                                                                            value:
                                                                                station,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 5),
                                                                              child: Text(station.stationName),
                                                                            ),
                                                                          );
                                                                        }
                                                                      }).toList(),
                                                                      // value: selectedLevel,
                                                                      onChanged:
                                                                          (value) async {
                                                                        assignedArea =
                                                                            value;
                                                                      },
                                                                    ),
                                                                  ],
                                                                )
                                                              :
                                                              ////Establishment Point-Person
                                                              state.roleIdRoleName
                                                                          .roleName
                                                                          .toLowerCase() ==
                                                                      'establishment point-person'
                                                                  ? Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Select Agency",
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .titleMedium,
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              12,
                                                                        ),
                                                                        DropdownButtonFormField(
                                                                          isExpanded:
                                                                              true,
                                                                          validator:
                                                                              FormBuilderValidators.required(errorText: fieldIsRequired),
                                                                          decoration: normalTextFieldStyle(
                                                                              "Agency",
                                                                              "Agency"),
                                                                          items: state
                                                                              .assignedArea
                                                                              .map((agency) {
                                                                            return DropdownMenuItem<dynamic>(
                                                                              value: agency,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(left: 5),
                                                                                child: Text(agency.area.name),
                                                                              ),
                                                                            );
                                                                          }).toList(),
                                                                          // value: selectedLevel,
                                                                          onChanged:
                                                                              (value) async {
                                                                            assignedArea =
                                                                                value;
                                                                          },
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : ////Office Branch Chief
                                                                  state.roleIdRoleName
                                                                              .roleName
                                                                              .toLowerCase() ==
                                                                          'office/branch chief'
                                                                      ? Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "Select Station",
                                                                              textAlign: TextAlign.start,
                                                                              style: Theme.of(context).textTheme.titleMedium,
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 12,
                                                                            ),
                                                                            DropdownButtonFormField(
                                                                              isExpanded: true,
                                                                              validator: FormBuilderValidators.required(errorText: fieldIsRequired),
                                                                              decoration: normalTextFieldStyle("station", "station"),
                                                                              items: state.assignedArea.map((station) {
                                                                                if (station.motherStation) {
                                                                                  return DropdownMenuItem<dynamic>(
                                                                                    enabled: false,
                                                                                    value: station,
                                                                                    child: Text(
                                                                                      station.stationName.toUpperCase(),
                                                                                      style: const TextStyle(color: Colors.grey),
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  return DropdownMenuItem<dynamic>(
                                                                                    value: station,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(left: 5),
                                                                                      child: Text(station.stationName),
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              }).toList(),
                                                                              // value: selectedLevel,
                                                                              onChanged: (value) async {
                                                                                assignedArea = value;
                                                                              },
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : Container()),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              SlideInUp(
                                delay: const Duration(milliseconds: 800),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 60,
                                  child: ElevatedButton(
                                    style: mainBtnStyle(primary,
                                        Colors.transparent, Colors.white54),
                                    child: const Text(
                                      submit,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!
                                          .saveAndValidate()) {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return BlocProvider<
                                              PassCheckBloc>.value(
                                            value: PassCheckBloc()
                                              ..add(SetScannerSettings(
                                                  token: token!,
                                                  assignedArea: assignedArea,
                                                  checkerId: checkerId!,
                                                  entranceExit: scanMode,
                                                  includeOtherInputs:
                                                      _includeOtherInputs,
                                                  roleIdRoleName:
                                                      widget.roleIdRoleName)),
                                            child: const QRCodeScanner(),
                                          );
                                        }));
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 18,
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    if (state is PassCheckErrorState) {
                      return SomethingWentWrong(
                          message: state.message,
                          onpressed: () {
                            context.read<PassCheckBloc>().add(GetPassCheckAreas(
                                roleIdRoleName: widget.roleIdRoleName,
                                userId: widget.userId));
                          });
                    }
                    return Container();
                  },
                );
              }
              return Container();
            },
          ),
        ));
  }
}
