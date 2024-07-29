import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:unit2/bloc/rbac/rbac_operations/role_extend/role_extend_bloc.dart';
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

class RbacRoleExtendScreen extends StatelessWidget {
  final int id;
  const RbacRoleExtendScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final parent = context;
    Map<String, List<Content>> rolesExtend = {};
    List<RBAC> roles = [];
    RBAC? selectedRole;
    List<ValueItem> valueItemRoles = [];
    List<ValueItem> selectedValueItemRoles = [];
    final formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primary,
        title: const Text("Role Extend"),
        actions: context.watch<RoleExtendBloc>().state is RoleExtendLoadingState || context.watch<RoleExtendBloc>().state is RoleExtendErrorState || context.watch<RoleExtendBloc>().state is RoleExtendAddedState || context.watch<RoleExtendBloc>().state is RoleExtendDeletedState? []:[
          AddLeading(onPressed: () {
            showDialog(
                context: NavigationService.navigatorKey.currentState!.context,
                builder: (BuildContext context) {
                  valueItemRoles = roles.map((e) {
                    return ValueItem(label: e.name!, value: e.name);
                  }).toList();
                  return AlertDialog(
                    title: const Text("Add Role Extend"),
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
                                  "Role Extend Main", "Role Extend Main"),
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
                              hint: "Roles Extend",
                              padding: const EdgeInsets.all(8),
                              options: valueItemRoles,
                              selectionType: SelectionType.multi,
                              chipConfig:
                                  const ChipConfig(wrapType: WrapType.wrap),
                              dropdownHeight: 300,
                              optionTextStyle: const TextStyle(fontSize: 16),
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
                                  style: mainBtnStyle(
                                      primary, Colors.transparent, second),
                                  onPressed: () {
                                    if (formKey.currentState!
                                            .saveAndValidate() &&
                                        selectedValueItemRoles.isNotEmpty) {
                                      int roleId = selectedRole!.id!;
                                      List<int> rolesId = [];
                                      for (var role in roles) {
                                        for (var element in selectedValueItemRoles) {
                                          if (element.label.toLowerCase() ==
                                              role.name?.toLowerCase()) {
                                            rolesId.add(role.id!);
                                          }
                                        }
                                      }
                                      Navigator.of(context).pop();
                                      rolesExtend = {};
                                      parent.read<RoleExtendBloc>().add(
                                          AddRoleExtend(
                                              roleId: roleId,
                                              roleExtendsId: rolesId));
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
        child: BlocConsumer<RoleExtendBloc, RoleExtendState>(
          listener: (context, state) {
            if (state is RoleExtendLoadingState) {
              final progress = ProgressHUD.of(context);
              progress!.showWithText("Please wait...");
            }
            if (state is RoleExtendLoadedState ||
                state is RoleExtendAddedState ||
                state is RoleExtendDeletedState ||
                state is RoleExtendErrorState || state is RoleExtendErrorAddingState|| state is RoleExtendErrorDeletingState) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }

            ////Deleted State
            if (state is RoleExtendDeletedState) {
              if (state.success) {
                successAlert(context, "Delete Successfull!",
                    "Role Deleted Successfully", () {
                  Navigator.of(context).pop();
                  context.read<RoleExtendBloc>().add(GetRoleExtend());
                });
              } else {
                errorAlert(
                    context, "Delete Failed", "Role Delete Failed", () {
                  Navigator.of(context).pop();
                  context.read<RoleExtendBloc>().add(GetRoleExtend());
                });
              }
            }
            ////Added State
            if (state is RoleExtendAddedState) {
              if (state.response['success']) {
                successAlert(
                    context, "Adding Successfull!", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<RoleExtendBloc>().add(GetRoleExtend());
                });
              } else {
                errorAlert(context, "Adding Failed", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<RoleExtendBloc>().add(GetRoleExtend());
                });
              }
            }
          },
          builder: (context, state) {
            if (state is RoleExtendLoadedState) {
              rolesExtend = {};
              roles = state.roles;

              if (state.rolesExtend.isNotEmpty) {
                for (var roleExt in state.rolesExtend) {
                  if (!rolesExtend.keys
                      .contains(roleExt.roleExtendMain.name!.toLowerCase())) {
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
                      trailing: IconButton(
                        color: Colors.grey.shade600,
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          confirmAlert(context, () {
                            context.read<RoleExtendBloc>().add(DeleteRoleExtend(
                                roleExtendId: rolesExtend.values
                                    .toList()[index.section][index.index]
                                    .id));
                          }, "Delete?", "Confirm Delete?");
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
            if (state is RoleExtendErrorState) {
              return SomethingWentWrong(
                  message: state.message, onpressed: () {
                              context.read<RoleExtendBloc>().add(GetRoleExtend());
                  });
            }if(state is RoleExtendErrorAddingState){
              return SomethingWentWrong(message: "Error adding role extend. Please try again!", onpressed: (){
                context.read<RoleExtendBloc>().add(AddRoleExtend(roleId: state.roleId, roleExtendsId: state.roleExtendsId));
              });
            }if(state is RoleExtendErrorDeletingState){
              return SomethingWentWrong(message: "Error deleting role extend. Please try again!", onpressed: (){
                context.read<RoleExtendBloc>().add(DeleteRoleExtend(roleExtendId: state.roleExtendId));
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
