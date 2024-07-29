import 'package:animate_do/animate_do.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:unit2/bloc/profile/primary_information/contact/contact_bloc.dart';
import 'package:unit2/bloc/profile/profile_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/screens/profile/components/basic_information/contact_information/add_modal.dart';
import 'package:unit2/screens/profile/components/basic_information/contact_information/edit_modal.dart';
import 'package:unit2/theme-data.dart/box_shadow.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/alerts.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/Leadings/close_leading.dart';
import 'package:unit2/widgets/empty_data.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import 'package:unit2/widgets/titlesubtitle.dart';

class ContactInformationScreen extends StatelessWidget {
  const ContactInformationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int profileId;
    String token;
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
              title: context.watch<ContactBloc>().state is ContactAddingState
                  ? const Text("Add Contact")
                  : context.watch<ContactBloc>().state is ContactEditingState
                      ? const Text("Edit Contact")
                      : const Text("Contact Information"),
              centerTitle: true,
              backgroundColor: primary,
              actions: context.watch<ContactBloc>().state is ContactLoadedState
                  ? [
                      AddLeading(onPressed: () {
                        context.read<ContactBloc>().add(ShowAddForm());
                      })
                    ]
                  : (context.watch<ContactBloc>().state is ContactAddingState ||
                          context.watch<ContactBloc>().state
                              is ContactEditingState)
                      ? [
                          CloseLeading(onPressed: () {
                            context.read<ContactBloc>().add(LoadContacts());
                          })
                        ]
                      : []),
          body: LoadingProgress(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoggedIn) {
                  token = state.userData!.user!.login!.token!;
                  profileId = state.userData!.user!.login!.user!.profileId!;
                  return BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileLoaded) {
                        return BlocConsumer<ContactBloc, ContactState>(
                          listener: (context, state) {
                            if (state is ContactLoadingState) {
                              final progress = ProgressHUD.of(context);
                              progress!.showWithText("Please wait...");
                            }
                            if (state is ContactLoadedState || state is ShowAddFormErrorState ||
                        
                                state is ContactErrorState ||
                                state is ContactAddingState ||
                                state is ContactEditingState ||
                                state is ContactDeletedState ||
                                state is ContactAddedState ||
                                state is ContactEditedState ||
                                state is ContactDeletingErrorState ||
                                state is ContactEditingErrorState || state is ShowEditFormErrorState ||
                                state is ContactAddingErrorState) {
                              final progress = ProgressHUD.of(context);
                              progress!.dismiss();
                            }
                            ////ADDED CONTACT STATE
                            if (state is ContactAddedState) {
                              if (state.response['success']) {
                                successAlert(context, "Adding Successfull!",
                                    state.response['message'], () {
                                  Navigator.of(context).pop();
                                  context
                                      .read<ContactBloc>()
                                      .add(LoadContacts());
                                });
                              } else {
                                errorAlert(context, "Adding Failed",
                                    "Something went wrong. Please try again.",
                                    () {
                                  Navigator.of(context).pop();
                                  context
                                      .read<ContactBloc>()
                                      .add(LoadContacts());
                                });
                              }
                            }

                            ////EDIT CONTACT STATE
                            if (state is ContactEditedState) {
                              if (state.response['success']) {
                                successAlert(context, "Update Successfull!",
                                    state.response['message'], () {
                                  Navigator.of(context).pop();
                                  context
                                      .read<ContactBloc>()
                                      .add(LoadContacts());
                                });
                              } else {
                                errorAlert(context, "Update Failed",
                                    "Something went wrong. Please try again.",
                                    () {
                                  Navigator.of(context).pop();
                                  context
                                      .read<ContactBloc>()
                                      .add(LoadContacts());
                                });
                              }
                            }

                            ////DELETED STATE
                            if (state is ContactDeletedState) {
                              if (state.succcess) {
                                successAlert(context, "Deletion Successfull",
                                    "Contact Info has been deleted successfully",
                                    () {
                                  Navigator.of(context).pop();
                                  context
                                      .read<ContactBloc>()
                                      .add(LoadContacts());
                                });
                              } else {
                                errorAlert(context, "Deletion Failed",
                                    "Error deleting Contact Info", () {
                                  Navigator.of(context).pop();
                                  context
                                      .read<ContactBloc>()
                                      .add(LoadContacts());
                                });
                              }
                            }
                          },
                          builder: (context, state) {
                            if (state is ContactLoadedState) {
                              if (state.contactInformation.isNotEmpty) {
                                return ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 10),
                                    itemCount: state.contactInformation.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      String numberMail = state
                                          .contactInformation[index]
                                          .numbermail!;
                                      String commService = state
                                          .contactInformation[index]
                                          .commService!
                                          .serviceProvider!
                                          .alias!;
                                      return AnimationConfiguration.staggeredList(
                                        duration: const Duration(milliseconds: 500),
                                        position: index,
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
                                                                  Icons.contact_mail,
                                                                  color: primary,
                                                                  size: 32,
                                                                ),
                                                                Text(
                                                                  "Contact Information Details",
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
                                                                      .contactInformation[
                                                                          index]
                                                                      .commService!
                                                                      .serviceProvider!
                                                                      .agency!
                                                                      .name!,
                                                                  sub:
                                                                      "Service Provider",
                                                                ),
                                                                const Gap(3),
                                                                     TitleSubtitle(
                                                                  title: state
                                                                      .contactInformation[
                                                                          index]
                                                                     .commService!.serviceType!.name!,
                                                                                                          
                                                                  sub:
                                                                      "Service Type",
                                                                ),
                                                                const Gap(3),
                                                                   TitleSubtitle(
                                                                  title: state
                                                                      .contactInformation[
                                                                          index]
                                                                     .numbermail!,
                                                                                                          
                                                                  sub:
                                                                      "Number/Mail",
                                                                ),
                                                                const Gap(3),
                                                                     TitleSubtitle(
                                                                  title: state
                                                                      .contactInformation[
                                                                          index].primary != null? state.contactInformation[index].primary ==true? "YES":"NO":"NO",
                                                                                                          
                                                                                                          
                                                                  sub:
                                                                      "Primary",
                                                                ),
                                                                  const Gap(3),
                                                                     TitleSubtitle(
                                                                  title: state
                                                                      .contactInformation[
                                                                          index].active != null? state.contactInformation[index].active ==true? "YES":"NO":"NO",
                                                                                                          
                                                                                                          
                                                                  sub:
                                                                      "Active",
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                                child: Container(
                                                  decoration: box1(),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          12, 12, 0, 12),
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
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                        numberMail,
                                                                        style: Theme.of(
                                                                                context)
                                                                            .textTheme
                                                                            .titleMedium!
                                                                            .copyWith(
                                                                                fontWeight:
                                                                                    FontWeight.w500,
                                                                                color: primary)),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 8,
                                                              ),
                                                              SizedBox(
                                                                width: screenWidth,
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        commService
                                                                            .toString()
                                                                            .toUpperCase(),
                                                                        style: Theme.of(
                                                                                context)
                                                                            .textTheme
                                                                            .titleSmall,
                                                                      ),
                                                                    ),
                                                                    state.contactInformation[index]
                                                                                .active ==
                                                                            true
                                                                        ? const Badge(
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                            label:
                                                                                Text(
                                                                              "Active",
                                                                            ),
                                                                          )
                                                                        : const Badge(
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                            label:
                                                                                Text(
                                                                              "Inactive",
                                                                            ),
                                                                          ),
                                                                    const SizedBox(
                                                                        width: 5),
                                                                    state.contactInformation[index]
                                                                                .primary ==
                                                                            true
                                                                        ? const Badge(
                                                                            backgroundColor:
                                                                                Colors.blue,
                                                                            label: Text(
                                                                                "Primary"),
                                                                          )
                                                                        : const SizedBox()
                                                                  ],
                                                                ),
                                                              ),
                                                              Text(state
                                                                  .contactInformation[
                                                                      index]
                                                                  .commService!
                                                                  .serviceProvider!
                                                                  .agency!
                                                                  .name
                                                                  .toString()),
                                                            ]),
                                                      ),
                                                      AppPopupMenu<int>(
                                                        offset:
                                                            const Offset(-10, -10),
                                                        elevation: 3,
                                                        onSelected: (value) {
                                                          ////delete contact-= = = = = = = = =>>
                                                          if (value == 2) {
                                                            confirmAlert(context,
                                                                () {
                                                              context
                                                                  .read<
                                                                      ContactBloc>()
                                                                  .add(DeleteContactInformation(
                                                                      contactInfo:
                                                                          state.contactInformation[
                                                                              index],
                                                                      profileId:
                                                                          profileId,
                                                                      token:
                                                                          token));
                                                            }, "Delete?",
                                                                "Are you sure you want to delete this contact info?");
                                                          }
                                                          if (value == 1) {
                                                            ////edit contact-= = = = = = = = =>>
                                                            context
                                                                .read<ContactBloc>()
                                                                .add(ShowEditForm(
                                                                    contactInfo:
                                                                        state.contactInformation[
                                                                            index]));
                                                            final progress =
                                                                ProgressHUD.of(
                                                                    context);
                                                            progress!.showWithText(
                                                                "Loading...");
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
                                        "You don't have contact information added. Please click + to add");
                              }
                            }
                            if (state is ContactAddingState) {
                              return AddContactInformationScreen(
                                profileId: profileId,
                                token: token,
                              );
                            }
                            if (state is ContactEditingState) {
                              return EditContactInformationScreen(
                                  profileId: profileId, token: token);
                            }
                            if (state is ContactAddingErrorState) {
                              return SomethingWentWrong(
                                  message:
                                      "Error adding contact information. Please try again",
                                  onpressed: () {
                                    context.read<ContactBloc>().add(
                                        AddContactInformation(
                                            contactInfo: state.contactInfo,
                                            profileId: profileId,
                                            token: token));
                                  });
                            }
                            if (state is ContactEditingErrorState) {
                              return SomethingWentWrong(
                                  message:
                                      "Error editing contact information. Please try again",
                                  onpressed: () {
                                    context.read<ContactBloc>().add(
                                        EditContactInformation(
                                            contactInfo: state.contactInfo,
                                            profileId: profileId,
                                            token: token));
                                  });
                            }
                            if (state is ContactDeletingErrorState) {
                              return SomethingWentWrong(
                                  message:
                                      "Error deleting contact information. Please try again",
                                  onpressed: () {
                                    context.read<ContactBloc>().add(
                                        DeleteContactInformation(
                                            contactInfo: state.contactInfo,
                                            profileId: profileId,
                                            token: token));
                                  });
                            }
                            if (state is ContactErrorState) {
                              return SomethingWentWrong(
                                  message: state.message,
                                  onpressed: () {
                                    context
                                        .read<ContactBloc>()
                                        .add(LoadContacts());
                                  });
                            }if(state is ShowAddFormErrorState){
                              return SomethingWentWrong(message: onError, onpressed: (){
                                context.read<ContactBloc>().add(ShowAddForm());
                              });
                            }if(state is ShowEditFormErrorState){
                              return SomethingWentWrong(message: onError, onpressed: (){
                                 context
                                                            .read<ContactBloc>()
                                                            .add(ShowEditForm(
                                                                contactInfo:
                                                                    state.contactInfo));
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
