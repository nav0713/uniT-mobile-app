import 'package:animate_do/animate_do.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:unit2/bloc/profile/primary_information/address/address_bloc.dart';
import 'package:unit2/bloc/profile/profile_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/screens/profile/components/basic_information/address/add_modal.dart';
import 'package:unit2/screens/profile/components/basic_information/address/edit_modal.dart';
import 'package:unit2/theme-data.dart/box_shadow.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/Leadings/close_leading.dart';
import 'package:unit2/widgets/empty_data.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import 'package:unit2/widgets/titlesubtitle.dart';

import '../../../../utils/alerts.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int? profileId;
    String? token;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: context.watch<AddressBloc>().state is AddAddressState
                ? const Text("Add Address")
                : context.watch<AddressBloc>().state is EditAddressState
                    ? const Text("Edit Address")
                    : const Text("Addresses"),
            centerTitle: true,
            backgroundColor: primary,
            actions: (context.watch<AddressBloc>().state is AddressLoadedState)
                ? [
                    AddLeading(onPressed: () {
                      context.read<AddressBloc>().add(ShowAddAddressForm());
                    })
                  ]
                : (context.watch<AddressBloc>().state is AddAddressState ||
                        context.watch<AddressBloc>().state is EditAddressState)
                    ? [
                        CloseLeading(onPressed: () {
                          context.read<AddressBloc>().add(LoadAddress());
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
                      return BlocConsumer<AddressBloc, AddressState>(
                        listener: (context, state) {
                          if (state is AddressLoadingState) {
                            final progress = ProgressHUD.of(context);
                            progress!.showWithText("Please wait...");
                          }
                          if (state is AddressLoadedState ||
                              state is ShowAddFormErrorState ||
                              state is AddressErrorState ||
                              state is AddAddressState ||
                              state is EditAddressState ||
                              state is AddressAddedState ||
                              state is EditAddressState ||
                              state is ShowEditFormErrorState ||
                              state is AddressUpdatedState ||
                              state is AddressErrorDelete ||state is AddAdressErrorState || state is UpdateErrorState) {
                            final progress = ProgressHUD.of(context);
                            progress!.dismiss();
                          }
                          ////Added State
                          if (state is AddressAddedState) {
                            if (state.response['success']) {
                              successAlert(context, "Adding Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context.read<AddressBloc>().add(LoadAddress());
                              });
                            } else {
                              errorAlert(context, "Adding Failed",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context.read<AddressBloc>().add(LoadAddress());
                              });
                            }
                          }
                          ////updated State
                          if (state is AddressUpdatedState) {
                            if (state.response['success']) {
                              successAlert(context, "Update Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context.read<AddressBloc>().add(LoadAddress());
                              });
                            } else {
                              errorAlert(context, "Update Failed",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context.read<AddressBloc>().add(LoadAddress());
                              });
                            }
                          }
                          //// Deleted
                          if (state is AddressDeletedState) {
                            if (state.success) {
                              successAlert(context, "Delete Successfull",
                                  "Address has been deleted successfully", () {
                                Navigator.of(context).pop();
                                context.read<AddressBloc>().add(LoadAddress());
                              });
                            } else {
                              errorAlert(context, "Deletion Failed",
                                  "Error deleting Address", () {
                                Navigator.of(context).pop();
                                context.read<AddressBloc>().add(LoadAddress());
                              });
                            }
                          }
                        },
                        builder: (context, state) {
                          if (state is AddressLoadedState) {
                            bool overseas;
                            String? cityMunicipality;
                            String? province;
                            String? region;
                            String? barangay;
                            if (state.addresses.isNotEmpty) {
                              return ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  itemCount: state.addresses.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String? subdivision =
                                        state.addresses[index].details ?? 'N/A';
                                    String? category = state.addresses[index]
                                            .address?.category?.name ??
                                        '';

                                    if (state.addresses[index].address
                                            ?.cityMunicipality !=
                                        null) {
                                      barangay = state.addresses[index].address!
                                                  .barangay !=
                                              null
                                          ? '${state.addresses[index].address!.barangay!.description!.toUpperCase()},'
                                          : '';
                                      cityMunicipality = state
                                          .addresses[index]
                                          .address!
                                          .cityMunicipality!
                                          .description!;
                                      province = state
                                          .addresses[index]
                                          .address!
                                          .cityMunicipality!
                                          .province!
                                          .description!;
                                      region = state
                                          .addresses[index]
                                          .address!
                                          .cityMunicipality!
                                          .province!
                                          .region!
                                          .description!;
                                      overseas = false;
                                    } else {
                                      overseas = true;
                                    }

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
                                                          backgroundColor:
                                                              Colors.white,
                                                          title: const Column(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .person_pin_circle,
                                                                color: primary,
                                                                size: 32,
                                                              ),
                                                              Text(
                                                                "Address Details",
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
                                                                    .addresses[index]
                                                                    .address!
                                                                    .category!
                                                                    .name!,
                                                                sub: "Category",
                                                              ),
                                                              const Gap(3),
                                                              TitleSubtitle(
                                                                title: state
                                                                        .addresses[
                                                                            index]
                                                                        .address!
                                                                        .areaClass ??
                                                                    'N/A',
                                                                sub: "Area Class",
                                                              ),
                                                              SizedBox(
                                                                child: Column(
                                                                  children: [
                                                                    Gap(state.addresses[index].subdivision?.lotNo ==
                                                                                null ||
                                                                            state.addresses[index].subdivision
                                                                                    ?.blockNo ==
                                                                                null
                                                                        ? 0
                                                                        : 3),
                                                                    state.addresses[index].subdivision?.lotNo ==
                                                                                null ||
                                                                            state.addresses[index].subdivision
                                                                                    ?.blockNo ==
                                                                                null
                                                                        ? const SizedBox()
                                                                        : TitleSubtitle(
                                                                            title: state.addresses[index].subdivision?.lotNo ==
                                                                                    null
                                                                                ? ''
                                                                                : '${state.addresses[index].subdivision!.lotNo}, ${state.addresses[index].subdivision?.blockNo == null ? '' : state.addresses[index].subdivision?.blockNo.toString()}',
                                                                            sub:
                                                                                "Lot and Block Number",
                                                                          ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const Gap(3),
                                                              TitleSubtitle(
                                                                title: state
                                                                        .addresses[
                                                                            index]
                                                                        .details ??
                                                                    'N/A',
                                                                sub: "Details",
                                                              ),
                                                              const Gap(3),
                                                              SizedBox(
                                                                child: state
                                                                            .addresses[
                                                                                index]
                                                                            .address!
                                                                            .country!
                                                                            .name!
                                                                            .toLowerCase() !=
                                                                        'philippines'
                                                                    ? TitleSubtitle(
                                                                        title: state
                                                                            .addresses[
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
                                                                                .addresses[
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
                                                                                .addresses[
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
                                                                                .addresses[
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
                                                                                    .addresses[index]
                                                                                    .address
                                                                                    ?.barangay
                                                                                    ?.description ??
                                                                                'N/A',
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
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: screenWidth,
                                                    decoration: box1(),
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                            8, 16, 0, 16),
                                                    child: Row(children: [
                                                      Expanded(
                                                          child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: screenWidth,
                                                            child: Row(
                                                              children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    subdivision,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .titleMedium!
                                                                        .copyWith(
                                                                            color:
                                                                                primary,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: subdivision
                                                                          .isEmpty
                                                                      ? 0
                                                                      : 24,
                                                                ),
                                                                Flexible(
                                                                  child: Text(
                                                                    category,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodySmall,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          Container(
                                                              child: overseas
                                                                  ? Text(
                                                                      "COUNTRY: ${state.addresses[index].address?.country?.name?.toUpperCase()}",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleSmall,
                                                                    )
                                                                  : Text(
                                                                      "$barangay $cityMunicipality, $province, $region",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleSmall,
                                                                    )),
                                                        ],
                                                      )),
                                                      AppPopupMenu<int>(
                                                        offset:
                                                            const Offset(-10, -10),
                                                        elevation: 3,
                                                        onSelected: (value) {
                                                          ////delete eligibilty-= = = = = = = = =>>
                                                          if (value == 2) {
                                                            confirmAlert(context,
                                                                () {
                                                              final progress =
                                                                  ProgressHUD.of(
                                                                      context);
                                                              progress!
                                                                  .showWithText(
                                                                      "Loading...");
                                                              context
                                                                  .read<
                                                                      AddressBloc>()
                                                                  .add(DeleteAddress(
                                                                      id: state
                                                                          .addresses[
                                                                              index]
                                                                          .id!,
                                                                      profileId:
                                                                          profileId
                                                                              .toString(),
                                                                      token:
                                                                          token!));
                                                            }, "Delete?",
                                                                "Confirm Delete?");
                                                          }
                                                          if (value == 1) {
                                                            bool overseas;
                                                            ////edit address-= = = = = = = = =>>
                                        
                                                            if (state
                                                                    .addresses[
                                                                        index]
                                                                    .address
                                                                    ?.cityMunicipality ==
                                                                null) {
                                                              overseas = true;
                                                            } else {
                                                              overseas = false;
                                                            }
                                                            context
                                                                .read<AddressBloc>()
                                                                .add(ShowEditAddressForm(
                                                                    overseas:
                                                                        overseas,
                                                                    address: state
                                                                            .addresses[
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
                                                        ],
                                                        icon: const Icon(
                                                          Icons.more_vert,
                                                          color: Colors.grey,
                                                        ),
                                                        tooltip: "Options",
                                                      )
                                                    ]),
                                                  ),
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
                                      "You don't have address added. Please click + to add.");
                            }
                          }
                          if (state is AddressErrorState) {
                            return SomethingWentWrong(
                                message: state.message,
                                onpressed: () {
                                  context
                                      .read<AddressBloc>()
                                      .add(LoadAddress());
                                });
                          }
                          if (state is AddAddressState) {
                            return AddAddressScreen(
                                profileId: profileId!, token: token!);
                          }
                          if (state is EditAddressState) {
                            return EditAddressScreen(
                                profileId: profileId!, token: token!);
                          }
                          if (state is ShowAddFormErrorState) {
                            return SomethingWentWrong(
                                message: onError,
                                onpressed: () {
                                  context
                                      .read<AddressBloc>()
                                      .add(ShowAddAddressForm());
                                });
                          }
                          if (state is ShowEditFormErrorState) {
                            return SomethingWentWrong(
                                message: onError,
                                onpressed: () {
                                  context.read<AddressBloc>().add(
                                      ShowEditAddressForm(
                                          address: state.address,
                                          overseas: state.isOverSeas));
                                });
                          }
                          if (state is AddressErrorDelete) {
                            return SomethingWentWrong(
                                message: onError,
                                onpressed: () {
                                    context.read<AddressBloc>().add(
                                        DeleteAddress(
                                          token: token!,
                                            id: state.id,
                                            profileId: profileId.toString()));
                            
                                });
                          }if(state is UpdateErrorState){
                            return SomethingWentWrong(message: onError, onpressed: (){
                              context.read<AddressBloc>().add(UpdateAddress(address: state.address, profileId: profileId!, token: token!, blockNumber: state.blockNumber, categoryId: state.categoryId, details: state.details, lotNumber: state.lotNumber));
                            });
                          }
                          
                          
                          if(state is AddAdressErrorState){
                            return SomethingWentWrong(message: onError, onpressed: (){
                              context.read<AddressBloc>().add(AddAddress(details: state.details, address: state.address,categoryId: state.categoryId,blockNumber: state.blockNumber,lotNumber: state.lotNumber,token: token!,profileId: profileId!));
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
