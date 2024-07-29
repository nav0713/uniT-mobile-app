import 'package:animate_do/animate_do.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:gap/gap.dart';
import 'package:unit2/bloc/profile/profile_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/model/profile/family_backround.dart';
import 'package:unit2/screens/profile/components/basic_information/family/add_mobile_modal.dart';
import 'package:unit2/screens/profile/components/basic_information/family/child_add_modal.dart';
import 'package:unit2/screens/profile/components/basic_information/family/child_edit_modal.dart';
import 'package:unit2/screens/profile/components/basic_information/family/father_edit_modal.dart';
import 'package:unit2/screens/profile/components/basic_information/family/mother_add_modal.dart';
import 'package:unit2/screens/profile/components/basic_information/family/mother_edit_modal.dart';
import 'package:unit2/screens/profile/components/basic_information/family/related_add_modal.dart';
import 'package:unit2/theme-data.dart/box_shadow.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/global_context.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/titlesubtitle.dart';
import '../../../bloc/profile/family/family_bloc.dart';
import '../../../model/utils/agency.dart';
import '../../../model/utils/category.dart';
import '../../../model/utils/position.dart';
import '../../../utils/alerts.dart';
import '../../../utils/profile_utilities.dart';
import '../../../widgets/progress_hud.dart';
import 'basic_information/family/father_add_modal.dart';
import 'basic_information/family/related_edit_modal.dart';
import 'basic_information/family/spouse_add_modal.dart';
import 'basic_information/family/spouse_edit_modal.dart';

class FamilyBackgroundScreen extends StatefulWidget {
  const FamilyBackgroundScreen({
    super.key,
  });

  @override
  State<FamilyBackgroundScreen> createState() => _FamilyBackgroundScreenState();
}

