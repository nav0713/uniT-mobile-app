import 'package:animate_do/animate_do.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:gap/gap.dart';
import 'package:unit2/bloc/profile/profile_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/screens/profile/components/reference/add_modal.dart';
import 'package:unit2/screens/profile/components/reference/edit_modal.dart';
import 'package:unit2/theme-data.dart/box_shadow.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/Leadings/close_leading.dart';
import 'package:unit2/widgets/empty_data.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import 'package:unit2/widgets/titlesubtitle.dart';
import '../../../bloc/profile/references/references_bloc.dart';
import '../../../utils/alerts.dart';

class ReferencesScreen extends StatelessWidget {
  const ReferencesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    int? profileId;
    String? token;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: context.watch<ReferencesBloc>().state is AddReferenceState
                ? const Text("Add Personal Reference")
                : context.watch<ReferencesBloc>().state is EditReferenceState
                    ? const Text("Edit Personal Reference")
                    : const Text("Personal References"),
            centerTitle: true,
            backgroundColor: primary,
            ////if state is adding or editing state show close button
            actions: (context.watch<ReferencesBloc>().state
                        is AddReferenceState ||
                    context.watch<ReferencesBloc>().state is EditReferenceState)
                ? [
                    //// close button
                    CloseLeading(onPressed: () {
                      context.read<ReferencesBloc>().add(LoadReferences());
                    }),
                  ]
                :
                //// if state is loaded state show add button
                context.watch<ReferencesBloc>().state is ReferencesLoadedState
                    ? [
                        AddLeading(onPressed: () {
                          context
                              .read<ReferencesBloc>()
                              .add(ShowAddReferenceForm());
                        }),
                      ]
                    : []),
        body: LoadingProgress(

          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              //userbloc
              if (state is UserLoggedIn) {
                token = state.userData!.user!.login!.token;
                profileId = state.userData!.user!.login!.user!.profileId;
                return BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    //profilebloc
                    if (state is ProfileLoaded) {
                      return BlocConsumer<ReferencesBloc, ReferencesState>(
                        //listener
                        listener: (context, state) {
                          if (state is ReferencesLoadingState) {
                            final progress = ProgressHUD.of(context);
                            progress!.showWithText("Please wait...");
                          }
                          if (state is ReferencesLoadedState || state is ShowAddFormErrorState ||
                              state is AddReferenceState ||
                              state is ReferencesErrorState ||
                              state is DeleteReferenceState ||
                              state is ReferencesAddedState ||
                              state is EditReferenceState ||
                              state is ReferencesAddingErrorState ||
                              state is ReferenceUpdatingErrorState || state is ShowEditFormErrorState ||
                              state is ReferenceDeletingErrorState) {
                            final progress = ProgressHUD.of(context);
                            progress!.dismiss();
                          }
                          ////ADDED STATE
                          if (state is ReferencesAddedState) {
                            if (state.response['success']) {
                              successAlert(context, "Adding Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<ReferencesBloc>()
                                    .add(LoadReferences());
                              });
                            } else {
                              errorAlert(context, "Adding Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<ReferencesBloc>()
                                    .add(LoadReferences());
                              });
                            }
                          }
                          ////EDIT REFERENCE STATE
                          if (state is ReferenceEditedState) {
                            if (state.response['success']) {
                              successAlert(context, "Update Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<ReferencesBloc>()
                                    .add(LoadReferences());
                              });
                            } else {
                              errorAlert(context, "Update Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<ReferencesBloc>()
                                    .add(LoadReferences());
                              });
                            }
                          }

                          ////DELETED STATE
                          if (state is DeleteReferenceState) {
                            if (state.success) {
                              successAlert(context, "Deletion Successfull",
                                  "Personal reference has been deleted successfully",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<ReferencesBloc>()
                                    .add(LoadReferences());
                              });
                            } else {
                              errorAlert(context, "Deletion Failed",
                                  "Error Deleting Personal reference", () {
                                Navigator.of(context).pop();
                                context
                                    .read<ReferencesBloc>()
                                    .add(LoadReferences());
                              });
                            }
                          }
                        },
                        //builder
                        builder: (context, state) {
                          //references bloc
                          if (state is ReferencesLoadedState) {
                            if (state.references.isNotEmpty) {
                              return ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  itemCount: state.references.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String? middlename =
                                        state.references[index].middleName ??
                                            "";
                                    String fullname =
                                        "${state.references[index].firstName} $middlename ${state.references[index].lastName}";
                                    String addres = state.references[index]
                                                .address!.country?.id !=
                                            175
                                        ? "COUNTRY: ${state.references[index].address!.country!.name!.toUpperCase()}"
                                        : "${state.references[index].address?.cityMunicipality?.description}, ${state.references[index].address?.cityMunicipality?.province?.description}, ${state.references[index].address?.cityMunicipality?.province?.region?.description}";

                                    String mobile = state
                                        .references[index].contactNo
                                        .toString();
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
                                                    builder:
                                                        (BuildContext context) {
                                                      return ZoomIn(
                                                        child: AlertDialog(
                                                          title:  Column(
                                                            children: [
                                                              const Icon(
                                                                FontAwesome5.id_card,
                                                                color: primary,
                                                                size: 32,
                                                              ),
                                                              const Text(
                                                                "References Details",
                                                                style: TextStyle(
                                                                    color: primary,
                                                                    fontSize: 18),
                                                              ).animate(),
                                                              const Divider(),
                                                            ],
                                                          ),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize.min,
                                                            children: [
                                                              TitleSubtitle(
                                                                  title: state
                                                                      .references[
                                                                          index]
                                                                      .firstName!,
                                                                  sub: "First name"),
                                                                  const Gap(3),
                                                                  TitleSubtitle(title: state.references[index].middleName??'N/A', sub: "Middle name"),
                                                                  const Gap(3),
                                                                  TitleSubtitle(title: state.references[index].lastName!, sub: "Last name"),
                                                                  const Gap(3),
                                                                  TitleSubtitle(title: state.references[index].address!.addressCategory!.name!, sub: "Address Category"),
                                                                  const Gap(3),
                                                                                                                              TitleSubtitle(title: state.references[index].contactNo!, sub: "Phone/Mobile Number"),
                                                                                                                              const Gap(3),
                                                                  SizedBox(
                                                                child: state
                                                                            .references[
                                                                                index]
                                                                            .address!
                                                                            .country!
                                                                            .name!
                                                                            .toLowerCase() !=
                                                                        'philippines'
                                                                    ? TitleSubtitle(
                                                                        title: state
                                                                            .references[
                                                                                index]
                                                                            .address!
                                                                            .country!
                                                                            .name!,
                                                                        sub:
                                                                            "Country",
                                                                      )
                                                                    : Column(
                                                                        children: [
                                                                          TitleSubtitle(
                                                                            title: state
                                                                                .references[
                                                                                    index]
                                                                                .address!
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
                                                                                .references[
                                                                                    index]
                                                                                .address!
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
                                                                                .references[
                                                                                    index]
                                                                                .address!
                                                                                .cityMunicipality!
                                                                                .description!,
                                                                            sub:
                                                                                "City/Municipality",
                                                                          ),
                                                                           const Gap(
                                                                              3),
                                                                          TitleSubtitle(
                                                                            title: state
                                                                                .references[
                                                                                    index]
                                                                                .address!
                                                                                .barangay!.description!,
                                                                            sub:
                                                                                "Barangay",
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
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 12, vertical: 8),
                                                decoration: box1(),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              fullname
                                                                  .toUpperCase(),
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
                                                            height: 8,
                                                          ),
                                                          Text(addres,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          Text(
                                                              "${mobileOrPhone.toUpperCase()} : $mobile",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .labelMedium!),
                                                        ],
                                                      ),
                                                    ),
                                                    AppPopupMenu<int>(
                                                      offset:
                                                          const Offset(-10, -10),
                                                      elevation: 3,
                                                      onSelected: (value) {
                                                        ////delete eligibilty-= = = = = = = = =>>
                                                        if (value == 2) {
                                                          confirmAlert(context, () {
                                                            context
                                                                .read<
                                                                    ReferencesBloc>()
                                                                .add(DeleteReference(
                                                                    profileId:
                                                                        profileId!,
                                                                    refId: state
                                                                        .references[
                                                                            index]
                                                                        .id!,
                                                                    references: state
                                                                        .references,
                                                                    token: token!));
                                                          }, "Delete?",
                                                              "Confirm Delete?");
                                                        }
                                                        if (value == 1) {
                                                          ////edit reference-= = = = = = = = =>>
                                                   
                                                          context
                                                              .read<
                                                                  ReferencesBloc>()
                                                              .add(ShowEditReferenceForm(
                                                                  personalReference:
                                                                      state.references[
                                                                          index]));
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
                                                        popMenuItem(
                                                            text: "Attach",
                                                            value: 2,
                                                            icon:
                                                                Icons.attach_file),
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
                                      "You don't have any references added. Please click + to add.");
                            }
                          }
                          if (state is AddReferenceState) {
                            return AddReferenceScreen(
                              profileId: profileId!,
                              token: token!,
                            );
                          }
                          if (state is EditReferenceState) {
                            return EditReferenceScreen(
                              profileId: profileId!,
                              token: token!,
                            );
                          }
                          if (state is ReferencesErrorState) {
                            return SomethingWentWrong(
                                message: state.message,
                                onpressed: () {
                                  context.read<ReferencesBloc>().add(
                                      GetReferences(
                                          profileId: profileId!,
                                          token: token!));
                                });
                          }
                          if (state is ReferencesAddingErrorState) {
                            return SomethingWentWrong(
                                message:
                                    "Error adding Personal Reference. Please try again! ",
                                onpressed: () {
                                  context.read<ReferencesBloc>().add(
                                      AddReference(
                                          profileId: profileId!,
                                          reference: state.reference,
                                          token: token!));
                                });
                          }
                          if (state is ReferenceUpdatingErrorState) {
                            return SomethingWentWrong(
                                message:
                                    "Error updating Personal Reference. Please try again!",
                                onpressed: () {
                                  context.read<ReferencesBloc>().add(
                                      EditReference(
                                          profileId: profileId!,
                                          reference: state.reference,
                                          token: token!));
                                });
                          }
                          if (state is ReferenceDeletingErrorState) {
                            return SomethingWentWrong(
                                message:
                                    "Error deleting Personal Reference. Please try again!",
                                onpressed: () {
                                  context.read<ReferencesBloc>().add(
                                      DeleteReference(
                                          profileId: profileId!,
                                          refId: state.refId,
                                          references: state.references,
                                          token: token!));
                                });
                          }if(state is ShowAddFormErrorState){
                            return SomethingWentWrong(message: onError, onpressed: (){
                              context.read<ReferencesBloc>().add(ShowAddReferenceForm());
                            });
                          }if(state is ShowEditFormErrorState){
                            return SomethingWentWrong(message: onError, onpressed: (){
                                 context
                                                          .read<
                                                              ReferencesBloc>()
                                                          .add(ShowEditReferenceForm(
                                                              personalReference:
                                                                  state.personalReference));
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
