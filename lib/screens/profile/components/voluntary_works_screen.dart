import 'package:animate_do/animate_do.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:unit2/bloc/profile/profile_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/screens/profile/components/voluntary_works/add_modal.dart';
import 'package:unit2/screens/profile/components/voluntary_works/edit_modal.dart';
import 'package:unit2/theme-data.dart/box_shadow.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/empty_data.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import 'package:unit2/widgets/titlesubtitle.dart';

import '../../../bloc/profile/voluntary_works/voluntary_work_bloc.dart';
import '../../../utils/alerts.dart';
import '../../../widgets/Leadings/close_leading.dart';

class VolunataryWorkScreen extends StatelessWidget {
  const VolunataryWorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? token;
    int? profileId;
    DateFormat dteFormat2 = DateFormat.yMMMMd('en_US');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: context.watch<VoluntaryWorkBloc>().state
                  is AddVoluntaryWorkState
              ? const FittedBox(
                  child: Text("Add $voluntaryScreenTitle"),
                )
              : context.watch<VoluntaryWorkBloc>().state is EditVoluntaryWorks
                  ? const FittedBox(
                      child: Text("Edit $voluntaryScreenTitle"),
                    )
                  : const FittedBox(child: Text(voluntaryScreenTitle)),
          backgroundColor: primary,
          actions: (context.watch<VoluntaryWorkBloc>().state
                  is VoluntaryWorkLoadedState)
              ? [
                  AddLeading(onPressed: () {
                    context
                        .read<VoluntaryWorkBloc>()
                        .add(ShowAddVoluntaryWorks());
                  })
                ]
              : (context.watch<VoluntaryWorkBloc>().state
                          is AddVoluntaryWorkState ||
                      context.watch<VoluntaryWorkBloc>().state
                          is EditVoluntaryWorks)
                  ? [
                      CloseLeading(onPressed: () {
                        context
                            .read<VoluntaryWorkBloc>()
                            .add(LoadVoluntaryWorks());
                      })
                    ]
                  : []),
      body: LoadingProgress(child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoggedIn) {
            token = state.userData!.user!.login!.token;
            profileId = state.userData!.user!.login!.user!.profileId;
            return BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  return BlocConsumer<VoluntaryWorkBloc, VoluntaryWorkState>(
                    listener: (context, state) {
                      if (state is VoluntaryWorkLoadingState) {
                        final progress = ProgressHUD.of(context);
                        progress!.showWithText("Please wait...");
                      }
                      if (state is VoluntaryWorkLoadedState ||
                          state is ShowAddFormErrorState ||
                          state is VoluntaryWorkErrorState ||
                          state is AddVoluntaryWorkState ||
                          state is VoluntaryWorkAddedState ||
                          state is VoluntaryWorkDeletedState ||
                          state is EditVoluntaryWorks ||
                          state is VolunataryWorkHistoryAddingErrorState ||
                          state is VoluntaryWorkHistoryEditingErrorState ||
                          state is ShowEditFormErrorState ||
                          state is VolunataryWorkHistoryUpdatingErrorState ||
                          state is VoluntaryWorkHistoryDeletingErrorState) {
                        final progress = ProgressHUD.of(context);
                        progress!.dismiss();
                      }
                      //// Added State
                      if (state is VoluntaryWorkAddedState) {
                        if (state.response['success']) {
                          successAlert(context, "Adding Successfull!",
                              state.response['message'], () {
                            Navigator.of(context).pop();
                            context
                                .read<VoluntaryWorkBloc>()
                                .add(LoadVoluntaryWorks());
                          });
                        } else {
                          errorAlert(context, "Adding Failed",
                              "Something went wrong. Please try again.", () {
                            Navigator.of(context).pop();
                            context
                                .read<VoluntaryWorkBloc>()
                                .add(LoadVoluntaryWorks());
                          });
                        }
                      }
                      //// Updated State

                      if (state is VoluntaryWorkEditedState) {
                        if (state.response['success']) {
                          successAlert(context, "Updated Successfull!",
                              state.response['message'], () {
                            Navigator.of(context).pop();
                            context
                                .read<VoluntaryWorkBloc>()
                                .add(LoadVoluntaryWorks());
                          });
                        } else {
                          errorAlert(context, "Update Failed",
                              "Something went wrong. Please try again.", () {
                            Navigator.of(context).pop();
                            context
                                .read<VoluntaryWorkBloc>()
                                .add(LoadVoluntaryWorks());
                          });
                        }
                      }
                      ////Deleted State
                      if (state is VoluntaryWorkDeletedState) {
                        if (state.success) {
                          successAlert(context, "Deletion Successfull!",
                              "Voluntary Work Has Been Deleted Successfully",
                              () {
                            Navigator.of(context).pop();
                            context
                                .read<VoluntaryWorkBloc>()
                                .add(LoadVoluntaryWorks());
                          });
                        } else {
                          errorAlert(context, "Deletion Failed",
                              "Something went wrong. Please try again.", () {
                            Navigator.of(context).pop();
                            context
                                .read<VoluntaryWorkBloc>()
                                .add(LoadVoluntaryWorks());
                          });
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is VoluntaryWorkLoadedState) {
                        if (state.voluntaryWorks.isNotEmpty) {
                          return ListView.builder(
                              itemCount: state.voluntaryWorks.length,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              itemBuilder: (BuildContext context, int index) {
                                String position = state
                                    .voluntaryWorks[index].position!.title!;
                                String agency =
                                    state.voluntaryWorks[index].agency!.name!;
                                String from = dteFormat2.format(
                                    state.voluntaryWorks[index].fromDate!);
                                String hours = state
                                    .voluntaryWorks[index].totalHours
                                    .toString();
                                String? to = state
                                            .voluntaryWorks[index].toDate ==
                                        null
                                    ? "Present"
                                    : dteFormat2.format(
                                        state.voluntaryWorks[index].toDate!);
                                return AnimationConfiguration.staggeredList(
                                  position: index,

                                  duration: const Duration(milliseconds: 500),
                                  child: FlipAnimation(
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return ZoomIn(
                                                    child: AlertDialog(
                                                      backgroundColor: Colors.white,
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
                                                                    .voluntaryWorks[
                                                                        index]
                                                                    .position!
                                                                    .title!,
                                                                sub: "Position"),
                                                            const Gap(3),
                                                            TitleSubtitle(
                                                                title: state
                                                                    .voluntaryWorks[
                                                                        index]
                                                                    .agency!
                                                                    .name!,
                                                                sub: "Agency"),
                                                            const Gap(3),
                                                            TitleSubtitle(
                                                                title: dteFormat2
                                                                    .format(state
                                                                        .voluntaryWorks[
                                                                            index]
                                                                        .fromDate!),
                                                                sub: "From Date"),
                                                            SizedBox(
                                                              child: state
                                                                          .voluntaryWorks[
                                                                              index]
                                                                          .toDate !=
                                                                      null
                                                                  ? Column(
                                                                      children: [
                                                                        const Gap(3),
                                                                        TitleSubtitle(
                                                                            title: dteFormat2.format(state
                                                                                .voluntaryWorks[
                                                                                    index]
                                                                                .toDate!),
                                                                            sub:
                                                                                "To Date"),
                                                                      ],
                                                                    )
                                                                  : const Gap(0),
                                                            ),
                                                            const Gap(3),
                                                            TitleSubtitle(
                                                                title: state
                                                                            .voluntaryWorks[
                                                                                index]
                                                                            .toDate !=
                                                                        null
                                                                    ? "No"
                                                                    : "Yes",
                                                                sub:
                                                                    "Currently Involved"),
                                                            const Gap(3),
                                                            TitleSubtitle(
                                                                title: state
                                                                    .voluntaryWorks[
                                                                        index]
                                                                    .totalHours
                                                                    .toString(),
                                                                sub: "Total Hours"),
                                                            const Gap(3),
                                                            SizedBox(
                                                              child: state
                                                                          .voluntaryWorks[
                                                                              index]
                                                                          .address!
                                                                          .country!
                                                                          .name!
                                                                          .toLowerCase() !=
                                                                      'philippines'
                                                                  ? TitleSubtitle(
                                                                      title: state
                                                                          .voluntaryWorks[
                                                                              index]
                                                                          .address!
                                                                          .country!
                                                                          .name!,
                                                                      sub: "Country",
                                                                    )
                                                                  : Column(
                                                                      children: [
                                                                        TitleSubtitle(
                                                                          title: state
                                                                              .voluntaryWorks[
                                                                                  index]
                                                                              .address!
                                                                              .cityMunicipality!
                                                                              .province!
                                                                              .region!
                                                                              .description!,
                                                                          sub:
                                                                              "Region",
                                                                        ),
                                                                        const Gap(3),
                                                                        TitleSubtitle(
                                                                          title: state
                                                                              .voluntaryWorks[
                                                                                  index]
                                                                              .address!
                                                                              .cityMunicipality!
                                                                              .province!
                                                                              .description!,
                                                                          sub:
                                                                              "Province",
                                                                        ),
                                                                        const Gap(3),
                                                                        TitleSubtitle(
                                                                          title: state
                                                                              .voluntaryWorks[
                                                                                  index]
                                                                              .address!
                                                                              .cityMunicipality!
                                                                              .description!,
                                                                          sub:
                                                                              "City/Municipality",
                                                                        ),
                                                                      ],
                                                                    ),
                                                            )
                                                          ]),
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
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          position,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .titleMedium!
                                                              .copyWith(
                                                                  color: primary,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(agency,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .titleSmall),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          "$duration : $from to $to",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .labelMedium!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                            "$numberOfHours : $hours hours",
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .labelMedium!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                      ]),
                                                ),
                                                AppPopupMenu<int>(
                                                  offset: const Offset(-10, -10),
                                                  elevation: 3,
                                                  onSelected: (value) {
                                                    ////delete eligibilty-= = = = = = = = =>>
                                                    if (value == 2) {
                                                      confirmAlert(context, () {
                                                        BlocProvider.of<
                                                                    VoluntaryWorkBloc>(
                                                                context)
                                                            .add(DeleteVoluntaryWork(
                                                                work: state
                                                                        .voluntaryWorks[
                                                                    index],
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
                                                              .voluntaryWorks[index]
                                                              .address
                                                              ?.cityMunicipality ==
                                                          null) {
                                                        isOverseas = true;
                                                      } else {
                                                        isOverseas = false;
                                                      }
                                    
                                                      context
                                                          .read<VoluntaryWorkBloc>()
                                                          .add(ShowEditVoluntaryWorks(
                                                              profileId: profileId!,
                                                              token: token!,
                                                              work: state
                                                                      .voluntaryWorks[
                                                                  index],
                                                              isOverseas:
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
                                                        icon: Icons.delete)
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
                                  "You don't have any Voluntary Works added. Please click + to add.");
                        }
                      }
                      if (state is VolunataryWorkHistoryAddingErrorState) {
                        return SomethingWentWrong(
                            message:
                                "Error adding voluntary work. Please try again!",
                            onpressed: () {
                              context.read<VoluntaryWorkBloc>().add(
                                  AddVoluntaryWork(
                                      profileId: profileId!,
                                      token: token!,
                                      work: state.work));
                            });
                      }
                      if (state is VoluntaryWorkHistoryEditingErrorState) {
                        return SomethingWentWrong(
                            message:
                                "Error updating voluntary work. Please try again!",
                            onpressed: () {
                              context.read<VoluntaryWorkBloc>().add(
                                  UpdateVolunataryWork(
                                      oldAgencyId: state.oldAgencyId,
                                      oldFromDate: state.oldFromDate,
                                      oldPosId: state.oldPosId,
                                      profileId: profileId!,
                                      token: token!,
                                      work: state.work));
                            });
                      }
                      if (state is VoluntaryWorkHistoryDeletingErrorState) {
                        return SomethingWentWrong(
                            message:
                                "Error deleting voluntary work. Please try again!",
                            onpressed: () {
                              context.read<VoluntaryWorkBloc>().add(
                                  DeleteVoluntaryWork(
                                      profileId: profileId!,
                                      token: token!,
                                      work: state.work));
                            });
                      }
                      if (state is AddVoluntaryWorkState) {
                        return AddVoluntaryWorkScreen(
                          profileId: profileId!,
                          token: token!,
                        );
                      }
                      if (state is VoluntaryWorkErrorState) {
                        return SomethingWentWrong(
                            message: state.message,
                            onpressed: () {
                              context.read<VoluntaryWorkBloc>().add(
                                  GetVoluntarWorks(
                                      profileId: profileId!, token: token!));
                            });
                      }
                      if (state is ShowAddFormErrorState) {
                        return SomethingWentWrong(
                            message: "Something went wrong. Please try again!",
                            onpressed: () {
                              context
                                  .read<VoluntaryWorkBloc>()
                                  .add(ShowAddVoluntaryWorks());
                            });
                      }
                      if (state is EditVoluntaryWorks) {
                        return EditVoluntaryWorkScreen(
                          profileId: profileId!,
                          token: token!,
                        );
                      }
                      if (state is ShowEditFormErrorState) {
                        return SomethingWentWrong(
                            message: onError,
                            onpressed: () {
                              context.read<VoluntaryWorkBloc>().add(
                                  ShowEditVoluntaryWorks(
                                      profileId: profileId!,
                                      token: token!,
                                      work: state.work,
                                      isOverseas: state.isOverseas));
                            });
                      }
                      if (state is VolunataryWorkHistoryUpdatingErrorState) {
                        return SomethingWentWrong(
                            message: onError,
                            onpressed: () {
                              context.read<VoluntaryWorkBloc>().add(
                                  UpdateVolunataryWork(
                                      oldAgencyId: state.oldAgencyId,
                                      oldFromDate: state.oldFromDate,
                                      oldPosId: state.oldPosId,
                                      profileId: profileId!,
                                      token: token!,
                                      work: state.work));
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
      )),
    );
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