class _FamilyBackgroundScreenState extends State<FamilyBackgroundScreen> {
  FamilyBackground? father;
  FamilyBackground? mother;
  FamilyBackground? spouse;
  List<FamilyBackground> children = [];
  List<FamilyBackground> otherRelated = [];
  List<String> bloodType = [
    "NONE",
    "A+",
    "B+",
    "A-",
    "B-",
    "AB+",
    "AB-",
    "0+",
    "0-"
  ];
  List<String> nameExtensions = [
    "NONE",
    "N/A",
    "SR.",
    "JR.",
    "I",
    "II",
    "III",
    "IV",
    "V",
    "VI",
    "VII",
    "VIII",
    "IX",
    "X"
  ];
  List<String> sexes = ["MALE", "FEMALE"];
  List<String> civilStatus = [
    "NONE",
    "SINGLE",
    "MARRIED",
    "SEPARATED",
    "WIDOWED"
  ];
  List<String> gender = [
    "NONE",
    "AGENDER",
    "ANATOMAL SEX",
    "CISGENDER",
    "CISHET",
    "GENDER NON-CONFORMING",
    "GENDER-EXPANSIVE",
    "GENDER-FLUID",
    "GENDERQUEER",
    "GENDERVOID",
    "INTERSEX",
    "NON-BINARY",
    "TRANSGENDER",
    "OTHERS"
  ];
  List<PositionTitle> positions = [];
  List<Agency> agencices = [];
  List<Category> categories = [];
  bool fatherIncaseOfEmergency = false;
  List<Relationship>? relationshipTypes;
  final formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final familyBloc = BlocProvider.of<FamilyBloc>(context);
    int? profileId;
    String? token;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(familyBackgroundScreenTitle),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: LoadingProgress(
        child: BlocBuilder<UserBloc, UserState>(
          buildWhen: (previous, current) {
            return false;
          },
          builder: (context, state) {
            if (state is UserLoggedIn) {
              token = state.userData!.user!.login!.token;
              profileId = state.userData!.user!.login!.user!.profileId;
              return BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoaded) {
                    return BlocConsumer<FamilyBloc, FamilyState>(
                      listener: (context, state) {
                        if (state is FamilyLoadingState) {
                          final progress = ProgressHUD.of(context);
                          progress!.showWithText("Please wait...");
                        }
                        if (state is FamilyLoaded ||
                            state is FamilyErrorState ||
                            state is FamilyAddedState ||
                            state is DeletedState ||
                            state is FamilyErrorAddingState ||
                            state is FamilyErrorUpdatingState ||
                            state is FamilyErrorDeletingState) {
                          final progress = ProgressHUD.of(context);
                          progress!.dismiss();
                        }
                        ////AddedState
                        if (state is FamilyAddedState) {
                          if (state.response['success']) {
                            successAlert(context, "Adding Successfull!",
                                state.response['message'], () {
                              Navigator.of(context).pop();
                              context.read<FamilyBloc>().add(LoadFamily());
                            });
                          } else {
                            errorAlert(context, "Adding Failed",
                                "Something went wrong. Please try again.", () {
                              Navigator.of(context).pop();
                              context.read<FamilyBloc>().add(LoadFamily());
                            });
                          }
                        }
                        if (state is EmergencyContactEditedState) {
                          if (state.response['success']) {
                            successAlert(context, state.response['message'],
                                state.response[''], () {
                              Navigator.of(context).pop();
                              context.read<FamilyBloc>().add(LoadFamily());
                            });
                          } else {
                            errorAlert(context, state.response['message'],
                                "Something went wrong. Please try again.", () {
                              Navigator.of(context).pop();
                              context.read<FamilyBloc>().add(LoadFamily());
                            });
                          }
                        }
                        ////Edited State
                        if (state is FamilyEditedState) {
                          if (state.response['success']) {
                            successAlert(context, "Update Successfull!",
                                state.response['message'], () {
                              Navigator.of(context).pop();
                              context.read<FamilyBloc>().add(LoadFamily());
                            });
                          } else {
                            errorAlert(context, "Update Failed",
                                "Something went wrong. Please try again.", () {
                              Navigator.of(context).pop();
                              context.read<FamilyBloc>().add(LoadFamily());
                            });
                          }
                        }

                        if (state is DeletedState) {
                          if (state.success) {
                            successAlert(context, "Deletion Successfull",
                                "Family Background has been deleted successfully",
                                () {
                              Navigator.of(context).pop();
                              context.read<FamilyBloc>().add(LoadFamily());
                            });
                          } else {
                            errorAlert(context, "Deletion Failed",
                                "Error deleting Family", () {
                              Navigator.of(context).pop();
                              context.read<FamilyBloc>().add(LoadFamily());
                            });
                          }
                        }
                      },
                      builder: (context, state) {
                        if (state is FamilyLoaded) {
                          if (state.families != null) {
                            children.clear();
                            otherRelated.clear();
                            father = null;
                            mother = null;
                            spouse = null;
                            for (var family in state.families!) {
                              if (family.relationship!.id == 1) {
                                father = family;
                              }
                              if (family.relationship!.id == 2) {
                                mother = family;
                              }
                              if (family.relationship!.id == 3) {
                                spouse = family;
                              }
                              if (family.relationship!.id == 4) {
                                children.add(family);
                              }
                              if (family.relationship!.id! > 4) {
                                otherRelated.add(family);
                              }
                            }
                          }
                          return ListView(children: [
                            ////Father----------------------------------------------
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ZoomIn(
                                        child: AlertDialog(
                                          title: const Column(
                                            children: [
                                              Icon(
                                                FontAwesome5.user,
                                                color: primary,
                                                size: 32,
                                              ),
                                              Text(
                                                "Father Details",
                                                style: TextStyle(
                                                    color: primary,
                                                    fontSize: 18),
                                              ),
                                              Divider(),
                                            ],
                                          ),
                                          content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TitleSubtitle(
                                                    title:
                                                        "${father!.relatedPerson!.firstName!} ${father?.relatedPerson?.middleName ?? ''} ${father!.relatedPerson!.lastName} ${father?.relatedPerson?.nameExtension ?? ''}",
                                                    sub: "Fullname"),
                                                const Gap(3),
                                                TitleSubtitle(
                                                    title: dteFormat2.format(
                                                        father!.relatedPerson!
                                                            .birthdate!),
                                                    sub: "Birthdate"),
                                                const Gap(3),
                                                TitleSubtitle(
                                                    title: father!
                                                        .relatedPerson!.sex!,
                                                    sub: "Sex"),
                                                const Gap(3),
                                                TitleSubtitle(
                                                    title: father?.relatedPerson
                                                            ?.gender ??
                                                        'N/A',
                                                    sub: "Gender"),
                                                const Gap(3),
                                                TitleSubtitle(
                                                    title: father?.relatedPerson
                                                            ?.bloodType ??
                                                        'N/A',
                                                    sub: "Blood Type"),
                                                const Gap(3),
                                                TitleSubtitle(
                                                    title:
                                                        "${father?.relatedPerson?.heightM ?? 'N/A'}",
                                                    sub: "Height"),
                                                const Gap(3),
                                                TitleSubtitle(
                                                    title:
                                                        "${father?.relatedPerson?.weightKg ?? 'N/A'}",
                                                    sub: "Weight"),
                                                const Gap(3),
                                                TitleSubtitle(
                                                    title: father
                                                                ?.relatedPerson!
                                                                .deceased ==
                                                            true
                                                        ? 'YES'
                                                        : 'NO',
                                                    sub: "Deceased")
                                              ]),
                                        ),
                                      );
                                    });
                              },
                              child: SlideInLeft(
                                child: Container(
                                  decoration: box1(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  width: screenWidth,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      fatherText.toUpperCase(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .copyWith(
                                                              color: primary),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: father == null
                                                        ? IconButton(
                                                            onPressed: () {
                                                              ////Show Add Alert Dialog
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return ZoomIn(
                                                                      child: FatherAlert(
                                                                          familyBloc:
                                                                              familyBloc,
                                                                          profileId:
                                                                              profileId!,
                                                                          token:
                                                                              token!,
                                                                          bloodType:
                                                                              bloodType,
                                                                          civilStatus:
                                                                              civilStatus,
                                                                          gender:
                                                                              gender,
                                                                          nameExtensions:
                                                                              nameExtensions,
                                                                          sexes:
                                                                              sexes),
                                                                    );
                                                                  });
                                                            },
                                                            icon: const Icon(
                                                              Entypo.plus,
                                                              color: second,
                                                            ))
                                                        : const SizedBox(),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                  child: father != null
                                                      ? Row(
                                                          children: [
                                                            Expanded(
                                                              child: Flexible(
                                                                child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      ListTile(
                                                                        dense:
                                                                            true,
                                                                        visualDensity: const VisualDensity(
                                                                            horizontal:
                                                                                -4,
                                                                            vertical:
                                                                                -4),
                                                                        title:
                                                                            Text(
                                                                          "${father?.relatedPerson?.firstName} ${father?.relatedPerson?.middleName ?? ''} ${father?.relatedPerson!.lastName} ${father?.relatedPerson?.nameExtension ?? ''}",
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .titleMedium!
                                                                              .copyWith(fontWeight: FontWeight.w500),
                                                                        ),
                                                                        subtitle:
                                                                            const Text("fullname"),
                                                                      ),
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Checkbox(
                                                                              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                                                              value: father!.incaseOfEmergency!,
                                                                              onChanged: (value) {
                                                                                confirmAlertWithCancel(context, () {
                                                                                  final progress = ProgressHUD.of(context);
                                                                                  progress!.showWithText("Loading...");

                                                                                  context.read<FamilyBloc>().add(AddEmergencyEvent(requestType: "CHECKBOX", contactInfoId: father!.emergencyContact!.isNotEmpty ? father!.emergencyContact!.first.contactinfoid : null, numberMail: father!.emergencyContact!.isNotEmpty ? father!.emergencyContact!.first.numbermail : null, profileId: profileId!, relatedPersonId: father!.relatedPerson!.id!, token: token!));
                                                                                }, () {}, "Emergency Contact Information?", father!.incaseOfEmergency == true ? "Remove as emergency contact information?" : "Add as emergency contact information?");
                                                                              }),
                                                                          const Text(
                                                                              incaseOfEmergency),
                                                                          ////Add mobile icon
                                                                          Container(
                                                                              child: father!.incaseOfEmergency! && father!.emergencyContact!.isEmpty
                                                                                  ? IconButton(
                                                                                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                                                      onPressed: () {
                                                                                        showDialog(
                                                                                            context: context,
                                                                                            builder: (BuildContext context) {
                                                                                              return AddMobileNumber(
                                                                                                  onPressed: () {
                                                                                                    Navigator.of(_scaffoldKey.currentContext!).pop();
                                                                                                    familyBloc.add(AddEmergencyEvent(contactInfoId: father!.emergencyContact!.isNotEmpty ? father!.emergencyContact!.first.contactinfoid : null, numberMail: formKey.currentState!.value['number_mail'], profileId: profileId!, relatedPersonId: father!.relatedPerson!.id!, token: token!, requestType: "CONTACT"));
                                                                                                  },
                                                                                                  formKey: formKey);
                                                                                            });
                                                                                      },
                                                                                      icon: const Icon(
                                                                                        Entypo.plus_circled,
                                                                                        color: third,
                                                                                        size: 18,
                                                                                      ))
                                                                                  : Container())
                                                                        ],
                                                                      ),
                                                                      Visibility(
                                                                          visible:
                                                                              father!.incaseOfEmergency!,
                                                                          child: Container(
                                                                              child: father!.emergencyContact!.isNotEmpty
                                                                                  ? Row(
                                                                                      children: [
                                                                                        //// edit mobile
                                                                                        GestureDetector(
                                                                                          onTap: () {
                                                                                            showDialog(
                                                                                                context: context,
                                                                                                builder: (BuildContext context) {
                                                                                                  return AddMobileNumber(
                                                                                                      formKey: formKey,
                                                                                                      onPressed: () {
                                                                                                        Navigator.of(_scaffoldKey.currentContext!).pop();
                                                                                                        familyBloc.add(AddEmergencyEvent(contactInfoId: father!.emergencyContact!.isNotEmpty ? father!.emergencyContact!.first.contactinfoid : null, numberMail: formKey.currentState!.value['number_mail'], profileId: profileId!, relatedPersonId: father!.relatedPerson!.id!, token: token!, requestType: "CONTACT"));
                                                                                                      });
                                                                                                });
                                                                                          },
                                                                                          child: Row(
                                                                                            children: [
                                                                                              const SizedBox(
                                                                                                width: 16,
                                                                                              ),
                                                                                              Badge(
                                                                                                backgroundColor: third,
                                                                                                textColor: Colors.white,
                                                                                                label: Text(father!.emergencyContact!.first.numbermail!),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  : Container())),
                                                                    ]),
                                                              ),
                                                            ),
                                                            AppPopupMenu<int>(
                                                              offset:
                                                                  const Offset(
                                                                      -10, -10),
                                                              elevation: 3,
                                                              onSelected:
                                                                  (value) {
                                                                ////delete -= = = = = = = = =>>
                                                                if (value ==
                                                                    2) {
                                                                  confirmAlert(
                                                                      context,
                                                                      () {
                                                                    context.read<FamilyBloc>().add(DeleteFamily(
                                                                        id: father!
                                                                            .relatedPerson!
                                                                            .id!,
                                                                        profileId:
                                                                            profileId!,
                                                                        token:
                                                                            token!));
                                                                  }, "Delete?",
                                                                      "Confirm Delete?");
                                                                }
                                                                if (value ==
                                                                    1) {
                                                                  ////edit eligibilty-= = = = = = = = =>>
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return FatherEditAlert(
                                                                            familyBackground:
                                                                                father!,
                                                                            familyBloc:
                                                                                familyBloc,
                                                                            profileId:
                                                                                profileId!,
                                                                            token:
                                                                                token!,
                                                                            bloodType:
                                                                                bloodType,
                                                                            civilStatus:
                                                                                civilStatus,
                                                                            gender:
                                                                                gender,
                                                                            nameExtensions:
                                                                                nameExtensions,
                                                                            sexes:
                                                                                sexes);
                                                                      });
                                                                }
                                                              },
                                                              menuItems: [
                                                                popMenuItem(
                                                                    text:
                                                                        "Update",
                                                                    value: 1,
                                                                    icon: Icons
                                                                        .edit),
                                                                popMenuItem(
                                                                    text:
                                                                        "Remove",
                                                                    value: 2,
                                                                    icon: Icons
                                                                        .delete),
                                                              ],
                                                              icon: const Icon(
                                                                Icons.more_vert,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              tooltip:
                                                                  "Options",
                                                            )
                                                          ],
                                                        )
                                                      : SizedBox(
                                                          width: screenWidth,
                                                          child: Text(
                                                            "Provide your father's primary information.",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ))
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            ////Mother-----------------------------------------------------
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Column(
                                          children: [
                                            Icon(
                                              FontAwesome5.user,
                                              color: primary,
                                              size: 32,
                                            ),
                                            Text(
                                              "Mother Details",
                                              style: TextStyle(
                                                  color: primary, fontSize: 18),
                                            ),
                                            Divider(),
                                          ],
                                        ),
                                        content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TitleSubtitle(
                                                  title:
                                                      "${mother!.relatedPerson!.firstName!} ${mother?.relatedPerson?.middleName ?? ''} ${mother!.relatedPerson!.lastName} ${mother?.relatedPerson?.nameExtension ?? ''}",
                                                  sub: "Fullname"),
                                              const Gap(3),
                                              TitleSubtitle(
                                                  title: dteFormat2.format(
                                                      mother!.relatedPerson!
                                                          .birthdate!),
                                                  sub: "Birthdate"),
                                              const Gap(3),
                                              TitleSubtitle(
                                                  title: mother!
                                                      .relatedPerson!.sex!,
                                                  sub: "Sex"),
                                              const Gap(3),
                                              TitleSubtitle(
                                                  title: mother?.relatedPerson
                                                          ?.gender ??
                                                      'N/A',
                                                  sub: "Gender"),
                                              const Gap(3),
                                              TitleSubtitle(
                                                  title: mother?.relatedPerson
                                                          ?.bloodType ??
                                                      'N/A',
                                                  sub: "Blood Type"),
                                              const Gap(3),
                                              TitleSubtitle(
                                                  title:
                                                      "${mother?.relatedPerson?.heightM ?? 'N/A'}",
                                                  sub: "Height"),
                                              const Gap(3),
                                              TitleSubtitle(
                                                  title:
                                                      "${mother?.relatedPerson?.weightKg ?? 'N/A'}",
                                                  sub: "Weight"),
                                              const Gap(3),
                                              TitleSubtitle(
                                                  title: mother?.relatedPerson!
                                                              .deceased ==
                                                          true
                                                      ? 'YES'
                                                      : 'NO',
                                                  sub: "Deceased"),
                                              const Gap(10),
                                              const Text("Maiden name"),
                                              const Gap(3),
                                              TitleSubtitle(
                                                  title: mother!.relatedPerson!
                                                      .maidenName!.lastName!,
                                                  sub: "Last name"),
                                              const Gap(3),
                                              TitleSubtitle(
                                                  title: mother!.relatedPerson!
                                                      .maidenName!.middleName!,
                                                  sub: "Middle name"),
                                            ]),
                                      );
                                    });
                              },
                              child: SlideInLeft(
                                delay: const Duration(milliseconds: 200),
                                child: Container(
                                  decoration: box1(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  width: screenWidth,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    motherText.toUpperCase(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .copyWith(
                                                            color: primary),
                                                  ),
                                                ),
                                                Container(
                                                  child: mother == null
                                                      ? IconButton(
                                                          onPressed: () {
                                                            ////Show Alert Dialog
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return MotherAlert(
                                                                      familyBloc:
                                                                          familyBloc,
                                                                      token:
                                                                          token!,
                                                                      profileId:
                                                                          profileId!,
                                                                      bloodType:
                                                                          bloodType,
                                                                      civilStatus:
                                                                          civilStatus,
                                                                      gender:
                                                                          gender,
                                                                      nameExtensions:
                                                                          nameExtensions,
                                                                      sexes:
                                                                          sexes);
                                                                });
                                                          },
                                                          icon: const Icon(
                                                            Entypo.plus,
                                                            color: second,
                                                          ))
                                                      : const SizedBox(),
                                                )
                                              ],
                                            ),
                                            Container(
                                                child: mother != null
                                                    ? Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  ListTile(
                                                                    dense: true,
                                                                    visualDensity: const VisualDensity(
                                                                        horizontal:
                                                                            -4,
                                                                        vertical:
                                                                            -4),
                                                                    title: Text(
                                                                      "${mother?.relatedPerson?.firstName} ${mother?.relatedPerson?.middleName ?? ''} ${mother?.relatedPerson?.lastName} ${mother?.relatedPerson?.nameExtension ?? ''}",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium!
                                                                          .copyWith(
                                                                              fontWeight: FontWeight.w500),
                                                                    ),
                                                                    subtitle:
                                                                        const Text(
                                                                            "fullname"),
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Checkbox(
                                                                          visualDensity: const VisualDensity(
                                                                              horizontal:
                                                                                  0,
                                                                              vertical:
                                                                                  -4),
                                                                          value: mother!
                                                                              .incaseOfEmergency!,
                                                                          onChanged:
                                                                              (value) {
                                                                            confirmAlertWithCancel(context,
                                                                                () {
                                                                              final progress = ProgressHUD.of(context);
                                                                              progress!.showWithText("Loading...");

                                                                              context.read<FamilyBloc>().add(AddEmergencyEvent(requestType: 'CHECKBOX', contactInfoId: mother!.emergencyContact!.isNotEmpty ? mother!.emergencyContact!.first.contactinfoid : null, numberMail: mother!.emergencyContact!.isNotEmpty ? mother!.emergencyContact!.first.numbermail : null, profileId: profileId!, relatedPersonId: mother!.relatedPerson!.id!, token: token!));
                                                                            }, () {}, "Emergency Contact Information?",
                                                                                mother!.incaseOfEmergency == true ? "Remove as emergency contact information?" : "Add as emergency contact information?");
                                                                          }),
                                                                      const Text(
                                                                          incaseOfEmergency),
                                                                      Container(
                                                                          child: mother!.incaseOfEmergency! && mother!.emergencyContact!.isEmpty
                                                                              ? IconButton(
                                                                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                                                  onPressed: () {
                                                                                    showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext context) {
                                                                                          return AddMobileNumber(
                                                                                              onPressed: () {
                                                                                                Navigator.of(_scaffoldKey.currentContext!).pop();
                                                                                                familyBloc.add(AddEmergencyEvent(contactInfoId: mother!.emergencyContact!.isNotEmpty ? mother!.emergencyContact!.first.contactinfoid : null, numberMail: formKey.currentState!.value['number_mail'], profileId: profileId!, relatedPersonId: mother!.relatedPerson!.id!, token: token!, requestType: "CONTACT"));
                                                                                              },
                                                                                              formKey: formKey);
                                                                                        });
                                                                                  },
                                                                                  icon: const Icon(
                                                                                    Entypo.plus_circled,
                                                                                    color: third,
                                                                                    size: 18,
                                                                                  ))
                                                                              : Container())
                                                                    ],
                                                                  ),
                                                                  Visibility(
                                                                      visible:
                                                                          mother!
                                                                              .incaseOfEmergency!,
                                                                      child: Container(
                                                                          child: mother!.emergencyContact!.isNotEmpty
                                                                              ? Row(
                                                                                  children: [
                                                                                    //// edit mobile
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        showDialog(
                                                                                            context: context,
                                                                                            builder: (BuildContext context) {
                                                                                              return AddMobileNumber(
                                                                                                  formKey: formKey,
                                                                                                  onPressed: () {
                                                                                                    Navigator.of(_scaffoldKey.currentContext!).pop();
                                                                                                    familyBloc.add(AddEmergencyEvent(contactInfoId: mother!.emergencyContact!.isNotEmpty ? mother!.emergencyContact!.first.contactinfoid : null, numberMail: formKey.currentState!.value['number_mail'], profileId: profileId!, relatedPersonId: mother!.relatedPerson!.id!, token: token!, requestType: "CONTACT"));
                                                                                                  });
                                                                                            });
                                                                                      },
                                                                                      child: Row(
                                                                                        children: [
                                                                                          const SizedBox(
                                                                                            width: 16,
                                                                                          ),
                                                                                          Badge(
                                                                                            backgroundColor: third,
                                                                                            textColor: Colors.white,
                                                                                            label: Text(mother!.emergencyContact!.first.numbermail!),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              : Container())),
                                                                ]),
                                                          ),
                                                          AppPopupMenu<int>(
                                                            offset:
                                                                const Offset(
                                                                    -10, -10),
                                                            elevation: 3,
                                                            onSelected:
                                                                (value) {
                                                              ////delete -= = = = = = = = =>>
                                                              if (value == 2) {
                                                                confirmAlert(
                                                                    context,
                                                                    () {
                                                                  context.read<FamilyBloc>().add(DeleteFamily(
                                                                      id: mother!
                                                                          .relatedPerson!
                                                                          .id!,
                                                                      profileId:
                                                                          profileId!,
                                                                      token:
                                                                          token!));
                                                                }, "Delete?",
                                                                    "Confirm Delete?");
                                                              }
                                                              if (value == 1) {
                                                                ////edit eligibilty-= = = = = = = = =>>
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return MotherEditAlert(
                                                                          familyBackground:
                                                                              mother!,
                                                                          familyBloc:
                                                                              familyBloc,
                                                                          token:
                                                                              token!,
                                                                          profileId:
                                                                              profileId!,
                                                                          bloodType:
                                                                              bloodType,
                                                                          civilStatus:
                                                                              civilStatus,
                                                                          gender:
                                                                              gender,
                                                                          nameExtensions:
                                                                              nameExtensions,
                                                                          sexes:
                                                                              sexes);
                                                                    });
                                                              }
                                                            },
                                                            menuItems: [
                                                              popMenuItem(
                                                                  text:
                                                                      "Update",
                                                                  value: 1,
                                                                  icon: Icons
                                                                      .edit),
                                                              popMenuItem(
                                                                  text:
                                                                      "Remove",
                                                                  value: 2,
                                                                  icon: Icons
                                                                      .delete),
                                                            ],
                                                            icon: const Icon(
                                                              Icons.more_vert,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            tooltip: "Options",
                                                          )
                                                        ],
                                                      )
                                                    : SizedBox(
                                                        width: screenWidth,
                                                        child: Text(
                                                          "Provide your mother's primary information",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            ////Spouse ---------------------------------------------------------
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Column(
                                          children: [
                                            Icon(
                                              FontAwesome5.user,
                                              color: primary,
                                              size: 32,
                                            ),
                                            Text(
                                              "Spouse Details",
                                              style: TextStyle(
                                                  color: primary, fontSize: 18),
                                            ),
                                            Divider(),
                                          ],
                                        ),
                                        content: SizedBox(
                                          height: screenHeight,
                                          child: SingleChildScrollView(
                                            child: Column(children: [
                                              TitleSubtitle(
                                                  title:
                                                      "${spouse!.relatedPerson!.firstName!} ${spouse?.relatedPerson?.middleName ?? ''} ${spouse!.relatedPerson!.lastName} ${spouse?.relatedPerson?.nameExtension ?? ''}",
                                                  sub: "Fullname"),
                                              const Gap(3),
                                              TitleSubtitle(
                                                  title: dteFormat2.format(
                                                      mother!.relatedPerson!
                                                          .birthdate!),
                                                  sub: "Birthdate"),
                                              const Gap(3),
                                              TitleSubtitle(
                                                  title: spouse!
                                                      .relatedPerson!.sex!,
                                                  sub: "Sex"),
                                              const Gap(3),
                                              TitleSubtitle(
                                                  title: spouse?.relatedPerson
                                                          ?.gender ??
                                                      'N/A',
                                                  sub: "Gender"),
                                              const Gap(3),
                                              TitleSubtitle(
                                                  title: spouse?.relatedPerson
                                                          ?.bloodType ??
                                                      'N/A',
                                                  sub: "Blood Type"),
                                              const Gap(3),
                                              TitleSubtitle(
                                                  title:
                                                      "${spouse?.relatedPerson?.heightM ?? 'N/A'}",
                                                  sub: "Height"),
                                              const Gap(3),
                                              TitleSubtitle(
                                                  title:
                                                      "${spouse?.relatedPerson?.weightKg ?? 'N/A'}",
                                                  sub: "Weight"),
                                              const Gap(3),
                                              TitleSubtitle(
                                                  title: spouse?.relatedPerson!
                                                              .deceased ==
                                                          true
                                                      ? 'YES'
                                                      : 'NO',
                                                  sub: "Deceased"),
                                              SizedBox(
                                                child: spouse?.company != null
                                                    ? Column(
                                                        children: [
                                                          const Gap(10),
                                                          const Text(
                                                              "Occupation"),
                                                          const Gap(3),
                                                          TitleSubtitle(
                                                              title: spouse!
                                                                  .position!
                                                                  .title!,
                                                              sub: "Position"),
                                                          const Gap(3),
                                                          TitleSubtitle(
                                                              title: spouse!
                                                                  .company!
                                                                  .name!,
                                                              sub: "Company"),
                                                          const Gap(3),
                                                          TitleSubtitle(
                                                              title: spouse!
                                                                  .companyAddress!,
                                                              sub: "Address"),
                                                          const Gap(3),
                                                          TitleSubtitle(
                                                              title: spouse!
                                                                  .companyContactNumber!,
                                                              sub: "Contact")
                                                        ],
                                                      )
                                                    : const SizedBox(),
                                              )
                                            ]),
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: SlideInLeft(
                                delay: const Duration(milliseconds: 250),
                                child: Container(
                                  decoration: box1(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  width: screenWidth,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    spouseText.toUpperCase(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .copyWith(
                                                            color: primary),
                                                  ),
                                                ),
                                                Container(
                                                  child: spouse == null
                                                      ? IconButton(
                                                          ////spouse
                                                          //// Show Dialog
                                                          onPressed: () async {
                                                            final progress =
                                                                ProgressHUD.of(
                                                                    context);
                                                            progress!
                                                                .showWithText(
                                                                    "Loading...");
                                                            try {
                                                              if (positions
                                                                  .isEmpty) {
                                                                positions =
                                                                    await ProfileUtilities
                                                                        .instance
                                                                        .getAgencyPosition();
                                                              }

                                                              if (agencices
                                                                  .isEmpty) {
                                                                agencices =
                                                                    await ProfileUtilities
                                                                        .instance
                                                                        .getAgecies();
                                                              }
                                                              if (categories
                                                                  .isEmpty) {
                                                                categories =
                                                                    await ProfileUtilities
                                                                        .instance
                                                                        .agencyCategory();
                                                              }
                                                            } catch (e) {
                                                              progress
                                                                  .dismiss();
                                                              familyBloc.add(
                                                                  CallErrorState(
                                                                      message: e
                                                                          .toString()));
                                                            }
                                                            progress.dismiss();
                                                            showDialog(
                                                                context: NavigationService
                                                                    .navigatorKey
                                                                    .currentContext!,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return SpouseAlert(
                                                                      familyBloc:
                                                                          familyBloc,
                                                                      token:
                                                                          token!,
                                                                      profileId:
                                                                          profileId!,
                                                                      positions:
                                                                          positions,
                                                                      agencies:
                                                                          agencices,
                                                                      category:
                                                                          categories,
                                                                      bloodType:
                                                                          bloodType,
                                                                      civilStatus:
                                                                          civilStatus,
                                                                      gender:
                                                                          gender,
                                                                      nameExtensions:
                                                                          nameExtensions,
                                                                      sexes:
                                                                          sexes);
                                                                });
                                                          },
                                                          icon: const Icon(
                                                            Entypo.plus,
                                                            color: second,
                                                          ))
                                                      : const SizedBox(),
                                                )
                                              ],
                                            ),
                                            Container(
                                                child: spouse != null
                                                    ? Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  ListTile(
                                                                    dense: true,
                                                                    visualDensity: const VisualDensity(
                                                                        horizontal:
                                                                            -4,
                                                                        vertical:
                                                                            -4),
                                                                    title: Text(
                                                                      "${spouse?.relatedPerson?.firstName} ${spouse?.relatedPerson?.middleName ?? ''} ${spouse?.relatedPerson!.lastName} ${spouse?.relatedPerson?.nameExtension ?? ''}",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium!
                                                                          .copyWith(
                                                                              fontWeight: FontWeight.w500),
                                                                    ),
                                                                    subtitle:
                                                                        const Text(
                                                                            "fullname"),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Checkbox(
                                                                          visualDensity: const VisualDensity(
                                                                              horizontal:
                                                                                  0,
                                                                              vertical:
                                                                                  -4),
                                                                          value: spouse!
                                                                              .incaseOfEmergency!,
                                                                          onChanged:
                                                                              (value) {
                                                                            confirmAlertWithCancel(context,
                                                                                () {
                                                                              final progress = ProgressHUD.of(context);
                                                                              progress!.showWithText("Loading...");

                                                                              context.read<FamilyBloc>().add(AddEmergencyEvent(contactInfoId: spouse!.emergencyContact!.isNotEmpty ? spouse!.emergencyContact!.first.contactinfoid : null, numberMail: spouse!.emergencyContact!.isNotEmpty ? spouse!.emergencyContact!.first.numbermail : null, profileId: profileId!, relatedPersonId: spouse!.relatedPerson!.id!, token: token!, requestType: "CHECKBOX"));
                                                                            }, () {}, "Emergency Contact Information?",
                                                                                spouse!.incaseOfEmergency == true ? "Remove as emergency contact information?" : "Add as emergency contact information?");
                                                                          }),
                                                                      const Text(
                                                                          incaseOfEmergency),
                                                                      ////Add mobile icon
                                                                      Container(
                                                                          child: spouse!.incaseOfEmergency! && spouse!.emergencyContact!.isEmpty
                                                                              ? IconButton(
                                                                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                                                  onPressed: () {
                                                                                    showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext context) {
                                                                                          return AddMobileNumber(
                                                                                              onPressed: () {
                                                                                                Navigator.of(_scaffoldKey.currentContext!).pop();
                                                                                                familyBloc.add(AddEmergencyEvent(contactInfoId: spouse!.emergencyContact!.isNotEmpty ? spouse!.emergencyContact!.first.contactinfoid : null, numberMail: formKey.currentState!.value['number_mail'], profileId: profileId!, relatedPersonId: spouse!.relatedPerson!.id!, token: token!, requestType: "CONTACT"));
                                                                                              },
                                                                                              formKey: formKey);
                                                                                        });
                                                                                  },
                                                                                  icon: const Icon(
                                                                                    Entypo.plus_circled,
                                                                                    color: third,
                                                                                    size: 18,
                                                                                  ))
                                                                              : Container()),
                                                                    ],
                                                                  ),
                                                                  Visibility(
                                                                      visible:
                                                                          spouse!
                                                                              .incaseOfEmergency!,
                                                                      child: Container(
                                                                          child: spouse!.emergencyContact!.isNotEmpty
                                                                              ? Row(
                                                                                  children: [
                                                                                    //// edit mobile
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        showDialog(
                                                                                            context: context,
                                                                                            builder: (BuildContext context) {
                                                                                              return AddMobileNumber(
                                                                                                  formKey: formKey,
                                                                                                  onPressed: () {
                                                                                                    Navigator.of(_scaffoldKey.currentContext!).pop();
                                                                                                    familyBloc.add(AddEmergencyEvent(contactInfoId: spouse!.emergencyContact!.isNotEmpty ? spouse!.emergencyContact!.first.contactinfoid : null, numberMail: formKey.currentState!.value['number_mail'], profileId: profileId!, relatedPersonId: spouse!.relatedPerson!.id!, token: token!, requestType: "CONTACT"));
                                                                                                  });
                                                                                            });
                                                                                      },
                                                                                      child: Row(
                                                                                        children: [
                                                                                          const SizedBox(
                                                                                            width: 16,
                                                                                          ),
                                                                                          Badge(
                                                                                            backgroundColor: third,
                                                                                            textColor: Colors.white,
                                                                                            label: Text(spouse!.emergencyContact!.first.numbermail!),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              : Container())),
                                                                  Container(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            12),
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: spouse?.position !=
                                                                            null
                                                                        ? Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              const SizedBox(
                                                                                height: 12,
                                                                              ),
                                                                              Text("OCCUPATION", textAlign: TextAlign.start, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, color: primary)),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  const SizedBox(
                                                                                    height: 3,
                                                                                  ),
                                                                                  Text(
                                                                                    spouse!.position!.title!,
                                                                                    style: Theme.of(context).textTheme.titleMedium,
                                                                                  ),
                                                                                  Text(
                                                                                    spouse!.company!.name!,
                                                                                    style: Theme.of(context).textTheme.titleMedium,
                                                                                  ),
                                                                                  Text(
                                                                                    spouse!.companyAddress!,
                                                                                    style: Theme.of(context).textTheme.labelMedium,
                                                                                  ),
                                                                                  Text(
                                                                                    spouse!.companyContactNumber!,
                                                                                    style: Theme.of(context).textTheme.labelMedium,
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          )
                                                                        : const SizedBox(),
                                                                  )
                                                                ]),
                                                          ),
                                                          AppPopupMenu<int>(
                                                            offset:
                                                                const Offset(
                                                                    -10, -10),
                                                            elevation: 3,
                                                            onSelected:
                                                                (value) async {
                                                              ////delete -= = = = = = = = =>>
                                                              if (value == 2) {
                                                                confirmAlert(
                                                                    context,
                                                                    () {
                                                                  final progress =
                                                                      ProgressHUD.of(
                                                                          context);
                                                                  progress!
                                                                      .showWithText(
                                                                          "Loading...");
                                                                  context.read<FamilyBloc>().add(DeleteFamily(
                                                                      id: spouse!
                                                                          .relatedPerson!
                                                                          .id!,
                                                                      profileId:
                                                                          profileId!,
                                                                      token:
                                                                          token!));
                                                                }, "Delete?",
                                                                    "Confirm Delete?");
                                                              }
                                                              if (value == 1) {
                                                                ////edit eligibilty-= = = = = = = = =>>

                                                                final progress =
                                                                    ProgressHUD.of(
                                                                        context);
                                                                progress!
                                                                    .showWithText(
                                                                        "Loading...");
                                                                if (positions
                                                                    .isEmpty) {
                                                                  positions =
                                                                      await ProfileUtilities
                                                                          .instance
                                                                          .getAgencyPosition();
                                                                }

                                                                if (agencices
                                                                    .isEmpty) {
                                                                  agencices =
                                                                      await ProfileUtilities
                                                                          .instance
                                                                          .getAgecies();
                                                                }
                                                                if (categories
                                                                    .isEmpty) {
                                                                  categories =
                                                                      await ProfileUtilities
                                                                          .instance
                                                                          .agencyCategory();
                                                                }
                                                                progress
                                                                    .dismiss();
                                                                showDialog(
                                                                    context: NavigationService
                                                                        .navigatorKey
                                                                        .currentContext!,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return SpouseEditAlert(
                                                                          familyBackground:
                                                                              spouse!,
                                                                          familyBloc:
                                                                              familyBloc,
                                                                          token:
                                                                              token!,
                                                                          profileId:
                                                                              profileId!,
                                                                          positions:
                                                                              positions,
                                                                          agencies:
                                                                              agencices,
                                                                          category:
                                                                              categories,
                                                                          bloodType:
                                                                              bloodType,
                                                                          civilStatus:
                                                                              civilStatus,
                                                                          gender:
                                                                              gender,
                                                                          nameExtensions:
                                                                              nameExtensions,
                                                                          sexes:
                                                                              sexes);
                                                                    });
                                                              }
                                                            },
                                                            menuItems: [
                                                              popMenuItem(
                                                                  text:
                                                                      "Update",
                                                                  value: 1,
                                                                  icon: Icons
                                                                      .edit),
                                                              popMenuItem(
                                                                  text:
                                                                      "Remove",
                                                                  value: 2,
                                                                  icon: Icons
                                                                      .delete),
                                                            ],
                                                            icon: const Icon(
                                                              Icons.more_vert,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            tooltip: "Options",
                                                          )
                                                        ],
                                                      )
                                                    : SizedBox(
                                                        width: screenWidth,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 8,
                                                                  horizontal:
                                                                      0),
                                                          child: Text(
                                                            "Provide your spouse's primary and employment information. Leave empty if not applicable.",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),
                            //// Childrens ----------------------------------
                            SlideInLeft(
                              delay: const Duration(milliseconds: 300),
                              child: Container(
                                decoration: box1(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                width: screenWidth,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                childrenText.toUpperCase(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(color: primary),
                                              ),
                                              const Expanded(child: SizedBox()),
                                              IconButton(
                                                  ////childrens
                                                  ////Show add dialog
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return ChildAlert(
                                                              familyBloc:
                                                                  familyBloc,
                                                              token: token!,
                                                              profileId:
                                                                  profileId!,
                                                              bloodType:
                                                                  bloodType,
                                                              civilStatus:
                                                                  civilStatus,
                                                              gender: gender,
                                                              nameExtensions:
                                                                  nameExtensions,
                                                              sexes: sexes);
                                                        });
                                                  },
                                                  icon: const Icon(
                                                    Entypo.plus,
                                                    color: second,
                                                  ))
                                            ],
                                          ),
                                          Container(
                                              child: children.isNotEmpty
                                                  ? Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children:
                                                          children.map((child) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title:
                                                                        const Column(
                                                                      children: [
                                                                        Icon(
                                                                          FontAwesome5
                                                                              .user,
                                                                          color:
                                                                              primary,
                                                                          size:
                                                                              32,
                                                                        ),
                                                                        Text(
                                                                          "Child Details",
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
                                                                              title: "${child.relatedPerson!.firstName!} ${child.relatedPerson?.middleName ?? ''} ${child.relatedPerson!.lastName} ${child.relatedPerson?.nameExtension ?? ''}",
                                                                              sub: "Fullname"),
                                                                          const Gap(
                                                                              3),
                                                                          TitleSubtitle(
                                                                              title: dteFormat2.format(child.relatedPerson!.birthdate!),
                                                                              sub: "Birthdate"),
                                                                          const Gap(
                                                                              3),
                                                                          TitleSubtitle(
                                                                              title: child.relatedPerson!.sex!,
                                                                              sub: "Sex"),
                                                                          const Gap(
                                                                              3),
                                                                          TitleSubtitle(
                                                                              title: child.relatedPerson?.gender ?? 'N/A',
                                                                              sub: "Gender"),
                                                                          const Gap(
                                                                              3),
                                                                          TitleSubtitle(
                                                                              title: child.relatedPerson?.bloodType ?? 'N/A',
                                                                              sub: "Blood Type"),
                                                                          const Gap(
                                                                              3),
                                                                          TitleSubtitle(
                                                                              title: "${child.relatedPerson?.heightM ?? 'N/A'}",
                                                                              sub: "Height"),
                                                                          const Gap(
                                                                              3),
                                                                          TitleSubtitle(
                                                                              title: "${child.relatedPerson?.weightKg ?? 'N/A'}",
                                                                              sub: "Weight"),
                                                                          const Gap(
                                                                              3),
                                                                          TitleSubtitle(
                                                                              title: child.relatedPerson!.deceased == true ? 'YES' : 'NO',
                                                                              sub: "Deceased")
                                                                        ]),
                                                                  );
                                                                });
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        0),
                                                            width: screenWidth,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment
                                                                              .start,
                                                                          crossAxisAlignment: CrossAxisAlignment
                                                                              .start,
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            ListTile(
                                                                              dense: true,
                                                                              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                                              title: Text("${child.relatedPerson?.firstName} ${child.relatedPerson?.middleName ?? ''} ${child.relatedPerson?.lastName} ${child.relatedPerson?.nameExtension ?? ''}", style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500)),
                                                                              subtitle: const Text("fullname"),
                                                                            ),
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Checkbox(
                                                                                    visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                                                                    value: child.incaseOfEmergency!,
                                                                                    onChanged: (value) {
                                                                                      confirmAlertWithCancel(context, () {
                                                                                        final progress = ProgressHUD.of(context);
                                                                                        progress!.showWithText("Loading...");

                                                                                        context.read<FamilyBloc>().add(AddEmergencyEvent(contactInfoId: child.emergencyContact!.isNotEmpty ? child.emergencyContact!.first.contactinfoid : null, numberMail: child.emergencyContact!.isNotEmpty ? child.emergencyContact!.first.numbermail : null, profileId: profileId!, relatedPersonId: child.relatedPerson!.id!, token: token!, requestType: "CHECKBOX"));
                                                                                      }, () {}, "Emergency Contact Information?", child.incaseOfEmergency == true ? "Remove as emergency contact information?" : "Add as emergency contact information?");
                                                                                    }),
                                                                                const Text(incaseOfEmergency),
                                                                                ////Add mobile icon
                                                                                Container(
                                                                                    child: child.incaseOfEmergency! && child.emergencyContact!.isEmpty
                                                                                        ? IconButton(
                                                                                            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                                                            onPressed: () {
                                                                                              showDialog(
                                                                                                  context: context,
                                                                                                  builder: (BuildContext context) {
                                                                                                    return AddMobileNumber(
                                                                                                        onPressed: () {
                                                                                                          Navigator.of(_scaffoldKey.currentContext!).pop();
                                                                                                          familyBloc.add(AddEmergencyEvent(contactInfoId: child.emergencyContact!.isNotEmpty ? child.emergencyContact!.first.contactinfoid : null, numberMail: formKey.currentState!.value['number_mail'], profileId: profileId!, relatedPersonId: child.relatedPerson!.id!, token: token!, requestType: "CONTACT"));
                                                                                                        },
                                                                                                        formKey: formKey);
                                                                                                  });
                                                                                            },
                                                                                            icon: const Icon(
                                                                                              Entypo.plus_circled,
                                                                                              color: third,
                                                                                              size: 18,
                                                                                            ))
                                                                                        : Container())
                                                                              ],
                                                                            ),
                                                                            //// child person add mobile number
                                                                            Visibility(
                                                                                visible: child.incaseOfEmergency!,
                                                                                child: Container(
                                                                                    child: child.emergencyContact!.isNotEmpty
                                                                                        ? Row(
                                                                                            children: [
                                                                                              //// edit mobile
                                                                                              GestureDetector(
                                                                                                onTap: () {
                                                                                                  showDialog(
                                                                                                      context: context,
                                                                                                      builder: (BuildContext context) {
                                                                                                        return AddMobileNumber(
                                                                                                            formKey: formKey,
                                                                                                            onPressed: () {
                                                                                                              Navigator.of(_scaffoldKey.currentContext!).pop();
                                                                                                              familyBloc.add(AddEmergencyEvent(contactInfoId: child.emergencyContact!.isNotEmpty ? child.emergencyContact!.first.contactinfoid : null, numberMail: formKey.currentState!.value['number_mail'], profileId: profileId!, relatedPersonId: child.relatedPerson!.id!, token: token!, requestType: "CONTACT"));
                                                                                                            });
                                                                                                      });
                                                                                                },
                                                                                                child: Row(
                                                                                                  children: [
                                                                                                    const SizedBox(
                                                                                                      width: 16,
                                                                                                    ),
                                                                                                    Badge(
                                                                                                      backgroundColor: third,
                                                                                                      textColor: Colors.white,
                                                                                                      label: Text(child.emergencyContact!.first.numbermail!),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          )
                                                                                        : Container())),
                                                                          ]),
                                                                    ),
                                                                    AppPopupMenu<
                                                                        int>(
                                                                      offset: const Offset(
                                                                          -10,
                                                                          -10),
                                                                      elevation:
                                                                          3,
                                                                      onSelected:
                                                                          (value) {
                                                                        ////delete -= = = = = = = = =>>
                                                                        if (value ==
                                                                            2) {
                                                                          confirmAlert(
                                                                              context,
                                                                              () {
                                                                            final progress =
                                                                                ProgressHUD.of(context);
                                                                            progress!.showWithText("Loading...");
                                                                            context.read<FamilyBloc>().add(DeleteFamily(
                                                                                id: child.relatedPerson!.id!,
                                                                                profileId: profileId!,
                                                                                token: token!));
                                                                          }, "Delete?",
                                                                              "Confirm Delete?");
                                                                        }
                                                                        if (value ==
                                                                            1) {
                                                                          //// edit
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return ChildEditAlert(familyBackground: child, familyBloc: familyBloc, profileId: profileId!, token: token!, bloodType: bloodType, civilStatus: civilStatus, gender: gender, nameExtensions: nameExtensions, sexes: sexes);
                                                                              });
                                                                        }
                                                                      },
                                                                      menuItems: [
                                                                        popMenuItem(
                                                                            text:
                                                                                "Update",
                                                                            value:
                                                                                1,
                                                                            icon:
                                                                                Icons.edit),
                                                                        popMenuItem(
                                                                            text:
                                                                                "Remove",
                                                                            value:
                                                                                2,
                                                                            icon:
                                                                                Icons.delete),
                                                                      ],
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .more_vert,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                      tooltip:
                                                                          "Options",
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }).toList())
                                                  : SizedBox(
                                                      width: screenWidth,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8,
                                                                horizontal: 0),
                                                        child: Text(
                                                          "Provide your child/children's primary information. Leave empty if not applicable.",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            ////Other related person
                            SlideInLeft(
                              delay: const Duration(milliseconds: 350),
                              child: Container(
                                decoration: box1(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                width: screenWidth,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  otherRelatedText.toUpperCase(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(color: primary),
                                                ),
                                              ),
                                              IconButton(
                                                  ////other related
                                                  //// Show Alert Dialog
                                                  onPressed: () async {
                                                    final progress =
                                                        ProgressHUD.of(context);
                                                    progress!.showWithText(
                                                        "Loading...");
                                                    try {
                                                      List<Relationship>
                                                          relationshipTypes =
                                                          await ProfileUtilities
                                                              .instance
                                                              .getRelationshipType();
                                                      progress.dismiss();
                                                      showDialog(
                                                          context:
                                                              NavigationService
                                                                  .navigatorKey
                                                                  .currentContext!,
                                                          builder: (BuildContext
                                                              context) {
                                                            return RelatedAlert(
                                                                token: token!,
                                                                profileId:
                                                                    profileId!,
                                                                familyBloc:
                                                                    familyBloc,
                                                                relationships:
                                                                    relationshipTypes,
                                                                bloodType:
                                                                    bloodType,
                                                                civilStatus:
                                                                    civilStatus,
                                                                gender: gender,
                                                                nameExtensions:
                                                                    nameExtensions,
                                                                sexes: sexes);
                                                          });
                                                    } catch (e) {
                                                      familyBloc.add(
                                                          CallErrorState(
                                                              message:
                                                                  e.toString()));
                                                      progress.dismiss();
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Entypo.plus,
                                                    color: second,
                                                  ))
                                            ],
                                          ),
                                          Container(
                                              child: otherRelated.isNotEmpty
                                                  ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: otherRelated
                                                          .map((relative) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            showDialog(
                                                                context: context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title:
                                                                        const Column(
                                                                      children: [
                                                                        Icon(
                                                                          FontAwesome5
                                                                              .user,
                                                                          color:
                                                                              primary,
                                                                          size:
                                                                              32,
                                                                        ),
                                                                        Text(
                                                                          "Related Person Details",
                                                                          style: TextStyle(
                                                                              color:
                                                                                  primary,
                                                                              fontSize:
                                                                                  18),
                                                                        ),
                                                                        Divider(),
                                                                      ],
                                                                    ),
                                                                    content: Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize
                                                                                .min,
                                                                        children: [
                                                                          TitleSubtitle(
                                                                              title:
                                                                                  relative.relationship!.type!,
                                                                              sub: "Relationship"),
                                                                          const Gap(
                                                                              3),
                                                                          TitleSubtitle(
                                                                              title:
                                                                                  "${relative.relatedPerson!.firstName!} ${relative.relatedPerson?.middleName ?? ''} ${relative.relatedPerson!.lastName} ${relative.relatedPerson?.nameExtension ?? ''}",
                                                                              sub:
                                                                                  "Fullname"),
                                                                          const Gap(
                                                                              3),
                                                                          TitleSubtitle(
                                                                              title:
                                                                                  dteFormat2.format(relative.relatedPerson!.birthdate!),
                                                                              sub: "Birthdate"),
                                                                          const Gap(
                                                                              3),
                                                                          TitleSubtitle(
                                                                              title:
                                                                                  relative.relatedPerson!.sex!,
                                                                              sub: "Sex"),
                                                                          const Gap(
                                                                              3),
                                                                          TitleSubtitle(
                                                                              title: relative.relatedPerson?.gender ??
                                                                                  'N/A',
                                                                              sub:
                                                                                  "Gender"),
                                                                          const Gap(
                                                                              3),
                                                                          TitleSubtitle(
                                                                              title: relative.relatedPerson?.bloodType ??
                                                                                  'N/A',
                                                                              sub:
                                                                                  "Blood Type"),
                                                                          const Gap(
                                                                              3),
                                                                          TitleSubtitle(
                                                                              title:
                                                                                  "${relative.relatedPerson?.heightM ?? 'N/A'}",
                                                                              sub:
                                                                                  "Height"),
                                                                          const Gap(
                                                                              3),
                                                                          TitleSubtitle(
                                                                              title:
                                                                                  "${relative.relatedPerson?.weightKg ?? 'N/A'}",
                                                                              sub:
                                                                                  "Weight"),
                                                                          const Gap(
                                                                              3),
                                                                          TitleSubtitle(
                                                                              title: relative.relatedPerson!.deceased == true
                                                                                  ? 'YES'
                                                                                  : 'NO',
                                                                              sub:
                                                                                  "Deceased")
                                                                        ]),
                                                                  );
                                                                });
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical: 0),
                                                            width: screenWidth,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment
                                                                                  .start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment
                                                                                  .start,
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            ListTile(
                                                                              dense:
                                                                                  true,
                                                                              visualDensity:
                                                                                  const VisualDensity(horizontal: -4, vertical: -4),
                                                                              title:
                                                                                  Text("${relative.relatedPerson?.firstName} ${relative.relatedPerson?.middleName ?? ""} ${relative.relatedPerson?.lastName} ${relative.relatedPerson?.nameExtension ?? ''}", style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500)),
                                                                              subtitle:
                                                                                  const Text("fullname"),
                                                                            ),
                                                                            Row(
                                                                              mainAxisSize:
                                                                                  MainAxisSize.min,
                                                                              children: [
                                                                                Checkbox(
                                                                                    visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                                                                    value: relative.incaseOfEmergency!,
                                                                                    onChanged: (value) {
                                                                                      confirmAlertWithCancel(context, () {
                                                                                        final progress = ProgressHUD.of(context);
                                                                                        progress!.showWithText("Loading...");
                              
                                                                                        context.read<FamilyBloc>().add(AddEmergencyEvent(contactInfoId: relative.emergencyContact!.isNotEmpty ? relative.emergencyContact!.first.contactinfoid : null, numberMail: relative.emergencyContact!.isNotEmpty ? relative.emergencyContact!.first.numbermail : null, profileId: profileId!, relatedPersonId: relative.relatedPerson!.id!, token: token!, requestType: "CHECKBOX"));
                                                                                      }, () {}, "Emergency Contact Information?", relative.incaseOfEmergency == true ? "Remove as emergency contact information?" : "Add as emergency contact information?");
                                                                                    }),
                                                                                const Text(incaseOfEmergency),
                                                                                Container(
                                                                                    child: relative.incaseOfEmergency! && relative.emergencyContact!.isEmpty
                                                                                        ? IconButton(
                                                                                            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                                                            onPressed: () {
                                                                                              showDialog(
                                                                                                  context: context,
                                                                                                  builder: (BuildContext context) {
                                                                                                    return AddMobileNumber(
                                                                                                        onPressed: () {
                                                                                                          Navigator.of(_scaffoldKey.currentContext!).pop();
                                                                                                          familyBloc.add(AddEmergencyEvent(contactInfoId: relative.emergencyContact!.isNotEmpty ? relative.emergencyContact!.first.contactinfoid : null, numberMail: formKey.currentState!.value['number_mail'], profileId: profileId!, relatedPersonId: relative.relatedPerson!.id!, token: token!, requestType: "CONTACT"));
                                                                                                        },
                                                                                                        formKey: formKey);
                                                                                                  });
                                                                                            },
                                                                                            icon: const Icon(
                                                                                              Entypo.plus_circled,
                                                                                              color: third,
                                                                                              size: 18,
                                                                                            ))
                                                                                        : Container())
                                                                              ],
                                                                            ),
                                                                            //// other related person add mobile number
                                                                            Visibility(
                                                                              visible:
                                                                                  relative.incaseOfEmergency!,
                                                                              child: Container(
                                                                                  child: relative.emergencyContact!.isNotEmpty
                                                                                      ? Row(
                                                                                          children: [
                                                                                            //// edit mobile
                                                                                            GestureDetector(
                                                                                              onTap: () {
                                                                                                showDialog(
                                                                                                    context: context,
                                                                                                    builder: (BuildContext context) {
                                                                                                      return AddMobileNumber(
                                                                                                          formKey: formKey,
                                                                                                          onPressed: () {
                                                                                                            Navigator.of(_scaffoldKey.currentContext!).pop();
                                                                                                            familyBloc.add(AddEmergencyEvent(contactInfoId: relative.emergencyContact!.isNotEmpty ? relative.emergencyContact!.first.contactinfoid : null, numberMail: formKey.currentState!.value['number_mail'], profileId: profileId!, relatedPersonId: relative.relatedPerson!.id!, token: token!, requestType: "CONTACT"));
                                                                                                          });
                                                                                                    });
                                                                                              },
                                                                                              child: Row(
                                                                                                children: [
                                                                                                  const SizedBox(
                                                                                                    width: 16,
                                                                                                  ),
                                                                                                  Badge(
                                                                                                    backgroundColor: third,
                                                                                                    textColor: Colors.white,
                                                                                                    label: Text(relative.emergencyContact!.first.numbermail!),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                      : Container()),
                                                                            )
                                                                          ]),
                                                                    ),
                                                                    AppPopupMenu<
                                                                        int>(
                                                                      offset:
                                                                          const Offset(
                                                                              -10,
                                                                              -10),
                                                                      elevation:
                                                                          3,
                                                                      onSelected:
                                                                          (value) async {
                                                                        ////delete -= = = = = = = = =>>
                                                                        if (value ==
                                                                            2) {
                                                                          confirmAlert(
                                                                              context,
                                                                              () {
                                                                            final progress =
                                                                                ProgressHUD.of(context);
                                                                            progress!
                                                                                .showWithText("Loading...");
                                                                            context.read<FamilyBloc>().add(DeleteFamily(
                                                                                id: relative.relatedPerson!.id!,
                                                                                profileId: profileId!,
                                                                                token: token!));
                                                                          }, "Delete?",
                                                                              "Confirm Delete?");
                                                                        }
                                                                        if (value ==
                                                                            1) {
                                                                          ////edit eligibilty-= = = = = = = = =>>
                                                                          await getRelationshiptypes(
                                                                              context);
                                                                          showDialog(
                                                                              context:
                                                                                  NavigationService.navigatorKey.currentContext!,
                                                                              builder: (BuildContext context) {
                                                                                return RelatedEditAlert(familyBackground: relative, token: token!, profileId: profileId!, familyBloc: familyBloc, relationships: relationshipTypes!, bloodType: bloodType, civilStatus: civilStatus, gender: gender, nameExtensions: nameExtensions, sexes: sexes);
                                                                              });
                                                                        }
                                                                      },
                                                                      menuItems: [
                                                                        popMenuItem(
                                                                            text:
                                                                                "Update",
                                                                            value:
                                                                                1,
                                                                            icon:
                                                                                Icons.edit),
                                                                        popMenuItem(
                                                                            text:
                                                                                "Remove",
                                                                            value:
                                                                                2,
                                                                            icon:
                                                                                Icons.delete),
                                                                      ],
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .more_vert,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                      tooltip:
                                                                          "Options",
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }).toList())
                                                  : SizedBox(
                                                      width: screenWidth,
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 8,
                                                            horizontal: 0),
                                                        child: Text(
                                                          "Provide the other related person's primary information. Leave empty if not applicable.",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodySmall,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]);
                        }
                        if (state is FamilyErrorState) {
                          return SomethingWentWrong(
                              message: onError,
                              onpressed: () {
                                context.read<FamilyBloc>().add(GetFamilies(
                                    profileId: profileId!, token: token!));
                              });
                        }
                        if (state is FamilyErrorAddingState) {
                          return SomethingWentWrong(
                              message:
                                  "Error adding Family Member. Please try again!",
                              onpressed: () {
                                context.read<FamilyBloc>().add(AddFamily(
                                    familyBackground: state.familyBackground,
                                    profileId: profileId!,
                                    token: token!,
                                    relationshipId: state.relationshipId));
                              });
                        }
                        if (state is FamilyErrorUpdatingState) {
                          return SomethingWentWrong(
                              message:
                                  "Error updating Family Member. Please try again!",
                              onpressed: () {
                                context.read<FamilyBloc>().add(Updatefamily(
                                    familyBackground: state.familyBackground,
                                    profileId: profileId!,
                                    token: token!,
                                    relationshipId: state.relationshipId));
                              });
                        }
                        if (state is FamilyErrorDeletingState) {
                          return SomethingWentWrong(
                              message:
                                  "Error deleting Family Member. Please try again!",
                              onpressed: () {
                                context.read<FamilyBloc>().add(DeleteFamily(
                                      id: state.id,
                                      profileId: profileId!,
                                      token: token!,
                                    ));
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
      ),
    );
  }

  getRelationshiptypes(BuildContext parentContext) async {
    final progress = ProgressHUD.of(parentContext);
    progress!.showWithText("Loading...");

    relationshipTypes = await ProfileUtilities.instance.getRelationshipType();
    progress.dismiss();
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
