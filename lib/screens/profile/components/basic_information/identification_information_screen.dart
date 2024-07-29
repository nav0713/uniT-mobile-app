import 'package:animate_do/animate_do.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:gap/gap.dart';
import 'package:unit2/bloc/profile/primary_information/identification/identification_bloc.dart';
import 'package:unit2/bloc/profile/profile_bloc.dart';
import 'package:unit2/screens/profile/components/basic_information/identification/add_modal.dart';
import 'package:unit2/screens/profile/components/basic_information/identification/edit_modal.dart';
import 'package:unit2/theme-data.dart/box_shadow.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/empty_data.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import 'package:unit2/widgets/titlesubtitle.dart';
import '../../../../bloc/user/user_bloc.dart';
import '../../../../utils/alerts.dart';
import '../../../../widgets/Leadings/close_leading.dart';

class IdentificationsScreen extends StatelessWidget {
  const IdentificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? token;
    int? profileId;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: context.watch<IdentificationBloc>().state
                    is IdentificationAddingState
                ? const Text("Add Identification")
                : context.watch<IdentificationBloc>().state
                        is IdentificationEditingState
                    ? const Text("Edit Identification")
                    : const Text("Identifications"),
            centerTitle: true,
            backgroundColor: primary,
            actions: (context.watch<IdentificationBloc>().state
                    is IdentificationLoadedState)
                ? [
                    AddLeading(onPressed: () {
                      context
                          .read<IdentificationBloc>()
                          .add(ShowAddIdentificationForm());
                    })
                  ]
                : (context.watch<IdentificationBloc>().state
                            is IdentificationAddingState ||
                        context.watch<IdentificationBloc>().state
                            is IdentificationEditingState)
                    ? [
                        CloseLeading(onPressed: () {
                          context
                              .read<IdentificationBloc>()
                              .add(LoadIdentifications());
                        })
                      ]
                    : []),
        body: LoadingProgress(

          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoggedIn) {
                token = state.userData!.user!.login!.token;
                profileId = state.userData!.user!.login!.user!.profileId;
                return BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoaded) {
                      return BlocConsumer<IdentificationBloc,
                          IdentificationState>(
                        listener: (context, state) {
                          if (state is IdentificationLoadingState) {
                            final progress = ProgressHUD.of(context);
                            progress!.showWithText("Please wait...");
                          }

                          if (state is IdentificationLoadedState ||
                              state is IdentificationAddingState ||
                              state is IdentificationEditingState ||
                              state is IdenficationErrorState ||
                              state is IdentificationAddedState ||
                              state is IdentificationDeletedState ||
                              state is IdentificationEditedState ||
                              state is IdentificationAddingErrorState ||
                              state is IdentificationEditErrorState || state is ShowAddFormErrorState || state is ShowEditFormErrorState ||
                              state is IdentificationDeleteErrorState) {
                            final progress = ProgressHUD.of(context);
                            progress!.dismiss();
                          }
                          //// Added State
                          if (state is IdentificationAddedState) {
                            if (state.response['success']) {
                              successAlert(context, "Adding Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<IdentificationBloc>()
                                    .add(LoadIdentifications());
                              });
                            } else {
                              errorAlert(context, "Adding Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<IdentificationBloc>()
                                    .add(LoadIdentifications());
                              });
                            }
                          }
                          //// Updated State
                          if (state is IdentificationEditedState) {
                            if (state.response['success']) {
                              successAlert(context, "Update Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<IdentificationBloc>()
                                    .add(LoadIdentifications());
                              });
                            } else {
                              errorAlert(context, "Update Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<IdentificationBloc>()
                                    .add(LoadIdentifications());
                              });
                            }
                          }

                          ////Deleted State
                          if (state is IdentificationDeletedState) {
                            if (state.success) {
                              successAlert(context, "Deletion Successfull!",
                                  "Identification Deleted Successfully", () {
                                Navigator.of(context).pop();
                                context
                                    .read<IdentificationBloc>()
                                    .add(LoadIdentifications());
                              });
                            } else {
                              errorAlert(context, "Deletion Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<IdentificationBloc>()
                                    .add(LoadIdentifications());
                              });
                            }
                          }
                        },
                        builder: (context, state) {
                          if (state is IdentificationLoadedState) {
                            if (state.identificationInformation.isNotEmpty) {
                              String issuedAt;
                              return ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  itemCount:
                                      state.identificationInformation.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String agency = state
                                        .identificationInformation[index]
                                        .agency!
                                        .name!;
                                    String idNumber = state
                                        .identificationInformation[index]
                                        .identificationNumber!;
                                    bool government = state
                                        .identificationInformation[index]
                                        .agency!
                                        .privateEntity!;
                                    if (state.identificationInformation[index]
                                            .issuedAt?.country?.id !=
                                        175) {
                                      issuedAt = state
                                          .identificationInformation[index]
                                          .issuedAt!
                                          .country!
                                          .name!
                                          .toUpperCase();
                                    } else {
                                      issuedAt =
                                          "${state.identificationInformation[index].issuedAt!.cityMunicipality?.description!} ${state.identificationInformation[index].issuedAt!.cityMunicipality?.province!.description}";
                                    }
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration: const Duration(milliseconds: 500),
                                      child: FlipAnimation(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return ZoomIn(
                                                        child: AlertDialog(
                                                          backgroundColor:
                                                              Colors.white,
                                                          title: const Column(
                                                            children: [
                                                              Icon(
                                                                FontAwesome5.id_card,
                                                                color: primary,
                                                                size: 32,
                                                              ),
                                                              Text(
                                                                "Identification Details",
                                                                style: TextStyle(
                                                                    color: primary,
                                                                    fontSize: 18),
                                                              ),
                                                              Divider(),
                                                            ],
                                                          ),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize.min,
                                                            children: [
                                                              TitleSubtitle(
                                                                title: state
                                                                    .identificationInformation[
                                                                        index]
                                                                    .agency!
                                                                    .name!,
                                                                sub: "Agency",
                                                              ),
                                                              const Gap(3),
                                                              TitleSubtitle(
                                                                title: state
                                                                    .identificationInformation[
                                                                        index]
                                                                    .identificationNumber!,
                                                                sub:
                                                                    "Identification Number",
                                                              ),
                                                              const Gap(3),
                                                              TitleSubtitle(
                                                                title: state
                                                                            .identificationInformation[
                                                                                index]
                                                                            .dateIssued ==
                                                                        null
                                                                    ? 'N/A'
                                                                    : dteFormat2.format(state
                                                                        .identificationInformation[
                                                                            index]
                                                                        .dateIssued!),
                                                                sub: "Date Issued",
                                                              ),
                                                              const Gap(3),
                                                              TitleSubtitle(
                                                                title: state
                                                                            .identificationInformation[
                                                                                index]
                                                                            .expirationDate ==
                                                                        null
                                                                    ? 'N/A'
                                                                    : dteFormat2.format(state
                                                                        .identificationInformation[
                                                                            index]
                                                                        .dateIssued!),
                                                                sub:
                                                                    "Expiration Date",
                                                              ),
                                                              const Gap(3),
                                                              SizedBox(
                                                                child: state
                                                                            .identificationInformation[
                                                                                index]
                                                                            .issuedAt!
                                                                            .country!
                                                                            .name!
                                                                            .toLowerCase() !=
                                                                        'philippines'
                                                                    ? TitleSubtitle(
                                                                        title: state
                                                                            .identificationInformation[
                                                                                index]
                                                                            .issuedAt!
                                                                            .country!
                                                                            .name!,
                                                                        sub:
                                                                            "Country",
                                                                      )
                                                                    : Column(
                                                                        children: [
                                                                          TitleSubtitle(
                                                                            title: state
                                                                                .identificationInformation[
                                                                                    index]
                                                                                .issuedAt!
                                                                                .cityMunicipality!
                                                                                .province!
                                                                                .region!
                                                                                .description!,
                                                                            sub:
                                                                                "Region",
                                                                          ),
                                                                          const Gap(
                                                                              3),
                                                                          TitleSubtitle(
                                                                            title: state
                                                                                .identificationInformation[
                                                                                    index]
                                                                                .issuedAt!
                                                                                .cityMunicipality!
                                                                                .province!
                                                                                .description!,
                                                                            sub:
                                                                                "Province",
                                                                          ),
                                                                          const Gap(
                                                                              3),
                                                                          TitleSubtitle(
                                                                            title: state
                                                                                .identificationInformation[
                                                                                    index]
                                                                                .issuedAt!
                                                                                .cityMunicipality!
                                                                                .description!,
                                                                            sub:
                                                                                "City/Municipality",
                                                                          ),
                                                                        ],
                                                                      ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: Container(
                                                decoration: box1(),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 12, vertical: 8),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(agency,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium!
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color:
                                                                            primary)),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              "$idNumberText : $idNumber",
                                                              style:
                                                                  Theme.of(context)
                                                                      .textTheme
                                                                      .titleSmall,
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              issuedAt,
                                                              style:
                                                                  Theme.of(context)
                                                                      .textTheme
                                                                      .titleSmall,
                                                            ),
                                                            const SizedBox(
                                                              height: 8,
                                                            ),
                                                            Badge(
                                                                backgroundColor:
                                                                    government !=
                                                                            true
                                                                        ? success2
                                                                        : second,
                                                                label: Text(
                                                                  government == true
                                                                      ? privateText
                                                                          .toUpperCase()
                                                                      : governmentText
                                                                          .toUpperCase(),
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(
                                                                          color: Colors
                                                                              .white),
                                                                ))
                                                          ]),
                                                    ),
                                                    AppPopupMenu<int>(
                                                      offset:
                                                          const Offset(-10, -10),
                                                      elevation: 3,
                                                      onSelected: (value) {
                                                        ////delete identification-= = = = = = = = =>>
                                                        if (value == 2) {
                                                          confirmAlert(context, () {
                                                            BlocProvider.of<
                                                                        IdentificationBloc>(
                                                                    context)
                                                                .add(DeleteIdentification(
                                                                    identificationId: state
                                                                        .identificationInformation[
                                                                            index]
                                                                        .id!,
                                                                    profileId:
                                                                        profileId!,
                                                                    token: token!));
                                                          }, "Delete?",
                                                              "Confirm Delete?");
                                                        }
                                                        if (value == 1) {
                                                          bool isOverseas;
                                                          ////edit voluntary work-= = = = = = = = =>>
                                                   
                                                          if (state
                                                                  .identificationInformation[
                                                                      index]
                                                                  .issuedAt
                                                                  ?.cityMunicipality !=
                                                              null) {
                                                            isOverseas = false;
                                                          } else {
                                                            isOverseas = true;
                                                          }
                                                          context
                                                              .read<
                                                                  IdentificationBloc>()
                                                              .add(ShowEditIdentificationForm(
                                                                  identification:
                                                                      state.identificationInformation[
                                                                          index],
                                                                  profileId:
                                                                      profileId!,
                                                                  token: token!,
                                                                  overseas:
                                                                      isOverseas));
                                                        }
                                                      },
                                                      menuItems: [
                                                        popMenuItem(
                                                            text: "Update",
                                                            value: 1,
                                                            icon: Icons.edit),
                                                        popMenuItem(
                                                            text: "Remove",
                                                            value: 2,
                                                            icon: Icons.delete),
                                                      ],
                                                      icon: const Icon(
                                                        Icons.more_vert,
                                                        color: Colors.grey,
                                                      ),
                                                      tooltip: "Options",
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              return const EmptyData(
                                  message:
                                      "You don't have identifications added. Please click + to add.");
                            }
                          }
                          if (state is IdentificationAddingState) {
                            return AddIdentificationScreen(
                              token: token!,
                              profileId: profileId!,
                            );
                          }
                          if (state is IdenficationErrorState) {
                            return SomethingWentWrong(
                                message: state.message,
                                onpressed: () {
                                  context
                                      .read<IdentificationBloc>()
                                      .add(LoadIdentifications());
                                });
                          }
                          if (state is IdentificationEditingState) {
                            return EditIdentificationScreen(
                                profileId: profileId!, token: token!);
                          }
                          if (state is IdentificationAddingErrorState) {
                            return SomethingWentWrong(
                                message:
                                    "Error Adding Identifcation. Please try again!",
                                onpressed: () {
                                  context.read<IdentificationBloc>().add(
                                      AddIdentification(
                                          identification: state.identification,
                                          profileId: profileId!,
                                          token: token!));
                                });
                          }
                          if (state is IdentificationEditErrorState) {
                            return SomethingWentWrong(
                                message:
                                    "Error Editing Identifcation. Please try again!",
                                onpressed: () {
                                  context.read<IdentificationBloc>().add(
                                      UpdateIdentifaction(
                                          identification: state.identification,
                                          profileId: profileId!,
                                          token: token!));
                                });
                          }
                          if (state is IdentificationDeleteErrorState) {
                            return SomethingWentWrong(
                                message:
                                    "Error Deleting Identifcation. Please try again!",
                                onpressed: () {
                                  final progress = ProgressHUD.of(context);
                                  progress!.showWithText("Please wait...");
                                  context.read<IdentificationBloc>().add(
                                      DeleteIdentification(
                                          identificationId:
                                              state.identificationId,
                                          profileId: profileId!,
                                          token: token!));
                                });
                          }if(state is ShowAddFormErrorState){
                            return SomethingWentWrong(message: onError, onpressed: (){
                              context.read<IdentificationBloc>().add(ShowAddIdentificationForm());
                            });
                          }if(state is ShowEditFormErrorState){
                            return SomethingWentWrong(message: onError, onpressed: (){
                               
                              context.read<IdentificationBloc>().add(ShowEditIdentificationForm(identification: state.identification, profileId: profileId!, token: token!, overseas: state.isOverseas));
                            });
                          }

                          return Container();
                        },
                      );
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

  PopupMenuItem<int> popMenuItem({String? text, int? value, IconData? icon}) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text!,
          ),
        ],
      ),
    );
  }
}
