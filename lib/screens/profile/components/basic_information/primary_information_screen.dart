import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:intl/intl.dart';
import 'package:unit2/bloc/profile/profile_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/screens/profile/components/basic_information/edit_basic_info_modal.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/theme-data.dart/form-style.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/Leadings/close_leading.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';

import '../../../../utils/alerts.dart';

class PrimaryInfo extends StatefulWidget {
  final int profileId;
  final String token;
  const PrimaryInfo({super.key, required this.profileId, required this.token});

  @override
  State<PrimaryInfo> createState() => _PrimaryInfoState();
}

class _PrimaryInfoState extends State<PrimaryInfo> {
  @override
  Widget build(BuildContext context) {
    bool enabled = false;
    DateFormat dteFormat2 = DateFormat.yMMMMd('en_US');
    return Scaffold(
        appBar: AppBar(
            title: context.watch<ProfileBloc>().state
                    is BasicInformationEditingState
                ? const Text("Edit Profile")
                : const Text("Primary Information"),
            centerTitle: true,
            backgroundColor: primary,
            actions: context.watch<ProfileBloc>().state
                    is BasicInformationProfileLoaded
                ? [
                    IconButton(
                        onPressed: () {
                          context.read<ProfileBloc>().add(
                              ShowPrimaryInfoEditForm(token: widget.token));
                        },
                        icon: const Icon(Icons.edit))
                  ]
                : context.watch<ProfileBloc>().state
                        is BasicInformationEditingState
                    ? [
                        CloseLeading(onPressed: () {
                          context
                              .read<ProfileBloc>()
                              .add(LoadBasicPrimaryInfo());
                        })
                      ]
                    : []),
        body: LoadingProgress(
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoggedIn) {
                return BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is BasicPrimaryInformationLoadingState) {
                      final progress = ProgressHUD.of(context);
                      progress!.showWithText("Please wait...");
                    }
                    if (state is BasicInformationProfileLoaded ||
                        state is BasicInformationEditingState ||
                        state is BasicPrimaryInformationErrorState ||
                        state is ShowEditBasicInfoErrorState ||
                        state is BasicProfileInfoEditedState ||
                        state is BasicInformationUpdatingErrorState) {
                      final progress = ProgressHUD.of(context);
                      progress!.dismiss();
                    }
                    if (state is BasicProfileInfoEditedState) {
                      if (state.response['success']) {
                        successAlert(context, "Updated Successfull!",
                            state.response['message'], () {
                          Navigator.of(context).pop();
                          context
                              .read<ProfileBloc>()
                              .add(LoadBasicPrimaryInfo());
                        });
                      } else {
                        errorAlert(context, "Update Failed",
                            "Something went wrong. Please try again.", () {
                          Navigator.of(context).pop();
                          context
                              .read<ProfileBloc>()
                              .add(LoadBasicPrimaryInfo());
                        });
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is BasicInformationProfileLoaded) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 24),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 28,
                            ),
                            FlipInY(
                              duration: const Duration(milliseconds: 1500),
                              child: FormBuilderTextField(
                                enabled: false,
                                name: lastname,
                                initialValue:
                                    state.primaryBasicInformation.lastName!,
                                style: const TextStyle(color: Colors.black),
                                decoration:
                                    normalTextFieldStyle("Last name", "")
                                        .copyWith(
                                            disabledBorder:
                                                const OutlineInputBorder(),
                                            labelStyle: const TextStyle(
                                                color: Colors.black)),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FlipInY(
                              duration: const Duration(milliseconds: 1500),
                              child: FormBuilderTextField(
                                enabled: enabled,
                                name: firstname,
                                initialValue:
                                    state.primaryBasicInformation.firstName!,
                                style: const TextStyle(color: Colors.black),
                                decoration:
                                    normalTextFieldStyle("First name", "")
                                        .copyWith(
                                            disabledBorder:
                                                const OutlineInputBorder(),
                                            labelStyle: const TextStyle(
                                                color: Colors.black)),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FlipInY(
                              duration: const Duration(milliseconds: 1500),
                              child: SizedBox(
                                width: screenWidth,
                                child: Row(children: [
                                  Flexible(
                                    flex: 2,
                                    child: FormBuilderTextField(
                                      enabled: enabled,
                                      name: middlename,
                                      initialValue: state
                                              .primaryBasicInformation
                                              .middleName ??
                                          '',
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: normalTextFieldStyle(
                                              "Middle name", "")
                                          .copyWith(
                                              disabledBorder:
                                                  const OutlineInputBorder(),
                                              labelStyle: const TextStyle(
                                                  color: Colors.black)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: FlipInY(
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      child: FormBuilderTextField(
                                        enabled: enabled,
                                        name: extensionName,
                                        initialValue: state
                                            .primaryBasicInformation
                                            .nameExtension ??= 'N/A',
                                        style: const TextStyle(
                                            color: Colors.black),
                                        decoration: normalTextFieldStyle(
                                                "Name extension", "")
                                            .copyWith(
                                                disabledBorder:
                                                    const OutlineInputBorder(),
                                                labelStyle: const TextStyle(
                                                    color: Colors.black)),
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              width: screenWidth,
                              child: Row(children: [
                                Flexible(
                                  flex: 1,
                                  child: FlipInY(
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    child: FormBuilderTextField(
                                      enabled: enabled,
                                      name: extensionName,
                                      initialValue: dteFormat2.format(state
                                          .primaryBasicInformation.birthdate!),
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: normalTextFieldStyle(
                                              "Birth date", "")
                                          .copyWith(
                                              disabledBorder:
                                                  const OutlineInputBorder(),
                                              labelStyle: const TextStyle(
                                                  color: Colors.black)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: FlipInY(
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    child: FormBuilderTextField(
                                      enabled: enabled,
                                      name: sex,
                                      initialValue:
                                          state.primaryBasicInformation.sex!,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: normalTextFieldStyle(
                                              "Sex", "")
                                          .copyWith(
                                              disabledBorder:
                                                  const OutlineInputBorder(),
                                              labelStyle: const TextStyle(
                                                  color: Colors.black)),
                                    ),
                                  ),
                                )
                              ]),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              width: screenWidth,
                              child: Row(children: [
                                Flexible(
                                  flex: 1,
                                  child: FlipInY(
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    child: FormBuilderTextField(
                                      enabled: enabled,
                                      name: "bloodType",
                                      initialValue: state
                                              .primaryBasicInformation
                                              .bloodType ??
                                          'N/A',
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: normalTextFieldStyle(
                                              "Blood type", "")
                                          .copyWith(
                                              disabledBorder:
                                                  const OutlineInputBorder(),
                                              labelStyle: const TextStyle(
                                                  color: Colors.black)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: FlipInY(
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    child: FormBuilderTextField(
                                      enabled: enabled,
                                      name: "civilStatus",
                                      initialValue: state
                                          .primaryBasicInformation
                                          .civilStatus ??= 'N/A',
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: normalTextFieldStyle(
                                              "Civil Status", "")
                                          .copyWith(
                                              disabledBorder:
                                                  const OutlineInputBorder(),
                                              labelStyle: const TextStyle(
                                                  color: Colors.black)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: FlipInY(
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    child: FormBuilderTextField(
                                      enabled: enabled,
                                      name: "gender",
                                      initialValue: state
                                          .primaryBasicInformation
                                          .gender ??= "N/A",
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: normalTextFieldStyle(
                                              "Gender", "")
                                          .copyWith(
                                              disabledBorder:
                                                  const OutlineInputBorder(),
                                              labelStyle: const TextStyle(
                                                  color: Colors.black)),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              width: screenWidth,
                              child: Row(children: [
                                Flexible(
                                  flex: 1,
                                  child: FlipInY(
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    child: FormBuilderTextField(
                                      maxLines: 2,
                                      enabled: enabled,
                                      name: height,
                                      initialValue: state
                                                  .primaryBasicInformation
                                                  .heightM ==
                                              null
                                          ? ''
                                          : state
                                              .primaryBasicInformation.heightM
                                              .toString(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: normalTextFieldStyle(
                                              "Height", "")
                                          .copyWith(
                                              disabledBorder:
                                                  const OutlineInputBorder(),
                                              labelStyle: const TextStyle(
                                                  color: Colors.black)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: FlipInY(
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    child: FormBuilderTextField(
                                      enabled: enabled,
                                      name: width,
                                      initialValue: state
                                                  .primaryBasicInformation
                                                  .weightKg ==
                                              null
                                          ? ''
                                          : state
                                              .primaryBasicInformation.weightKg
                                              .toString(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: normalTextFieldStyle(
                                              "Weight", "")
                                          .copyWith(
                                              disabledBorder:
                                                  const OutlineInputBorder(),
                                              labelStyle: const TextStyle(
                                                  color: Colors.black)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: FlipInY(
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    child: FormBuilderTextField(
                                      enabled: enabled,
                                      name: prefixSuffix,
                                      initialValue:
                                          "${state.primaryBasicInformation.titlePrefix ??= "NA"} | ${state.primaryBasicInformation.titleSuffix ??= "N/A"}",
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: normalTextFieldStyle(
                                              "Title Prefix and Suffix", "")
                                          .copyWith(
                                              disabledBorder:
                                                  const OutlineInputBorder(),
                                              labelStyle: const TextStyle(
                                                  color: Colors.black)),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              width: screenWidth,
                              child: Row(children: [
                                Flexible(
                                  flex: 1,
                                  child: FlipInY(
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    child: FormBuilderTextField(
                                      maxLines: 2,
                                      enabled: enabled,
                                      name: height,
                                      initialValue: state
                                          .primaryBasicInformation.ip ??= "N/A",
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: normalTextFieldStyle(
                                              "Indigenous", "")
                                          .copyWith(
                                              disabledBorder:
                                                  const OutlineInputBorder(),
                                              labelStyle: const TextStyle(
                                                  color: Colors.black)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: FlipInY(
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    child: FormBuilderTextField(
                                      enabled: enabled,
                                      name: width,
                                      initialValue: state
                                          .primaryBasicInformation
                                          .ethnicity ??= "N/A",
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: normalTextFieldStyle(
                                              "Ethnicity", "")
                                          .copyWith(
                                              disabledBorder:
                                                  const OutlineInputBorder(),
                                              labelStyle: const TextStyle(
                                                  color: Colors.black)),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              width: screenWidth,
                              child: Row(children: [
                                Flexible(
                                  flex: 1,
                                  child: FlipInY(
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    child: FormBuilderTextField(
                                      maxLines: 2,
                                      enabled: enabled,
                                      name: height,
                                      initialValue: state
                                          .primaryBasicInformation
                                          .religion ??= "N/A",
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: normalTextFieldStyle(
                                              "Religion", "")
                                          .copyWith(
                                              disabledBorder:
                                                  const OutlineInputBorder(),
                                              labelStyle: const TextStyle(
                                                  color: Colors.black)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: FlipInY(
                                                                  duration: const Duration(milliseconds: 1500),
                                    child: FormBuilderTextField(
                                      maxLines: 2,
                                      enabled: enabled,
                                      name: width,
                                      initialValue: state
                                          .primaryBasicInformation
                                          .disability ??= "N/A",
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: normalTextFieldStyle(
                                              "Disability", "")
                                          .copyWith(
                                              disabledBorder:
                                                  const OutlineInputBorder(),
                                              labelStyle: const TextStyle(
                                                  color: Colors.black)),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      );
                    }
                    if (state is BasicInformationUpdatingErrorState) {
                      return SomethingWentWrong(
                          message: onError,
                          onpressed: () {
                            context.read<ProfileBloc>().add(
                                EditBasicProfileInformation(
                                    disabilityId: state.disabilityId,
                                    ethnicityId: state.ethnicityId,
                                    genderId: state.genderId,
                                    indigencyId: state.indigencyId,
                                    profileId: state.profileId,
                                    profileInformation:
                                        state.profileInformation,
                                    religionId: state.religionId,
                                    token: state.token));
                          });
                    }
                    if (state is BasicPrimaryInformationErrorState) {
                      return SomethingWentWrong(
                          message: state.message,
                          onpressed: () {
                            context
                                .read<ProfileBloc>()
                                .add(LoadBasicPrimaryInfo());
                          });
                    }
                    if (state is ShowEditBasicInfoErrorState) {
                      return SomethingWentWrong(
                          message: onError,
                          onpressed: () {
                            context.read<ProfileBloc>().add(
                                ShowPrimaryInfoEditForm(token: widget.token));
                          });
                    }
                    if (state is BasicInformationEditingState) {
                      return EditBasicProfileInfoScreen(
                          profileId: widget.profileId, token: widget.token);
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
