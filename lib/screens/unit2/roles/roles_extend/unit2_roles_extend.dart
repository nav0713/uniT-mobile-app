import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:unit2/bloc/role/unit2_roles_extend/unit2_roles_extend_bloc.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/widgets/empty_data.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';

class Unit2RolesExtendScreen extends StatelessWidget {
  final int userId;
  const Unit2RolesExtendScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    Map<String, List<Content>> rolesExtend = {};
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primary,
          title: const Text("Roles Extend"),
        ),
        body: LoadingProgress(
      
            child: BlocConsumer<Unit2RolesExtendBloc, Unit2RolesExtendState>(
              builder: (context, state) {
                if (state is Unit2RolesExtendErrorState) {
                  return SomethingWentWrong(
                      message: state.message, onpressed: () {
                        context.read<Unit2RolesExtendBloc>().add(GetUnit2RolesExtend(webUserId: userId));
                      });
                }
                if (state is Unit2RolesExtendLoadedState) {
                  rolesExtend = {};
                  if (state.rolesExtend.isNotEmpty) {
                    for (var roleExt in state.rolesExtend) {
                      if (!rolesExtend.keys.contains(
                          roleExt.roleExtendMain.name!.toLowerCase())) {
                        rolesExtend.addAll(
                            {roleExt.roleExtendMain.name!.toLowerCase(): []});
                        rolesExtend[roleExt.roleExtendMain.name!.toLowerCase()]!
                            .add(Content(
                                id: roleExt.id,
                                name: roleExt.roleExtendChild.name!));
                      } else {
                        rolesExtend[roleExt.roleExtendMain.name!.toLowerCase()]!
                            .add(Content(
                                id: roleExt.id,
                                name: roleExt.roleExtendChild.name!));
                      }
                    }
                  }
                   if (state.rolesExtend.isNotEmpty) {
                return GroupListView(
                  padding: const EdgeInsets.all(0),
                  sectionsCount: rolesExtend.keys.toList().length,
                  countOfItemInSection: (int section) {
                    return rolesExtend.values.toList()[section].length;
                  },
                  itemBuilder: (BuildContext context, IndexPath index) {
                    return ListTile(
                      dense: true,
                  
                      title: Row(
                        children: [
                          CircleAvatar(
                              child: Text("${index.index + 1}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(color: Colors.white))),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Text(
                              rolesExtend.values
                                  .toList()[index.section][index.index]
                                  .name
                                  .toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: primary),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  groupHeaderBuilder: (BuildContext context, int section) {
                    return ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        rolesExtend.keys.toList()[section].toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: primary,fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                );
              } else {
                return const EmptyData(
                    message: "No Role available. Please click + to add.");
              }
                }
                return Container();
              },
              listener: (context, state) {
                if (state is Unit2RolesExtendLoadingState) {
                  final progress = ProgressHUD.of(context);
                  progress!.showWithText("Please wait...");
                }

                if (state is Unit2RolesExtendLoadedState ||
                    state is Unit2RolesExtendErrorState) {
                  final progress = ProgressHUD.of(context);
                  progress!.dismiss();
                }
              },
            )));
  }
}

class Content {
  final int id;
  final String name;
  const Content({required this.id, required this.name});
}
