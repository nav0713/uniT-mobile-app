import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:gap/gap.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:unit2/bloc/rbac/rbac_operations/role/role_bloc.dart';
import 'package:unit2/bloc/role_assignment/role_assignment_bloc.dart';
import 'package:unit2/screens/superadmin/role/shared_pop_up_menu.dart';
import 'package:unit2/theme-data.dart/box_shadow.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import 'package:unit2/widgets/round_clipper.dart';
import '../../../model/rbac/rbac.dart';
import '../../../theme-data.dart/btn-style.dart';
import '../../../theme-data.dart/colors.dart';
import '../../../utils/alerts.dart';
import '../../../utils/global.dart';
import '../../../widgets/empty_data.dart';

class RbacRoleAssignment extends StatelessWidget {
  final int id;
  final String name;
  final String lname;
  const RbacRoleAssignment(
      {super.key, required this.id, required this.lname, required this.name});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    List<RBAC> roles = [];
    List<ValueItem> valueItemRoles = [];
    List<ValueItem> selectedValueItemRoles = [];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: primary,
        title: const Text("User Roles Screens"),
        actions: context.watch<RoleAssignmentBloc>().state
                    is RoleAssignmentLoadingState ||
                context.watch<RoleAssignmentBloc>().state
                    is RoleAssignmentErrorState ||
                context.watch<RoleAssignmentBloc>().state
                    is UserNotExistError ||
                context.watch<RoleAssignmentBloc>().state is RoleAddedState
            ? []
            : [
                AddLeading(onPressed: () {
                  BuildContext parent = context;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        valueItemRoles = roles.map((e) {
                          return ValueItem(label: e.name!, value: e.name);
                        }).toList();
                        return AlertDialog(
                          title: const Text("Add New Role"),
                          content: FormBuilder(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MultiSelectDropDown(
                                  onOptionSelected:
                                      (List<ValueItem> selectedOptions) {
                                    selectedValueItemRoles = selectedOptions;
                                  },
                                  borderColor: Colors.grey,
                                  borderWidth: 1,
                                  borderRadius: 5,
                                  hint: "Select Roles",
                                  padding: const EdgeInsets.all(8),
                                  options: valueItemRoles,
                                  selectionType: SelectionType.multi,
                                  chipConfig:
                                      const ChipConfig(wrapType: WrapType.wrap),
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
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                        style: mainBtnStyle(primary,
                                            Colors.transparent, second),
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .saveAndValidate()) {
                                            List<int> rolesId = [];
                                            for (var role in roles) {
                                              for (var element
                                                  in selectedValueItemRoles) {
                                                if (element.label
                                                        .toLowerCase() ==
                                                    role.name?.toLowerCase()) {
                                                  rolesId.add(role.id!);
                                                }
                                              }
                                            }
                                            parent
                                                .read<RoleAssignmentBloc>()
                                                .add(AssignRole(
                                                  assignerId: id,
                                                  roles: rolesId,
                                                ));
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text("Add"))),
                              ],
                            ),
                          ),
                        );
                      });
                })
              ],
      ),
      body: LoadingProgress(
        child: BlocConsumer<RoleAssignmentBloc, RoleAssignmentState>(
          listener: (context, state) {
            if (state is RoleAssignmentLoadingState) {
              final progress = ProgressHUD.of(context);
              progress!.showWithText("Please wait...");
            }
            if (state is AssignedRoleLoaded ||
                state is RoleAssignmentErrorState ||
                state is AssignedRoleDeletedState ||
                state is UserNotExistError ||
                state is AssignedRoleAddedState ||
                state is AssignedRoleAddingErrorState ||
                state is AssignedRoleErrorDeletingState) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }
            ////Deleted State
            if (state is AssignedRoleDeletedState) {
              if (state.success) {
                successAlert(
                    context, "Delete Successfull!", "Role Deleted Successfully",
                    () {
                  Navigator.of(context).pop();
                  context.read<RoleAssignmentBloc>().add(LoadAssignedRole());
                });
              } else {
                errorAlert(context, "Delete Failed", "Role Deletion Failed",
                    () {
                  Navigator.of(context).pop();
                  context.read<RoleAssignmentBloc>().add(LoadAssignedRole());
                });
              }
            }

            ////Added State
            if (state is AssignedRoleAddedState) {
              if (state.response['success']) {
                successAlert(
                    context, "Adding Successfull!", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<RoleAssignmentBloc>().add(LoadAssignedRole());
                });
              } else {
                errorAlert(context, "Adding Failed", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<RoleAssignmentBloc>().add(LoadAssignedRole());
                });
              }
            }
          },
          builder: (context, state) {
            final parent = context;
            if (state is AssignedRoleLoaded) {
              roles = state.roles;
              if (state.assignedRoles.isNotEmpty) {
                return SizedBox(
                  height: screenHeight - 150,
                  width: screenWidth,
                  child: Stack(
                    children: [
                      Positioned(
                        top: blockSizeVertical * 18,
                        left: screenWidth * .10,
                        child: Container(
                          width: screenWidth * .80,
                   
                          decoration: box1(),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              itemCount: state.assignedRoles.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: screenWidth,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Row(
                                        children: [
                                          CircleAvatar(
                                            child: Text('${index + 1}'),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Flexible(
                                            child: Text(
                                                state.assignedRoles[index].role!
                                                    .name!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: primary)),
                                          ),
                                        ],
                                      )),
                                      AppPopupMenu<int>(
                                        offset: const Offset(-10, -10),
                                        elevation: 3,
                                        onSelected: (value) {
                                          if (value == 1) {
                                            confirmAlert(context, () {
                                              context
                                                  .read<RoleAssignmentBloc>()
                                                  .add(DeleteAssignRole(
                                                      roleId: state
                                                          .assignedRoles[index]
                                                          .id!));
                                            }, "Delete?", "Confirm Delete?");
                                          }
                                        },
                                        menuItems: [
                                          popMenuItem(
                                              text: "Remove",
                                              value: 1,
                                              icon: Icons.delete),
                                        ],
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: Colors.grey,
                                        ),
                                        tooltip: "Options",
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
                      ClipPath(
                        clipper: RoundShape(),
                        child: Container(
                          color: primary,
                          height: 150,
                        ),
                      ),
                      Positioned(
                        top: blockSizeVertical * 3,
                        left: screenWidth * .10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: box1(),
                          height: 120,
                          width: screenWidth * .80,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  state.fullname,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(color: Colors.black54),
                                ),
                                const Gap(6),
                                Text(
                                  "Person fullname",
                                  style: Theme.of(context).textTheme.labelSmall,
                                )
                              ]),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return EmptyData(
                    message:
                        "No Role available for ${state.fullname}. Please click + to add.");
              }
            }
            if (state is RoleAssignmentErrorState) {
              return SomethingWentWrong(
                  message: state.message,
                  onpressed: () {
                    context.read<RoleAssignmentBloc>().add(
                        GetAssignedRoles(firstname: name, lastname: lname));
                  });
            }
            if (state is AssignedRoleAddingErrorState) {
              return SomethingWentWrong(
                  message: "Error Assigning Role. Please try again!",
                  onpressed: () {
                    context.read<RoleAssignmentBloc>().add(AssignRole(
                        assignerId: state.assignerId, roles: state.roles));
                  });
            }
            if (state is AssignedRoleErrorDeletingState) {
              return SomethingWentWrong(
                  message: "Error deleting assigned role. Please try again!",
                  onpressed: () {
                    context
                        .read<RoleAssignmentBloc>()
                        .add(DeleteAssignRole(roleId: state.roleId));
                  });
            }
            if (state is UserNotExistError) {
              return const Center(
                child: Text("User Not Exsit"),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
