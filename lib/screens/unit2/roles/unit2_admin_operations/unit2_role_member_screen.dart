import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:unit2/bloc/role/unit2_role_assignment/unit2_role_assignment_bloc.dart';
import 'package:unit2/model/profile/basic_information/primary-information.dart';
import 'package:unit2/sevices/roles/unit2_role_assignment/unit2_role_assignment_services.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/empty_data.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import '../../../../model/rbac/assigned_role.dart';
import '../../../../model/rbac/rbac.dart';
import '../../../../theme-data.dart/btn-style.dart';
import '../../../../theme-data.dart/colors.dart';
import '../../../../utils/alerts.dart';
import '../../../../utils/global_context.dart';

class EstPointPersonRoleAssignmentScreen extends StatelessWidget {
  final int id;
  const EstPointPersonRoleAssignmentScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    Map<String, List<Content>> assignedRoles = {};
    List<AssignedRole> roles = [];
    List<ValueItem> valueItemAssignableRoles = [];
    List<ValueItem> selectedValueItemAssignableRoles = [];
    List<RBAC> assignabledRoles = [];
    List<Content> users = [];
    List<int> userIds = [];
    int? selectedUserId;
    final formKey = GlobalKey<FormBuilderState>();
    final parent = context;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Role Members"),
        backgroundColor: primary,
        actions: [
          AddLeading(onPressed: () {
            for (var role in roles) {
              String fullname =
                  "${role.user!.firstName} ${role.user!.lastName}";
              if (!userIds.contains(role.user!.id)) {
                userIds.add(role.user!.id);
                users.add(Content(id: role.user!.id, name: fullname));
              }
            }
            showDialog(
                context: NavigationService.navigatorKey.currentState!.context,
                builder: (context) {
                  valueItemAssignableRoles = assignabledRoles.map((e) {
                    return ValueItem(label: e.name!, value: e.id.toString());
                  }).toList();
                  return AlertDialog(
                    title: const Text("Assign Role to User"),
                    content: FormBuilder(
                        key: formKey,
                        child: SizedBox(
                          height: 300,
                          child: Column(
                            children: [
                              SizedBox(
                                width: screenWidth,
                                child: SearchableDropdownFormField.paginated(
                                  dropDownMaxHeight: 200,
                                  errorWidget: (value) {
                                    return Text(value!);
                                  },
                                  noRecordTex: const SizedBox(
                                    width: double.infinity,
                                    height: 200,
                                    child: Text("No User Found"),
                                  ),

                                  isDialogExpanded: false,
                                  hintText: const Text('Search User'),
                                  margin: const EdgeInsets.all(15),
                                  backgroundDecoration: (child) {
                                    return SizedBox(
                                      width: double.infinity,
                                      child: Card(
                                        child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: child),
                                      ),
                                    );
                                  },
                                  validator: FormBuilderValidators.required(
                                      errorText: "This field is required"),
                                  paginatedRequest:
                                      (int page, String? searchKey) async {
                                    List<Profile> profiles = [];
                                    try {
                                      profiles =
                                          await EstPointPersonRoleAssignment
                                              .instance
                                              .searchUser(
                                                  lastname: searchKey,
                                                  webUserId: id);
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    }
                                    return profiles.map((e) {
                                      return SearchableDropdownMenuItem(
                                          value: e,
                                          onTap: () {},
                                          label: "${e.firstName} ${e.lastName}",
                                          child: Text(
                                              "${e.firstName} ${e.lastName}"));
                                    }).toList();
                                  },

                                  requestItemCount: 5,
                                  //// on chage
                                  onChanged: (value) {
                                    selectedUserId = value?.webuserId;
                                  },
                                ),
                              ),
                              Flexible(
                                child: SizedBox(
                                  height: 60,
                                  width: screenWidth * .60,
                                  child: MultiSelectDropDown(
                                    onOptionSelected:
                                        (List<ValueItem> selectedOptions) {
                                      selectedValueItemAssignableRoles =
                                          selectedOptions;
                                    },
                                    borderColor: Colors.grey,
                                    borderWidth: 1,
                                    borderRadius: 5,
                                    hint: "Select Roles",
                                    padding: const EdgeInsets.all(8),
                                    options: valueItemAssignableRoles,
                                    selectionType: SelectionType.multi,
                                    chipConfig: const ChipConfig(
                                        wrapType: WrapType.wrap),
                                    dropdownHeight: 300,
                                    optionTextStyle:
                                        const TextStyle(fontSize: 16),
                                    selectedOptionIcon:
                                        const Icon(Icons.check_circle),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 100,
                              ),
                              SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                      style: mainBtnStyle(
                                          primary, Colors.transparent, second),
                                      onPressed: () {
                                        if (formKey.currentState!
                                                .saveAndValidate() &&
                                            selectedValueItemAssignableRoles
                                                .isNotEmpty) {
                                          List<int> rolesId = [];
                                          for (var role in assignabledRoles) {
                                            for (var element in selectedValueItemAssignableRoles) {
                                              if (element.value ==
                                                  role.id.toString()) {
                                                rolesId.add(role.id!);
                                              }
                                            }
                                          }
                                          parent
                                              .read<Unit2RoleAssignmentBloc>()
                                              .add(EstPointPersonAssignRole(
                                                  rolesId: rolesId,
                                                  assingerId: id,
                                                  userId: selectedUserId!));
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text("Add"))),
                            ],
                          ),
                        )),
                  );
                });
          })
        ],
      ),
      body: LoadingProgress(
        child: BlocConsumer<Unit2RoleAssignmentBloc, Unit2RoleAssignmentState>(
          listener: (context, state) {
          if (state is EstPointPersonRoleLoadingState) {
            final progress = ProgressHUD.of(context);
            progress!.showWithText("Please wait...");
          }
          if (state is EstPointPersonRolesUnderLoadedState ||
              state is EstPointPersonRoleUnderAddedState ||
              state is EstPointPersonDeletedState || state is EstPointPersonRolesUnderErrorState || state is EstPointPersonAssignError || state is EstPointPersonDeletingRoleError) {
            final progress = ProgressHUD.of(context);
            progress!.dismiss();
          }
          ////Added State
          if (state is EstPointPersonRoleUnderAddedState) {
            if (state.response['success']) {
              successAlert(
                  context, "Adding Successfull!", state.response['message'],
                  () {
                Navigator.of(context).pop();
                context
                    .read<Unit2RoleAssignmentBloc>()
                    .add(GetEstPointPersonRolesUnder(userId: id));
              });
            } else {
              errorAlert(context, "Adding Failed", state.response['message'],
                  () {
                Navigator.of(context).pop();
                context
                    .read<Unit2RoleAssignmentBloc>()
                    .add(GetEstPointPersonRolesUnder(userId: id));
              });
            }
          }
          ////Deleted State
          if (state is EstPointPersonDeletedState) {
            if (state.success) {
              successAlert(
                  context, "Delete Successfull!", "Role Deleted Successfully",
                  () {
                Navigator.of(context).pop();
                context
                    .read<Unit2RoleAssignmentBloc>()
                    .add(GetEstPointPersonRolesUnder(userId: id));
              });
            } else {
              errorAlert(context, "Delete Failed", "Role Delete Failed", () {
                Navigator.of(context).pop();
                context
                    .read<Unit2RoleAssignmentBloc>()
                    .add(GetEstPointPersonRolesUnder(userId: id));
              });
            }
          }
        },
            builder: (context, state) {
          if (state is EstPointPersonRolesUnderLoadedState) {
            roles = state.assignedRoles;
            assignabledRoles = state.assignableRole;
            assignedRoles = {};
            if (state.assignedRoles.isNotEmpty) {
              for (var assignedRole in state.assignedRoles) {
                String? fullName =
                    "${assignedRole.user!.firstName} ${assignedRole.user!.lastName}";
                if (!assignedRoles.keys.contains(fullName)) {
                  assignedRoles.addAll({fullName: []});
                  assignedRoles[fullName]!.add(Content(
                      id: assignedRole.id!, name: assignedRole.role!.name!));
                } else {
                  assignedRoles[fullName]!.add(Content(
                      id: assignedRole.id!, name: assignedRole.role!.name!));
                }
              }
            }
            if (state.assignedRoles.isNotEmpty) {
              return GroupListView(
                sectionsCount: assignedRoles.keys.toList().length,
                countOfItemInSection: (int section) {
                  return assignedRoles.values.toList()[section].length;
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemBuilder: (BuildContext context, IndexPath index) {
                  return ListTile(
                    trailing: IconButton(
                      color: Colors.grey.shade600,
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        confirmAlert(context, () {
                          context.read<Unit2RoleAssignmentBloc>().add(
                              EstPointPersonDeleteAssignRole(
                                  roleId: assignedRoles.values
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
                            assignedRoles.values
                                .toList()[index.section][index.index]
                                .name
                                .toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: primary),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                groupHeaderBuilder: (BuildContext context, int section) {
                  return ListTile(
                    tileColor: second,
                    title: Text(
                      assignedRoles.keys.toList()[section].toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white),
                    ),
                  );
                },
              );
            } else {
              return const EmptyData(message: "Empty");
            }
          }
          if (state is EstPointPersonRolesUnderErrorState) {
            return SomethingWentWrong(
                message: "something went wrong. Please try again!",
                onpressed: () {
                  context
                      .read<Unit2RoleAssignmentBloc>()
                      .add(GetEstPointPersonRolesUnder(userId: id));
                });
          }if(state is EstPointPersonAssignError){
            return SomethingWentWrong(message: "Error assigning role. Please try again!", onpressed: (){
              
            });
          }
          return Container();
        }, ),
      ),
    );
  }
}

class Content {
  final int id;
  final String name;
  const Content({required this.id, required this.name});
}
