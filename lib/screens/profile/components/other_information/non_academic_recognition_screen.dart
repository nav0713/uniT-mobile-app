import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:unit2/bloc/profile/profile_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/screens/profile/components/other_information/non_academic/add_modal.dart';
import 'package:unit2/screens/profile/components/other_information/non_academic/edit_modal.dart';
import 'package:unit2/theme-data.dart/box_shadow.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/empty_data.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';

import '../../../../bloc/profile/other_information/non_academic_recognition.dart/non_academic_recognition_bloc.dart';
import '../../../../utils/alerts.dart';
import '../../../../widgets/Leadings/close_leading.dart';

class NonAcademicRecognitionScreen extends StatelessWidget {
  const NonAcademicRecognitionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int? profileId;
    String? token;
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: context.watch<NonAcademicRecognitionBloc>().state
                    is AddNonAcademeRecognitionState
                ? const FittedBox(child: Text("Add $nonAcademicRecTitle"))
                : context.watch<NonAcademicRecognitionBloc>().state
                        is EditNonAcademeRecognitionState
                    ? const FittedBox(
                        child: Text("Edit $nonAcademicRecTitle"),
                      )
                    : const FittedBox(child: Text(nonAcademicRecTitle)),
            centerTitle: true,
            backgroundColor: primary,
            actions: (context.watch<NonAcademicRecognitionBloc>().state
                    is NonAcademicRecognitionLoadedState)
                ? [
                    AddLeading(onPressed: () {
                      context
                          .read<NonAcademicRecognitionBloc>()
                          .add(ShowAddNonAcademeRecognitionForm());
                    })
                  ]
                : (context.watch<NonAcademicRecognitionBloc>().state
                            is AddNonAcademeRecognitionState ||
                        context.watch<NonAcademicRecognitionBloc>().state
                            is EditNonAcademeRecognitionState)
                    ? [
                        CloseLeading(onPressed: () {
                          context
                              .read<NonAcademicRecognitionBloc>()
                              .add(const LoadNonAcademeRecognition());
                        })
                      ]
                    : []),
        body: LoadingProgress(

          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoggedIn) {
                token = state.userData!.user!.login!.token;
                profileId = state.userData!.user!.login!.user!.profileId!;
                return BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoaded) {
                      return BlocConsumer<NonAcademicRecognitionBloc,
                          NonAcademicRecognitionState>(
                        listener: (context, state) {
                          if (state is NonAcademicRecognitionLoadingState) {
                            final progress = ProgressHUD.of(context);
                            progress!.showWithText("Please wait...");
                          }
                          if (state is NonAcademicRecognitionLoadedState ||
                              state is NonAcademicRecognitionErrorState ||
                              state is AddNonAcademeRecognitionState ||
                              state is EditNonAcademeRecognitionState ||
                              state is NonAcademeRecognitionEditedState || state is AddNonAcademeRecognitionError || state is DeleteNonAcademeRecognitionError ) {
                            final progress = ProgressHUD.of(context);
                            progress!.dismiss();
                          }
                          ////ADDED STATE
                          if (state is NonAcademeRecognitionAddedState) {
                            if (state.response['success']) {
                              successAlert(context, "Adding Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<NonAcademicRecognitionBloc>()
                                    .add(const GetNonAcademicRecognition());
                              });
                            } else {
                              errorAlert(context, "Adding Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<NonAcademicRecognitionBloc>()
                                    .add(const GetNonAcademicRecognition());
                              });
                            }
                          }
                          ////DELETED STATE
                          if (state is NonAcademeRecognitionDeletedState) {
                            if (state.success) {
                              successAlert(context, "Deletion Successfull",
                                  "Non Academic Recognition has been deleted successfully", () {
                                Navigator.of(context).pop();
                                context
                                    .read<NonAcademicRecognitionBloc>()
                                    .add(const LoadNonAcademeRecognition());
                              });
                            } else {
                              errorAlert(context, "Deletion Failed",
                                  "Error deleting Non Academic Recognition", () {
                                Navigator.of(context).pop();
                                context
                                    .read<NonAcademicRecognitionBloc>()
                                    .add(const LoadNonAcademeRecognition());
                              });
                            }
                          }
                          ////EDITED STATE
                          if (state is NonAcademeRecognitionEditedState) {
                            if (state.response['success']) {
                              successAlert(context, "Update Successfull",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<NonAcademicRecognitionBloc>()
                                    .add(const LoadNonAcademeRecognition());
                              });
                            } else {
                              errorAlert(context, "Update Failed",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<NonAcademicRecognitionBloc>()
                                    .add(const LoadNonAcademeRecognition());
                              });
                            }
                          }
                        },
                        builder: (context, state) {
                          if (state is NonAcademicRecognitionLoadedState) {
                            if (state.nonAcademicRecognition.isNotEmpty) {
                              return ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  itemCount:
                                      state.nonAcademicRecognition.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String award = state
                                        .nonAcademicRecognition[index].title!;
                                    String presenter = state
                                        .nonAcademicRecognition[index]
                                        .presenter!
                                        .name!;
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      child: FlipAnimation(
                                        child: Column(
                                          children: [
                                            Container(
                                              width: screenWidth,
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
                                                        award,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight.w500,
                                                                color: primary),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(presenter),
                                                    ],
                                                  )),
                                                  AppPopupMenu<int>(
                                                    offset: const Offset(-10, -10),
                                                    elevation: 3,
                                                    onSelected: (value) {
                                                      ////delete non academic recognition-= = = = = = = = =>>
                                                      if (value == 1) {
                                                        confirmAlert(context, () {
                                                          context
                                                              .read<
                                                                  NonAcademicRecognitionBloc>()
                                                              .add(DeleteNonAcademeRecognition(
                                                                  nonAcademicRecognition:
                                                                      state
                                                                              .nonAcademicRecognition[
                                                                          index],
                                                                  profileId:
                                                                      profileId!,
                                                                  nonAcademicRecognitions:
                                                                      state
                                                                          .nonAcademicRecognition,
                                                                  token: token!));
                                                        }, "Delete?",
                                                            "Confirm Delete?");
                                                      }
                                                      if (value == 2) {
                                                        context
                                                            .read<
                                                                NonAcademicRecognitionBloc>()
                                                            .add(ShowEditNonAcademicRecognitionForm(
                                                                nonAcademicRecognition:
                                                                    state.nonAcademicRecognition[
                                                                        index]));
                                                      }
                                                    },
                                                    menuItems: [
                                                      popMenuItem(
                                                          text: "Update",
                                                          value: 2,
                                                          icon: Icons.edit),
                                                      popMenuItem(
                                                          text: "Remove",
                                                          value: 1,
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
                                      "You don't have any Non Academic Recognition added. Please click + to add");
                            }
                          }
                          if (state is NonAcademicRecognitionErrorState) {
                            return SomethingWentWrong(
                                message: state.message,
                                onpressed: () {
                                  context
                                      .read<NonAcademicRecognitionBloc>()
                                      .add(GetNonAcademicRecognition(
                                          profileId: profileId, token: token));
                                });
                          }
                          if (state is AddNonAcademeRecognitionState) {
                            return const AddNonAcademicRecognitionScreen();
                          }
                          if (state is EditNonAcademeRecognitionState) {
                            return const EditNonAcademicRecognitionScreen();
                          }if(state is AddNonAcademeRecognitionError){
                            return SomethingWentWrong(message: onError, onpressed: (){
                              context.read<NonAcademicRecognitionBloc>().add(AddNonAcademeRecognition(nonAcademicRecognition: state.nonAcademicRecognition, profileId: profileId!, token: token!));
                            });
                          }if( state is DeleteNonAcademeRecognitionError){
                            return SomethingWentWrong(message: onError, onpressed: (){
                              context.read<NonAcademicRecognitionBloc>().add(DeleteNonAcademeRecognition(nonAcademicRecognitions: state.nonAcademicRecognitions, nonAcademicRecognition: state.nonAcademicRecognition, profileId: profileId!, token: token!));
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
