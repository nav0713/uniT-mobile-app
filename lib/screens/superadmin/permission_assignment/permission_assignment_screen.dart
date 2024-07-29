import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:unit2/bloc/rbac/rbac_operations/permission_assignment/permission_assignment_bloc.dart';
import 'package:unit2/model/rbac/permission.dart';
import 'package:unit2/model/rbac/rbac.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/theme-data.dart/form-style.dart';
import 'package:unit2/utils/alerts.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/empty_data.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';

class RbacPermissionAssignmentScreen extends StatelessWidget {
  final int id;
  const RbacPermissionAssignmentScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final parent = context;
    Map<String, List<Content>> permissionAssignments = {};
    List<RBACPermission> permissions = [];
    List<ValueItem> valueItemPermission = [];
    List<ValueItem> selectedValueItemPermission = [];
    List<RBAC> roles = [];
    RBAC? selectedRole;

    final formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primary,
        title: const Text("Permission Assignment"),
        actions: context.watch<PermissionAssignmentBloc>().state
                    is PermissionAssignmentLoadingScreen ||
                context.watch<PermissionAssignmentBloc>().state
                    is PermissionAssignmentErrorState ||
                context.watch<PermissionAssignmentBloc>().state
                    is PermissionAssignmentAddedState ||
                context.watch<PermissionAssignmentBloc>().state
                    is PermissionAssignmentDeletedState 
            ? []
            : [
                AddLeading(onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        valueItemPermission = permissions.map((e) {
                          return ValueItem(
                              label: "${e.object!.name} - ${e.operation!.name}",
                              value: e.id.toString());
                        }).toList();
                        return AlertDialog(
                          title: const Text("Add Permission"),
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
                                      selectedValueItemPermission =
                                          selectedOptions;
                                    },
                                    borderColor: Colors.grey,
                                    borderWidth: 1,
                                    borderRadius: 5,
                                    hint: "Operations",
                                    padding: const EdgeInsets.all(8),
                                    options: valueItemPermission,
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
                                              selectedValueItemPermission
                                                  .isNotEmpty) {
                                            int assignerId = id;
                                            int roleId = selectedRole!.id!;
                                            List<int> opIds =
                                                selectedValueItemPermission
                                                    .map((e) {
                                              return int.parse(e.value!);
                                            }).toList();
                                            Navigator.pop(context);
                                            parent
                                                .read<
                                                    PermissionAssignmentBloc>()
                                                .add(AddPersmissionAssignment(
                                                    assignerId: assignerId,
                                                    opsId: opIds,
                                                    roleId: roleId));
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

        child:
            BlocConsumer<PermissionAssignmentBloc, PermissionAssignmentState>(
          listener: (context, state) {
            if (state is PermissionAssignmentLoadingScreen) {
              final progress = ProgressHUD.of(context);
              progress!.showWithText("Please wait...");
            }
            if (state is PermissionAssignmentErrorState ||
                state is PermissionAssignmentLoadedState ||
                state is PermissionAssignmentAddedState || state is PermissionAssignmentErrorAddingState || state is PermissionAssignmentErrorDeletingState) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }
            if (state is PermissionAssignmentDeletedState) {
              if (state.success) {
                successAlert(context, "Delete Successfull!",
                    "Permission Assignment Deleted Successfully", () {
                  Navigator.of(context).pop();
                  context
                      .read<PermissionAssignmentBloc>()
                      .add(GetPermissionAssignments());
                });
              } else {
                errorAlert(context, "Delete Failed",
                    "Permission Assignment Deletion Failed", () {
                  Navigator.of(context).pop();
                  context
                      .read<PermissionAssignmentBloc>()
                      .add(GetPermissionAssignments());
                });
              }
            }
            if (state is PermissionAssignmentAddedState) {
              if (state.status['success']) {
                successAlert(context, "Add Successfull!",
                    "Permission Assignment Added Successfully", () {
                  Navigator.of(context).pop();
                  context
                      .read<PermissionAssignmentBloc>()
                      .add(GetPermissionAssignments());
                });
              } else {
                errorAlert(context, "Adding Failed",
                    "Permission Assignment Adding Failed", () {
                  Navigator.of(context).pop();
                  context
                      .read<PermissionAssignmentBloc>()
                      .add(GetPermissionAssignments());
                });
              }
            }
          },
          builder: (context, state) {
            if (state is PermissionAssignmentLoadedState) {
              if (state.permissionAssignments.isNotEmpty) {
                permissions = state.permissions;
                roles = state.roles;
                permissionAssignments = {};
                for (var permissionAssignment in state.permissionAssignments) {
                  if (!permissionAssignments.keys.contains(
                      permissionAssignment.role!.name!.toLowerCase())) {
                    permissionAssignments.addAll(
                        {permissionAssignment.role!.name!.toLowerCase(): []});
                    permissionAssignments[
                            permissionAssignment.role!.name!.toLowerCase()]!
                        .add(Content(
                            id: permissionAssignment.id!,
                            name:
                                "${permissionAssignment.permission!.object!.name} - ${permissionAssignment.permission!.operation!.name} "));
                  } else {
                    permissionAssignments[
                            permissionAssignment.role!.name!.toLowerCase()]!
                        .add(Content(
                            id: permissionAssignment.id!,
                            name:
                                "${permissionAssignment.permission!.object!.name} - ${permissionAssignment.permission!.operation!.name} "));
                  }
                }
                return GroupListView(
                  sectionsCount: permissionAssignments.keys.toList().length,
                  countOfItemInSection: (int section) {
                    return permissionAssignments.values
                        .toList()[section]
                        .length;
                  },
                  itemBuilder: (BuildContext context, IndexPath index) {
                    return ListTile(
                      dense: true,
                      trailing: IconButton(
                        color: Colors.grey.shade600,
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          confirmAlert(context, () {
                            context.read<PermissionAssignmentBloc>().add(
                                DeletePermissionAssignment(
                                    id: permissionAssignments.values
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
                              permissionAssignments.values
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
                        permissionAssignments.keys
                            .toList()[section]
                            .toUpperCase(),
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
                      "No Permission Assignment available. Please click + to add",
                );
              }
            }
            if (state is PermissionAssignmentErrorState) {
              return SomethingWentWrong(
                  message: state.message,
                  onpressed: () {
                    context
                        .read<PermissionAssignmentBloc>()
                        .add(GetPermissionAssignments());
                  });
            }if(state is PermissionAssignmentErrorAddingState){
              return SomethingWentWrong(message: "Error adding permission. Please try again!", onpressed: (){
                context.read<PermissionAssignmentBloc>().add(AddPersmissionAssignment(assignerId: state.assignerId,opsId: state.opsId,roleId: state.roleId));
              });
            }if(state is PermissionAssignmentErrorDeletingState){
              return SomethingWentWrong(message: "Error deleting permission. Please try again!", onpressed: (){
                context.read<PermissionAssignmentBloc>().add(DeletePermissionAssignment(id: state.id));
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
