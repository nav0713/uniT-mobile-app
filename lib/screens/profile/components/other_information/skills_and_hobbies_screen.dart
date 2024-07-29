import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:simple_chips_input/simple_chips_input.dart';
import 'package:unit2/bloc/profile/profile_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/model/profile/other_information/skills_and_hobbies.dart';
import 'package:unit2/screens/profile/components/other_information/skills_hobbies/add_modal.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/Leadings/close_leading.dart';
import 'package:unit2/widgets/empty_data.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';

import '../../../../bloc/profile/other_information/hobbies/hoobies_bloc.dart';
import '../../../../theme-data.dart/btn-style.dart';
import '../../../../utils/alerts.dart';

class SkillHobbiesScreen extends StatefulWidget {
  const SkillHobbiesScreen({super.key});

  @override
  State<SkillHobbiesScreen> createState() => _SkillHobbiesScreenState();
}

class _SkillHobbiesScreenState extends State<SkillHobbiesScreen> {
  @override
  Widget build(BuildContext context) {
    String? token;
    int? profileId;
    final bloc = BlocProvider.of<HoobiesBloc>(context);
    String output = '';
    String? deletedChip, deletedChipIndex;
    final keySimpleChipsInput = GlobalKey<FormState>();
    final FocusNode focusNode = FocusNode();

    return Scaffold(
        appBar: AppBar(
            title: context.watch<HoobiesBloc>().state is AddHobbySkillState
                ? const Text("Add $skillAndHobbiesTitle")
                : const Text(skillAndHobbiesTitle),
            backgroundColor: primary,
            centerTitle: true,
            actions: context.watch<HoobiesBloc>().state is AddHobbySkillState
                ? [
                    CloseLeading(onPressed: () {
                      bloc.add(GetSkillsHobbies(
                          profileId: profileId!, token: token!));
                    })
                  ]
                : [
                    AddLeading(onPressed: () {
                      bloc.add(const ShowHobbySkillAddForm());
                    })
                  ]),
        floatingActionButton: context.watch<HoobiesBloc>().state
                is AddHobbySkillState
            ? FloatingActionButton(
                backgroundColor: primary,
                child: const Icon(Icons.add),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Column(
                            children: [
                              const Text("Add Skills and Hobbies"),
                              Text(
                                "Enter value(s) separated by comma",
                                style: Theme.of(context).textTheme.labelMedium,
                              )
                            ],
                          ),
                          content: SimpleChipsInput(
                            separatorCharacter: ",",
                            createCharacter: ",",
                            focusNode: focusNode,
                            validateInput: true,
                            autoFocus: true,
                            formKey: keySimpleChipsInput,
                            onSubmitted: (p0) {
                              setState(() {
                                output = p0;
                              });
                            },
                            onChipDeleted: (p0, p1) {
                              setState(() {
                                deletedChip = p0;
                                deletedChipIndex = p1.toString();
                              });
                            },
                            onSaved: ((p0) {
                              setState(() {
                                output = p0;
                              });
                            }),
                            chipTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            deleteIcon: const Icon(
                              Icons.delete,
                              size: 14.0,
                              color: second,
                            ),
                            widgetContainerDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(color: Colors.blue[100]!),
                            ),
                            chipContainerDecoration: BoxDecoration(
                              color: second,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            placeChipsSectionAbove: false,
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                keySimpleChipsInput.currentState!.save();
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                                bloc.add(GetAddedHobbiesSkills(
                                    addedHobbiesSkills: output));
                              },
                              style: mainBtnStyle(
                                  primary, Colors.transparent, second),
                              child: const Text(submit),
                            )
                          ],
                        );
                      });
                })
            : null,
        body: LoadingProgress(
          child: BlocBuilder<UserBloc, UserState>(
            buildWhen: (previous, current) => false,
            builder: (context, state) {
              if (state is UserLoggedIn) {
                token = state.userData!.user!.login!.token!;
                profileId = state.userData!.user!.login!.user!.profileId!;
                return BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoaded) {
                      return BlocConsumer<HoobiesBloc, HobbiesState>(
                        listener: (context, state) {
                          if (state is HobbiesLoadingState) {
                            final progress = ProgressHUD.of(context);
                            progress!.showWithText("Please wait...");
                          }
                          if (state is HobbiesLoadedState ||
                              state is HobbiesErrorState ||
                              state is AddHobbySkillState ||
                              state is AddHobbiesErrorState ||
                              state is DeleteHobbiesErrorState) {
                            final progress = ProgressHUD.of(context);
                            progress!.dismiss();
                          }
                          ////ADDED STATE
                          if (state is HobbiesAndSkillsAddedState) {
                            if (state.status['success']) {
                              successAlert(context, "Adding Successfull!",
                                  state.status['message'], () {
                                Navigator.of(context).pop();
                                context.read<HoobiesBloc>().add(
                                    LoadHobbiesSkills(
                                        skillsHobbies:
                                            state.mySkillsAndHobbies));
                              });
                            } else {
                              errorAlert(context, "Adding Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context.read<HoobiesBloc>().add(
                                    LoadHobbiesSkills(
                                        skillsHobbies:
                                            state.mySkillsAndHobbies));
                              });
                            }
                          }
                          //// DELETED STATE

                          if (state is HobbiesAndSkillsDeletedState) {
                            if (state.success) {
                              successAlert(context, "Delete Successfull!",
                                  "Skill/Hobby Deleted Successfully", () {
                                Navigator.of(context).pop();
                                context.read<HoobiesBloc>().add(
                                    LoadHobbiesSkills(
                                        skillsHobbies: state.skillsHobbies));
                              });
                            } else {
                              errorAlert(context, "Deletion Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context.read<HoobiesBloc>().add(
                                    LoadHobbiesSkills(
                                        skillsHobbies: state.skillsHobbies));
                              });
                            }
                          }
                        },
                        builder: (context, state) {
                       
                          if (state is HobbiesLoadedState) {
                            if (state.skillsAndHobbies.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(12),
                                child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    alignment: WrapAlignment.start,
                                    clipBehavior: Clip.none,
                                    verticalDirection: VerticalDirection.up,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    direction: Axis.horizontal,
                                    children: state.skillsAndHobbies
                                        .map((SkillsHobbies sh) {
                                      return Wrap(
                                        children: [
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 6),
                                            child: FadeInUp(
                                              child: Wrap(
                                                  clipBehavior: Clip.antiAlias,
                                                  alignment: WrapAlignment.center,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  runAlignment:
                                                      WrapAlignment.center,
                                                  children: [
                                                    Text(
                                                      sh.name!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium,
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          confirmAlert(
                                                              context,
                                                              () => context
                                                                  .read<
                                                                      HoobiesBloc>()
                                                                  .add(DeleteSkillHobbies(
                                                                      profileId:
                                                                          profileId!,
                                                                      skillsHobbies: [
                                                                        sh
                                                                      ],
                                                                      token:
                                                                          token!)),
                                                              "Delete",
                                                              "Confirm Delete");
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          size: 16,
                                                          color: second,
                                                        ))
                                                  ]),
                                            ),
                                          )
                                        ],
                                      );
                                    }).toList()),
                              );
                            } else {
                              return const EmptyData(
                                  message:
                                      "You don't have any Skills and Hobbies added. Please click + to add");
                            }
                          }
                          if (state is AddHobbySkillState) {
                            return AddHobbiesAndSkillsScreen(
                              profileId: profileId!,
                              token: token!,
                            );
                          }
                          if (state is HobbiesErrorState) {
                            return SomethingWentWrong(
                                message: state.message,
                                onpressed: () {
                                  context.read<HoobiesBloc>().add(
                                      GetSkillsHobbies(
                                          profileId: profileId!,
                                          token: token!));
                                });
                          }
                          if (state is AddHobbiesErrorState) {
                            return SomethingWentWrong(
                                message: onError,
                                onpressed: () {
                                  context.read<HoobiesBloc>().add(
                                      AddHobbyAndSkills(
                                          profileId: profileId!,
                                          token: token!,
                                          skillsHobbies: state.skillsHobbies));
                                });
                          }
                          if (state is DeleteHobbiesErrorState) {
                            return SomethingWentWrong(
                                message: onError,
                                onpressed: () {
                                  context.read<HoobiesBloc>().add(
                                      DeleteSkillHobbies(
                                          profileId: profileId!,
                                          skillsHobbies: state.skillsHobbies,
                                          token: token!));
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
