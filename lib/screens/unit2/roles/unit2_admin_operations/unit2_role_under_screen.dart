import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:unit2/bloc/role/unit2_roles_under/unit2_assignable_role_bloc.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import '../../../../theme-data.dart/colors.dart';
import '../../../../utils/alerts.dart';
import '../../../../widgets/empty_data.dart';

class EstPointPersonRoleUnderScreen extends StatelessWidget {
  final int id;
  const EstPointPersonRoleUnderScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
         Map<String, List<Content>> rolesUnder = {};
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primary,
        title: const Text("Roles Under"),
  
      ),
      body: LoadingProgress(
    
        child: BlocConsumer<Unit2AssinableRoleBloc, Unit2AssinableRoleState>(
          listener: (context, state) {
            if (state is Unit2AssignableRoleLoadingState) {
              final progress = ProgressHUD.of(context);
              progress!.showWithText("Please wait...");
            }
            if (state is Unit2AssignableRoleLoaded ||
          
                state is Unit2AssignableErrorState) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }
 

           
          },
          builder: (context, state) {
            
            if (state is Unit2AssignableRoleLoaded) {
              // roles = state.roles;
              // mainRole = state.mainRole;
              if (state.rolesUnder.isNotEmpty) {
                   rolesUnder = {};

              if (state.rolesUnder.isNotEmpty) {
                for (var roleUnder in state.rolesUnder) {
                  if (!rolesUnder.keys
                      .contains(roleUnder.roleUnderMain.name!.toLowerCase())) {
                    rolesUnder.addAll(
                        {roleUnder.roleUnderMain.name!.toLowerCase(): []});
                    rolesUnder[roleUnder.roleUnderMain.name!.toLowerCase()]!
                        .add(Content(
                            id: roleUnder.id,
                            name: roleUnder.roleUnderChild.name!));
                  } else {
                    rolesUnder[roleUnder.roleUnderMain.name!.toLowerCase()]!
                        .add(Content(
                            id: roleUnder.id,
                            name: roleUnder.roleUnderChild.name!));
                  }
                }
              }

                return GroupListView(
                  sectionsCount: rolesUnder.keys.toList().length,
                  countOfItemInSection: (int section) {
                    return rolesUnder.values.toList()[section].length;
                  },
                  itemBuilder: (BuildContext context, IndexPath index) {
                    return ListTile(
                      trailing: IconButton(
                        color: Colors.grey.shade500,
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                        confirmAlert(context,(){
                    
                        }, "Delete", "Delete Role?");
                        },
                      ),
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
                                rolesUnder.values
                                    .toList()[index.section][index.index]
                                    .name
                                    .toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: primary)),
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
                      dense: true,
                      title: Text(
                        rolesUnder.keys.toList()[section].toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: primary, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                );
              } else {
                return const EmptyData(
                    message: "No Role available. Please click + to add.");
              }
            }
            if (state is Unit2AssignableErrorState) {
              return SomethingWentWrong(
                  message: state.message, onpressed: () {
                    context.read<Unit2AssinableRoleBloc>().add(GetUnit2AssignableRoles(userId: id));
                  });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
class Content {
  final int id;
  final String name;
  const Content({required this.id, required this.name});
}
