import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:search_page/search_page.dart';
import 'package:unit2/bloc/rbac/rbac_operations/permission/permission_bloc.dart';
import 'package:unit2/model/rbac/permission.dart';
import 'package:unit2/model/rbac/rbac.dart';
import 'package:unit2/screens/superadmin/role/shared_pop_up_menu.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/theme-data.dart/form-style.dart';
import 'package:unit2/utils/global_context.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import '../../../theme-data.dart/box_shadow.dart';
import '../../../theme-data.dart/colors.dart';
import '../../../utils/alerts.dart';
import '../../../utils/global.dart';
import '../../../widgets/empty_data.dart';

class RbacPermissionScreen extends StatelessWidget {
  final int id;
  const RbacPermissionScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    List<RBAC> objects = [];
    RBAC? selectedObject;
    List<RBAC> operations = [];
    List<ValueItem> valueItemOperations = [];
    List<ValueItem> selectedValueItemOperations = [];
    List<RBACPermission> permissions = [];
    final bloc = BlocProvider.of<PermissionBloc>(context);
    final formKey = GlobalKey<FormBuilderState>();
    BuildContext? parent;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primary,
        title: const Text("Permissions Screen"),
        actions: context
                    .watch<PermissionBloc>()
                    .state is PermissonLoadingState ||
                context.watch<PermissionBloc>().state is PermissionErrorState ||
                context.watch<PermissionBloc>().state
                    is PermissionDeletedState ||
                context.watch<PermissionBloc>().state is PermissionAddedState
            ? []
            : [
                IconButton(
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: SearchPage(
                            barTheme: ThemeData(cardColor: Colors.white),
                            builder: (RBACPermission rbac) {
                              return Column(
                                children: [
                                  Container(
                                    width: screenWidth,
                                    decoration: box1(),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                              "${rbac.object?.name} - ${rbac.operation?.name}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: primary)),
                                        ),
                                        AppPopupMenu<int>(
                                          offset: const Offset(-10, -10),
                                          elevation: 3,
                                          onSelected: (value) {
                                            if (value == 1) {
                                              confirmAlert(context, () {
                                                Navigator.pop(context);
                                                bloc.add(DeleteRbacPermission(
                                                    permissionId: rbac.id!));
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
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  )
                                ],
                              );
                            },
                            filter: (RBACPermission rbac) {
                              return [
                                rbac.object!.name! + rbac.operation!.name!
                              ];
                            },
                            failure: const Center(
                              child: Text("No permission found :("),
                            ),
                            items: permissions,
                            searchLabel: "Search Permission",
                            suggestion: const Center(
                              child: Text("Search permission by name"),
                            )),
                      );
                    },
                    icon: const Icon(Icons.search)),
                AddLeading(onPressed: () {
                  showDialog(
                      context:
                          NavigationService.navigatorKey.currentState!.context,
                      builder: (BuildContext context) {
                        valueItemOperations = operations.map((e) {
                          return ValueItem(label: e.name!, value: e.name);
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
                                    name: "object",
                                    decoration: normalTextFieldStyle(
                                        "Permission", "Permission"),
                                    items: objects.isEmpty
                                        ? []
                                        : objects.map((e) {
                                            return DropdownMenuItem(
                                                value: e, child: Text(e.name!));
                                          }).toList(),
                                    onChanged: (RBAC? object) {
                                      selectedObject = object;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  MultiSelectDropDown(
                                    onOptionSelected:
                                        (List<ValueItem> selectedOptions) {
                                      selectedValueItemOperations =
                                          selectedOptions;
                                    },
                                    borderColor: Colors.grey,
                                    borderWidth: 1,
                                    borderRadius: 5,
                                    hint: "Operations",
                                    padding: const EdgeInsets.all(8),
                                    options: valueItemOperations,
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
                                              selectedValueItemOperations
                                                  .isNotEmpty) {
                                            int assignerId = id;
                                            int objectId = selectedObject!.id!;

                                            List<int> opIds = [];
                                            for (var operation in operations) {
                                              for (var element in selectedValueItemOperations) {
                                                if (element.label
                                                        .toLowerCase() ==
                                                    operation.name
                                                        ?.toLowerCase()) {
                                                  opIds.add(operation.id!);
                                                }
                                              }
                                            }

                                            Navigator.pop(context);
                                            parent!.read<PermissionBloc>().add(
                                                AddRbacPermission(
                                                    assignerId: assignerId,
                                                    objectId: objectId,
                                                    operationIds: opIds));
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

        child: BlocConsumer<PermissionBloc, PermissionState>(
          listener: (context, state) {
            if (state is PermissonLoadingState) {
              final progress = ProgressHUD.of(context);
              progress!.showWithText("Please wait...");
            }
            if (state is PermissionLoaded ||
                state is PermissionErrorState ||
                state is PermissionAddedState ||
                state is PermissionErrorAddingState ||
                state is PermissionErrorDeletingState) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }
            ////Added State
            if (state is PermissionAddedState) {
              if (state.response['success']) {
                successAlert(
                    context, "Adding Successfull!", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<PermissionBloc>().add(GetPermissions());
                });
              } else {
                errorAlert(context, "Adding Failed", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<PermissionBloc>().add(GetPermissions());
                });
              }
            }
            ////Deleted State
            if (state is PermissionDeletedState) {
              if (state.success) {
                successAlert(context, "Delete Successfull!",
                    "Permission Deleted Successfully", () {
                  Navigator.of(context).pop();
                  context.read<PermissionBloc>().add(GetPermissions());
                });
              } else {
                errorAlert(
                    context, "Delete Failed", "Permission Deletion Failed", () {
                  Navigator.of(context).pop();
                  context.read<PermissionBloc>().add(GetPermissions());
                });
              }
            }
          },
          builder: (context, state) {
            parent = context;
            if (state is PermissionLoaded) {
              objects = state.objects;
              operations = state.operations;
              if (state.permissions.isNotEmpty) {
                permissions = state.permissions;
                return ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    itemCount: state.permissions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            width: screenWidth,
                            decoration: box1(),
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
                                          "${state.permissions[index].object?.name} - ${state.permissions[index].operation?.name}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
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
                                        context.read<PermissionBloc>().add(
                                            DeleteRbacPermission(
                                                permissionId: state
                                                    .permissions[index].id!));
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
                          ),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      );
                    });
              } else {
                return const EmptyData(
                    message: "No Permission available. Please click + to add.");
              }
            }
            if (state is PermissionErrorState) {
              return SomethingWentWrong(
                  message: state.message,
                  onpressed: () {
                    parent!.read<PermissionBloc>().add(GetPermissions());
                  });
            }
            if (state is PermissionErrorAddingState) {
              return SomethingWentWrong(
                  message: "Error adding permission. Please try again!",
                  onpressed: () {
                    context.read<PermissionBloc>().add(AddRbacPermission(
                        assignerId: state.assignerId,
                        objectId: state.objectId,
                        operationIds: state.operationIds));
                  });
            }
            if (state is PermissionErrorDeletingState) {
              return SomethingWentWrong(
                  message: "Error deleting permission. Please try again!",
                  onpressed: () {
                    context.read<PermissionBloc>().add(
                        DeleteRbacPermission(permissionId: state.permissionId));
                  });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
