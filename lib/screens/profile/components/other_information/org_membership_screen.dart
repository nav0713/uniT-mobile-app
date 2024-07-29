import 'package:animate_do/animate_do.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:unit2/bloc/profile/profile_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/model/utils/agency.dart';
import 'package:unit2/screens/profile/components/other_information/org_membership/add_modal.dart';
import 'package:unit2/theme-data.dart/box_shadow.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/Leadings/close_leading.dart';
import 'package:unit2/widgets/empty_data.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import '../../../../bloc/profile/other_information/org_membership/organization_membership_bloc.dart';
import '../../../../model/utils/category.dart';
import '../../../../utils/alerts.dart';
import '../../../../utils/global.dart';

class OrgMembershipsScreen extends StatelessWidget {
  const OrgMembershipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? token;
    int? profileId;
    List<Agency> agencies = [];
    List<Category> agencyCategory = [];
    final orgBloc = BlocProvider.of<OrganizationMembershipBloc>(context);
    return Scaffold(
        appBar: AppBar(
            title: context.watch<OrganizationMembershipBloc>().state
                    is AddOrgMembershipState
                ? const FittedBox(child: Text("Add $orgMembershipTitle"))
                : const FittedBox(child:  Text(" $orgMembershipTitle")),
            backgroundColor: primary,
            centerTitle: true,
            actions: context.watch<OrganizationMembershipBloc>().state
                    is OrganizationMembershipLoaded
                ? [
                    AddLeading(onPressed: () {
               showDialog(context: (context),builder: (BuildContext context){
                return FadeInDown(
                  child: AlertDialog(
                    title: const Text("Add Organization Membership"),
                    content: AddOrgMemberShipScreen(profileId: profileId!, token: token!,agencies: agencies,agencyCategories: agencyCategory,bloc: orgBloc,),
                  ),
                );
               });
                    })
                  ]
                : context.watch<OrganizationMembershipBloc>().state
                        is AddOrgMembershipState
                    ? [
                        CloseLeading(onPressed: () {
                          context
                              .read<OrganizationMembershipBloc>()
                              .add(const GetOrganizationMembership());
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
                      return BlocConsumer<OrganizationMembershipBloc,
                          OrganizationMembershipState>(
                        listener: (context, state) {
                          if (state is OrgmembershipLoadingState) {
                            final progress = ProgressHUD.of(context);
                            progress!.showWithText("Please wait...");
                          }
                          if (state is OrganizationMembershipLoaded ||
                              state is OrganizationMembershipErrorState ||
                              state is AddOrgMembershipState ||
                              state is OrgMembershipDeletedState || state is AddOrgMembershipError || state is DeleteOrgMemberShipError) {
                            final progress = ProgressHUD.of(context);
                            progress!.dismiss();
                          }

                          ////ADDED STATE
                          if (state is OrgMembershipAddedState) {
                            if (state.response['success']) {
                              successAlert(context, "Adding Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<OrganizationMembershipBloc>()
                                    .add(LoadOrganizationMemberships());
                              });
                            } else {
                              errorAlert(context, "Adding Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<OrganizationMembershipBloc>()
                                    .add(LoadOrganizationMemberships());
                              });
                            }
                          }
                          ////DELETED STATE
                          if (state is OrgMembershipDeletedState) {
                            if (state.success) {
                              successAlert(context, "Deletion Successfull",
                                  "Organization Membership has been deleted successfully", () {
                                Navigator.of(context).pop();
                                context
                                    .read<OrganizationMembershipBloc>()
                                    .add(LoadOrganizationMemberships());
                              });
                            } else {
                              errorAlert(context, "Deletion Failed",
                                  "Error deleting Organization Membership", () {
                                Navigator.of(context).pop();
                                context
                                    .read<OrganizationMembershipBloc>()
                                    .add(LoadOrganizationMemberships());
                              });
                            }
                          }
                        },
                        builder: (context, state) {
                          if (state is OrganizationMembershipLoaded) {
                            agencies = state.agencies;
                            agencyCategory = state.agencyCategory;
                            if (state.orgMemberships.isNotEmpty) {
                              return ListView.builder(
                                  itemCount: state.orgMemberships.length,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String entity = state.orgMemberships[index]
                                                .agency!.privateEntity ==
                                            false
                                        ? governmentText.toUpperCase()
                                        : privateText.toUpperCase();
                                    String agencyName = state
                                        .orgMemberships[index].agency!.name!;
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      child: Column(
                                        children: [
                                          FlipAnimation(
                                            child: Container(
                                              width: screenWidth,
                                              decoration: box1(),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 8),
                                              child: Row(children: [
                                                Expanded(
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      agencyName,
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
                                                    Text(
                                                      entity,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium,
                                                    ),
                                                  ],
                                                )),
                                                AppPopupMenu<int>(
                                                  offset: const Offset(-10, -10),
                                                  elevation: 3,
                                                  onSelected: (value) {
                                                    ////delete orgmembership-= = = = = = = = =>>
                                                    if (value == 1) {
                                                      confirmAlert(context, () {
                                                        final progress =
                                                            ProgressHUD.of(context);
                                                        progress!.showWithText(
                                                            "Loading...");
                                                        context
                                                            .read<
                                                                OrganizationMembershipBloc>()
                                                            .add(DeleteOrgMemberShip(
                                                                profileId:
                                                                    profileId!,
                                                                token: token!,
                                                                org: state
                                                                        .orgMemberships[
                                                                    index]));
                                                      }, "Delete?",
                                                          "Confirm Delete?");
                                                    }
                                                  },
                                                  menuItems: [
                                                    popMenuItem(
                                                        text: "Delete",
                                                        value: 1,
                                                        icon: Icons.delete),
                                                  ],
                                                  icon: const Icon(
                                                    Icons.more_vert,
                                                    color: Colors.grey,
                                                  ),
                                                  tooltip: "Options",
                                                )
                                              ]),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            } else {
                              return const EmptyData(
                                  message:
                                      "You don't have any Orgazational Membership added. Please click + to add");
                            }
                          }
                       
                          if (state is OrganizationMembershipErrorState) {
                            return SomethingWentWrong(
                                message: state.message,
                                onpressed: () {
                                  context
                                      .read<OrganizationMembershipBloc>()
                                      .add(GetOrganizationMembership(
                                          token: token, profileId: profileId));
                                });
                          }if(state is AddOrgMembershipError){
                            return SomethingWentWrong(message: onError, onpressed: (){
                              context.read<OrganizationMembershipBloc>().add(AddOrgMembership(agency: state.agency, profileId: profileId!, token: token!));
                            });
                          }if(state is DeleteOrgMemberShipError){
                            return SomethingWentWrong(message: onError, onpressed: (){
                              context.read<OrganizationMembershipBloc>().add(DeleteOrgMemberShip(org: state.org,token: token!, profileId: profileId!));
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


// const EmptyData(message: "You don't have any Organization Membership added. Please click + to add."),
