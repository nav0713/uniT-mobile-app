import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttericon/brandico_icons.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:unit2/bloc/profile/primary_information/address/address_bloc.dart';
import 'package:unit2/bloc/profile/primary_information/citizenship/citizenship_bloc.dart';
import 'package:unit2/bloc/profile/primary_information/contact/contact_bloc.dart';
import 'package:unit2/bloc/profile/primary_information/identification/identification_bloc.dart';
import 'package:unit2/bloc/profile/profile_bloc.dart';
import 'package:unit2/screens/profile/components/basic_information/address_screen.dart';
import 'package:unit2/screens/profile/components/basic_information/citizenship_screen.dart';
import 'package:unit2/screens/profile/components/basic_information/contact_information_screen.dart';
import 'package:unit2/screens/profile/components/basic_information/identification_information_screen.dart';
import 'package:unit2/screens/profile/components/basic_information/primary_information_screen.dart';
import 'package:unit2/screens/profile/components/education_screen.dart';
import 'package:unit2/screens/profile/components/eligibility_screen.dart';
import 'package:unit2/screens/profile/components/family_background_screen.dart';
import 'package:unit2/screens/profile/components/learning_and_development_screen.dart';
import 'package:unit2/screens/profile/components/loading_screen.dart';
import 'package:unit2/screens/profile/components/other_information/non_academic_recognition_screen.dart';
import 'package:unit2/screens/profile/components/other_information/org_membership_screen.dart';
import 'package:unit2/screens/profile/components/other_information/skills_and_hobbies_screen.dart';
import 'package:unit2/screens/profile/components/references_screen.dart';
import 'package:unit2/screens/profile/components/work_history_screen.dart';
import 'package:unit2/screens/profile/components/voluntary_works_screen.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import '../../bloc/profile/eligibility/eligibility_bloc.dart';
import '../../bloc/profile/family/family_bloc.dart';
import '../../bloc/profile/education/education_bloc.dart';
import '../../bloc/profile/learningDevelopment/learning_development_bloc.dart';
import '../../bloc/profile/other_information/hobbies/hoobies_bloc.dart';
import '../../bloc/profile/other_information/non_academic_recognition.dart/non_academic_recognition_bloc.dart';
import '../../bloc/profile/other_information/org_membership/organization_membership_bloc.dart';
import '../../bloc/profile/references/references_bloc.dart';
import '../../bloc/profile/voluntary_works/voluntary_work_bloc.dart';
import '../../bloc/profile/workHistory/workHistory_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../model/profile/basic_information/primary-information.dart';
import 'components/main_menu.dart';
import 'components/submenu.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  @override
  Widget build(BuildContext context) {
    int? profileId;
    String? token;
    Profile profile;
    return PopScope(
    canPop: true,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: primary,
            centerTitle: true,
            title: const Text('Profile'),
          ),
          body: LoadingProgress(
            child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
              if (state is UserLoggedIn) {
                profileId = state.userData!.user!.login!.user!.profileId;
                token = state.userData!.user!.login!.token!;
                if (globalCurrentProfile == null) {
                  profile = state.userData!.profile!;
                  globalCurrentProfile = profile;
                } else {
                  profile = globalCurrentProfile!;
                }
                return BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (
                    context,
                    state,
                  ) {
                    if (state is ProfileLoading) {
                      final progress = ProgressHUD.of(context);
                      progress!.showWithText("Please wait...");
                    }
                    if (state is ProfileLoaded ||
                        state is ProfileErrorState ||
                        state is BasicInformationEditingState) {
                      final progress = ProgressHUD.of(context);
                      progress?.dismiss();
                    }
                  },
                  builder: (context, state) {
                    if (state is ProfileLoaded) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        child: ListView(
                          children: [
                            FadeInLeft(
                              child: Text(
                                "View and Update your Profile Information",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            FadeInLeft(
                              delay: const Duration(milliseconds: 100),
                              child: ExpansionTile(
                                  tilePadding:
                                      const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  title: const ListTile(
                                    leading: Icon(
                                      Elusive.address_book,
                                      color: primary,
                                    ),
                                    title: Text(
                                      "Basic Information",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  children: [
                                    subMenu(Icons.person, "Primary", () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return BlocProvider<ProfileBloc>.value(
                                          value: ProfileBloc()
                                            ..add(GetPrimaryBasicInfo(
                                                primaryBasicInformation:
                                                    profile)),
                                          child: PrimaryInfo(
                                            token: token!,
                                            profileId: profileId!,
                                          ),
                                        );
                                      }));
                                    }),
                                    subMenu(Icons.home, "Addresses", () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return BlocProvider(
                                          create: (context) => AddressBloc()
                                            ..add(GetAddress(
                                                addresses: state
                                                    .profileInformation
                                                    .basicInfo
                                                    .addresses)),
                                          child: const AddressScreen(),
                                        );
                                      }));
                                    }),
                                    subMenu(
                                        Icons.contact_mail, "Identifications",
                                        () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return BlocProvider(
                                          create: (context) =>
                                              IdentificationBloc()
                                                ..add(GetIdentifications(
                                                    identificationInformation:
                                                        state
                                                            .profileInformation
                                                            .basicInfo
                                                            .identifications)),
                                          child: const IdentificationsScreen(),
                                        );
                                      }));
                                    }),
                                    subMenu(Icons.contact_phone, "Contact Info",
                                        () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return BlocProvider(
                                          create: (context) => ContactBloc()
                                            ..add(GetContacts(
                                                contactInformations: state
                                                    .profileInformation
                                                    .basicInfo
                                                    .contactInformation)),
                                          child:
                                              const ContactInformationScreen(),
                                        );
                                      }));
                                    }),
                                    subMenu(Icons.flag, "Citizenships", () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return BlocProvider(
                                          create: (context) => CitizenshipBloc()
                                            ..add(GetCitizenship(
                                                citizenship: state
                                                    .profileInformation
                                                    .basicInfo
                                                    .citizenships)),
                                          child: CitizenShipScreen(
                                              citizenships: state
                                                  .profileInformation
                                                  .basicInfo
                                                  .citizenships,
                                              profileId: profileId!,
                                              token: token!),
                                        );
                                      }));
                                    }),
                                  ]),
                            ),
                            FadeInLeft(
                              delay: const Duration(milliseconds: 150),
                              child: MainMenu(
                                icon: Elusive.group,
                                title: "Family",
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return BlocProvider(
                                      create: (context) => FamilyBloc()
                                        ..add(GetFamilies(
                                            profileId: profileId!,
                                            token: token!)),
                                      child: const FamilyBackgroundScreen(),
                                    );
                                  }));
                                },
                              ),
                            ),
                            const Divider(),
                            FadeInLeft(
                              delay: const Duration(milliseconds: 200),
                              child: MainMenu(
                                icon: FontAwesome5.graduation_cap,
                                title: "Education",
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return BlocProvider(
                                      create: (context) => EducationBloc()
                                        ..add(GetEducationalBackground(
                                            profileId: profileId!,
                                            token: token!)),
                                      child: const EducationScreen(),
                                    );
                                  }));
                                },
                              ),
                            ),
                            const Divider(),
                            FadeInLeft(
                              delay: const Duration(milliseconds: 250),
                              child: MainMenu(
                                icon: Icons.stars,
                                title: "Eligibility",
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return BlocProvider(
                                      create: (context) => EligibilityBloc()
                                        ..add(GetEligibilities(
                                            profileId: profileId!,
                                            token: token!)),
                                      child: const EligibiltyScreen(),
                                    );
                                  }));
                                },
                              ),
                            ),
                            const Divider(),
                            FadeInLeft(
                              delay: const Duration(milliseconds: 300),
                              child: MainMenu(
                                icon: FontAwesome5.shopping_bag,
                                title: "Work History",
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return BlocProvider(
                                      create: (context) => WorkHistoryBloc()
                                        ..add(GetWorkHistories(
                                            profileId: profileId!,
                                            token: token!)),
                                      child: const WorkHistoryScreen(),
                                    );
                                  }));
                                },
                              ),
                            ),
                            const Divider(),
                            FadeInLeft(
                              delay: const Duration(milliseconds: 350),
                              child: MainMenu(
                                icon: FontAwesome5.walking,
                                title: "Voluntary Work & Civic Services",
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return BlocProvider(
                                      create: (context) => VoluntaryWorkBloc()
                                        ..add(GetVoluntarWorks(
                                            profileId: profileId!,
                                            token: token!)),
                                      child: const VolunataryWorkScreen(),
                                    );
                                  }));
                                },
                              ),
                            ),
                            const Divider(),
                            FadeInLeft(
                              delay: const Duration(milliseconds: 400),
                              child: MainMenu(
                                icon: Elusive.lightbulb,
                                title: "Learning & Development",
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return BlocProvider(
                                      create: (context) =>
                                          LearningDevelopmentBloc()
                                            ..add(GetLearningDevelopments(
                                                profileId: profileId!,
                                                token: token!)),
                                      child:
                                          const LearningAndDevelopmentScreen(),
                                    );
                                  }));
                                },
                              ),
                            ),
                            const Divider(),
                            FadeInLeft(
                              delay: const Duration(milliseconds: 450),
                              child: MainMenu(
                                icon: Brandico.codepen,
                                title: "Personal References",
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return BlocProvider(
                                      create: (context) => ReferencesBloc()
                                        ..add(GetReferences(
                                            profileId: profileId!,
                                            token: token!)),
                                      child: const ReferencesScreen(),
                                    );
                                  }));
                                },
                              ),
                            ),
                            FadeInLeft(
                              delay: const Duration(milliseconds: 500),
                              child: ExpansionTile(
                                  tilePadding:
                                      const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  title: const ListTile(
                                    leading: Icon(
                                      Icons.info,
                                      color: primary,
                                    ),
                                    title: Text(
                                      "Other Information",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  children: [
                                    subMenu(Icons.fitness_center,
                                        "Skills & Hobbies", () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return BlocProvider(
                                          create: (context) => HoobiesBloc()
                                            ..add(GetSkillsHobbies(
                                                profileId: profileId!,
                                                token: token!)),
                                          child: const SkillHobbiesScreen(),
                                        );
                                      }));
                                    }),
                                    subMenu(FontAwesome5.certificate,
                                        "Organization Memberships", () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return BlocProvider(
                                          create: (context) =>
                                              OrganizationMembershipBloc()
                                                ..add(GetOrganizationMembership(
                                                    profileId: profileId!,
                                                    token: token!)),
                                          child: const OrgMembershipsScreen(),
                                        );
                                      }));
                                    }),
                                    subMenu(Entypo.doc_text,
                                        "Non-Academic Recognitions", () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return BlocProvider(
                                          create: (context) =>
                                              NonAcademicRecognitionBloc()
                                                ..add(GetNonAcademicRecognition(
                                                    profileId: profileId!,
                                                    token: token!)),
                                          child:
                                              const NonAcademicRecognitionScreen(),
                                        );
                                      }));
                                    }),
                                  ]),
                            ),
                            FadeInLeft(
                              delay: const Duration(milliseconds: 550),
                              child: ExpansionTile(
                                  tilePadding:
                                      const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  title: const ListTile(
                                    leading: Icon(
                                      FontAwesome5.laptop_house,
                                      color: primary,
                                    ),
                                    title: Text(
                                      "Assets",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  children: [
                                    subMenu(ModernPictograms.home,
                                        "Real Property Tax", () {}),
                                  ]),
                            ),
                          ],
                        ),
                      );
                    }
                    if (state is ProfileLoading) {
                      return const LoadingScreen();
                    }
                    if (state is ProfileErrorState) {
                      return SomethingWentWrong(
                          message: state.mesage,
                          onpressed: () {
                            BlocProvider.of<ProfileBloc>(context).add(
                                LoadProfile(token: token!, userID: profileId!));
                          });
                    }

                    return Container();
                  },
                );
              }
              return Container();
            }),
          )),
    );
  }
}
