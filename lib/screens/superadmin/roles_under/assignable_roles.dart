import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:unit2/bloc/rbac/rbac_operations/roles_under/roles_under_bloc.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import '../../../model/rbac/rbac.dart';
import '../../../theme-data.dart/btn-style.dart';
import '../../../theme-data.dart/colors.dart';
import '../../../theme-data.dart/form-style.dart';
import '../../../utils/alerts.dart';
import '../../../utils/global_context.dart';
import '../../../widgets/empty_data.dart';

class RbacRoleUnderScreen extends StatelessWidget {
  final int id;
  const RbacRoleUnderScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final parent = context;
    Map<String, List<Content>> rolesUnder = {};
    List<RBAC> roles = [];
    RBAC? selectedRole;
    List<ValueItem> valueItemRoles = [];
    List<ValueItem> selectedValueItemRoles = [];
    final formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primary,
        title: const Text("Assignable Roles"),
        actions: context.watch<RolesUnderBloc>().state
                    is RoleUnderLoadingState? ||
                context.watch<RolesUnderBloc>().state is RoleUnderErrorState ||
                context.watch<RolesUnderBloc>().state
                    is RoleUnderDeletedState ||
                context.watch<RolesUnderBloc>().state is RoleUnderAddedState
            ? []
            : [
                AddLeading(onPressed: () {
                  showDialog(
                      context:
                          NavigationService.navigatorKey.currentState!.context,
                      builder: (BuildContext context) {
                        valueItemRoles = roles.map((e) {
                          return ValueItem(label: e.name!, value: e.name);
                        }).toList();
                        return AlertDialog(
                          title: const Text("Add Role Under"),
                          content: FormBuilder(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FormBuilderDropdown<RBAC>(
                                    validator: FormBuilderValidators.required(
                                        errorText: "This field is required"),
                                    name: "role",
                                    decoration: normalTextFieldStyle(
                                        "Main Role", "Main Role"),
                                    items: roles.isEmpty
                                        ? []
                                        : roles.map((e) {
                                            return DropdownMenuItem(
                                                value: e, child: Text(e.name!));
                                          }).toList(),
                                    onChanged: (RBAC? role) {
                                      selectedRole = role;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  MultiSelectDropDown(
                                    onOptionSelected:
                                        (List<ValueItem> selectedOptions) {
                                      selectedValueItemRoles = selectedOptions;
                                    },
                                    borderColor: Colors.grey,
                                    borderWidth: 1,
                                    borderRadius: 5,
                                    hint: "Roles Under",
                                    padding: const EdgeInsets.all(8),
                                    options: valueItemRoles,
                                    selectionType: SelectionType.multi,
                                    chipConfig: const ChipConfig(
                                        wrapType: WrapType.wrap),
                                    dropdownHeight: 300,
                                    optionTextStyle:
                                        const TextStyle(fontSize: 16),
                                    selectedOptionIcon:
                                        const Icon(Icons.check_circle),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: double.maxFinite,
                                    child: ElevatedButton(
                                        style: mainBtnStyle(primary,
                                            Colors.transparent, second),
                                        onPressed: () {
                                          if (formKey.currentState!
                                                  .saveAndValidate() &&
                                              selectedValueItemRoles
                                                  .isNotEmpty) {
                                            int assignerId = id;
                                            int roleId = selectedRole!.id!;
                                            List<int> rolesId = [];
                                            for (var role in roles) {
                                              for (var element in selectedValueItemRoles) {
                                                if (element.label
                                                        .toLowerCase() ==
                                                    role.name?.toLowerCase()) {
                                                  rolesId.add(role.id!);
                                                }
                                              }
                                            }
                                            Navigator.of(context).pop();
                                            parent.read<RolesUnderBloc>().add(
                                                AddRoleUnder(
                                                    roleId: roleId,
                                                    roleUnderIds: rolesId));
                                          }
                                        },
                                        child: const Text("Submit")),
                                  )
                                ],
                              )),
                        );
                      });
                })
              ],
      ),
      body: LoadingProgress(

        child: BlocConsumer<RolesUnderBloc, RolesUnderState>(
          listener: (context, state) {
            if (state is RoleUnderLoadingState) {
              final progress = ProgressHUD.of(context);
              progress!.showWithText("Please wait...");
            }
            if (state is RoleUnderLoadedState ||
                state is RoleUnderErrorState ||
                state is RoleUnderDeletedState ||
                state is RoleUnderAddedState || state is RoleUnderAddingErrorState || state is RoleUnderDeletingErrorState) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }

            ////Deleted State
            if (state is RoleUnderDeletedState) {
              if (state.success) {
                successAlert(
                    context, "Delete Successfull!", "Role Deleted Successfully",
                    () {
                  Navigator.of(context).pop();
                  context.read<RolesUnderBloc>().add(GetRolesUnder());
                });
              } else {
                errorAlert(
                    context, "Delete Failed", "Role Module Delete Failed", () {
                  Navigator.of(context).pop();
                  context.read<RolesUnderBloc>().add(GetRolesUnder());
                });
              }
            }
            ////Added State
            if (state is RoleUnderAddedState) {
              if (state.response['success']) {
                successAlert(
                    context, "Adding Successfull!", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<RolesUnderBloc>().add(GetRolesUnder());
                });
              } else {
                errorAlert(context, "Adding Failed", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<RolesUnderBloc>().add(GetRolesUnder());
                });
              }
            }
          },
          builder: (context, state) {
            if (state is RoleUnderLoadedState) {
              rolesUnder = {};
              roles = state.roles;

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

              if (state.rolesUnder.isNotEmpty) {
                return GroupListView(
                  sectionsCount: rolesUnder.keys.toList().length,
                  countOfItemInSection: (int section) {
                    return rolesUnder.values.toList()[section].length;
                  },
                  itemBuilder: (BuildContext context, IndexPath index) {
                    return AnimationConfiguration.staggeredList(
                      position: index.index,
                      child: FlipAnimation(
                        duration: const Duration(milliseconds: 300),
                        child: ListTile(
                          trailing: IconButton(
                            color: Colors.grey.shade500,
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                            confirmAlert(context,(){
                            context.read<RolesUnderBloc>().add(DeleteRoleUnder(roleUnderId:rolesUnder.values .toList()[index.section][index.index].id));
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
                        ),
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
            if (state is RoleUnderErrorState) {
              return SomethingWentWrong(
                  message: state.message,
                  onpressed: () {
                    context.read<RolesUnderBloc>().add(GetRolesUnder());
                  });
            }if(state is RoleUnderAddingErrorState){
              return SomethingWentWrong(message: "Error adding Role Under. Please try again!", onpressed: (){
                context.read<RolesUnderBloc>().add(AddRoleUnder(roleId: state.roleId, roleUnderIds: state.roleUnderIds));
              });
            }if(state is RoleUnderDeletingErrorState){
              return SomethingWentWrong(message: "Error deleting Role Under. Please try again!", onpressed: (){
                context.read<RolesUnderBloc>().add(DeleteRoleUnder(roleUnderId: state.roleUnderId));
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
