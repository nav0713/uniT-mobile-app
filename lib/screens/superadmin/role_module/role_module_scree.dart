import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:unit2/bloc/rbac/rbac_operations/role_module/role_module_bloc.dart';
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

class RbacRoleModuleScreen extends StatelessWidget {
  final int id;
  const RbacRoleModuleScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final parent = context;
    Map<String, List<Content>> roleModules = {};
    List<RBAC> modules = [];
    List<RBAC> roles = [];
    RBAC? selectedRole;
    List<ValueItem> valueItemModules = [];
    List<ValueItem> selectedValueItemModules = [];
    final formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text("Role Module Screen"),
        centerTitle: true,
        actions: context.watch<RoleModuleBloc>().state
                    is RoleModuleLoadingState ||
                context.watch<RoleModuleBloc>().state is RoleModuleErrorState ||
                context.watch<RoleModuleBloc>().state is RoleModuleAddedState ||
                context.watch<RoleModuleBloc>().state is RoleModuleDeletedState
            ? []
            : [
                AddLeading(onPressed: () {
                  showDialog(
                      context:
                          NavigationService.navigatorKey.currentState!.context,
                      builder: (BuildContext context) {
                        valueItemModules = modules.map((e) {
                          return ValueItem(label: e.name!, value: e.name);
                        }).toList();
                        return AlertDialog(
                          title: const Text("Add Role Module"),
                          content: FormBuilder(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FormBuilderDropdown<RBAC>(
                                    validator: FormBuilderValidators.required(
                                        errorText: "This field is required"),
                                    name: "role",
                                    decoration:
                                        normalTextFieldStyle("Role", "Role"),
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
                                      selectedValueItemModules =
                                          selectedOptions;
                                    },
                                    borderColor: Colors.grey,
                                    borderWidth: 1,
                                    borderRadius: 5,
                                    hint: "Modules",
                                    padding: const EdgeInsets.all(8),
                                    options: valueItemModules,
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
                                              selectedValueItemModules
                                                  .isNotEmpty) {
                                            int assignerId = id;
                                            int roleId = selectedRole!.id!;
                                            List<int> modulesId = [];
                                            for (var module in modules) {
                                              for (var element in selectedValueItemModules) {
                                                if (element.label
                                                        .toLowerCase() ==
                                                    module.name
                                                        ?.toLowerCase()) {
                                                  modulesId.add(module.id!);
                                                }
                                              }
                                            }
                                            Navigator.of(context).pop();
                                            parent.read<RoleModuleBloc>().add(
                                                AddRoleModule(
                                                    assignerId: assignerId,
                                                    roleId: roleId,
                                                    moduleIds: modulesId));
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

        child: BlocConsumer<RoleModuleBloc, RoleModuleState>(
          listener: (context, state) {
            if (state is RoleModuleLoadingState) {
              final progress = ProgressHUD.of(context);
              progress!.showWithText("Please wait...");
            }
            if (state is RoleModuleLoadedState ||
                state is RoleModuleErrorState ||
                state is RoleModuleDeletedState ||
                state is RoleModuleErrorAddingState ||
                state is RoleModuleErrorDeletingState) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }

            ////Deleted State
            if (state is RoleModuleDeletedState) {
              if (state.success) {
                successAlert(context, "Delete Successfull!",
                    "Role Module Deleted Successfully", () {
                  Navigator.of(context).pop();
                  context.read<RoleModuleBloc>().add(GetRoleModules());
                });
              } else {
                errorAlert(
                    context, "Delete Failed", "Role Module Deletion Failed",
                    () {
                  Navigator.of(context).pop();
                  context.read<RoleModuleBloc>().add(GetRoleModules());
                });
              }
            }
            ////Added State
            if (state is RoleModuleAddedState) {
              if (state.response['success']) {
                successAlert(
                    context, "Adding Successfull!", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<RoleModuleBloc>().add(GetRoleModules());
                });
              } else {
                errorAlert(context, "Adding Failed", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<RoleModuleBloc>().add(GetRoleModules());
                });
              }
            }
          },
          builder: (context, state) {
            if (state is RoleModuleLoadedState) {
              modules = state.modules;
              roles = state.roles;
              roleModules = {};
              if (state.roleModules.isNotEmpty) {
                for (var roleMod in state.roleModules) {
                  if (!roleModules.keys
                      .contains(roleMod.role!.name!.toLowerCase())) {
                    roleModules.addAll({roleMod.role!.name!.toLowerCase(): []});
                    roleModules[roleMod.role!.name!.toLowerCase()]!.add(
                        Content(id: roleMod.id!, name: roleMod.module!.name!));
                  } else {
                    roleModules[roleMod.role!.name!.toLowerCase()]!.add(
                        Content(id: roleMod.id!, name: roleMod.module!.name!));
                  }
                }
              }

              if (state.roleModules.isNotEmpty) {
                return GroupListView(
                  sectionsCount: roleModules.keys.toList().length,
                  countOfItemInSection: (int section) {
                    return roleModules.values.toList()[section].length;
                  },
                  itemBuilder: (BuildContext context, IndexPath index) {
                    return ListTile(
                      dense: true,
                      trailing: IconButton(
                        color: Colors.grey.shade600,
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          confirmAlert(context, () {
                            context.read<RoleModuleBloc>().add(DeleteRoleModule(
                                roleModuleId: roleModules.values
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
                              roleModules.values
                                  .toList()[index.section][index.index]
                                  .name
                                  .toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(color: primary),
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
                        roleModules.keys.toList()[section].toUpperCase(),
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
                    message:
                        "No Role Module available. Please click + to add.");
              }
            }
            if (state is RoleModuleErrorState) {
              return SomethingWentWrong(
                  message: state.message,
                  onpressed: () {
                    context.read<RoleModuleBloc>().add(GetRoleModules());
                  });
            }
            if (state is RoleModuleErrorAddingState) {
              return SomethingWentWrong(
                  message: "Error adding role module. Please try again!",
                  onpressed: () {
                    context.read<RoleModuleBloc>().add(AddRoleModule(
                        assignerId: state.assignerId,
                        roleId: state.roleId,
                        moduleIds: state.moduleIds));
                  });
            }
            if (state is RoleModuleErrorDeletingState) {
              return SomethingWentWrong(
                  message: "Error deleting role module. Please try again.",
                  onpressed: () {
                    context.read<RoleModuleBloc>().add(
                        DeleteRoleModule(roleModuleId: state.roleModuleId));
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
