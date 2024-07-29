import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:searchfield/searchfield.dart';
import 'package:unit2/bloc/rbac/rbac_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/model/rbac/new_permission.dart';
import 'package:unit2/model/rbac/permission.dart';
import 'package:unit2/model/rbac/rbac.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import '../../../../model/profile/basic_information/primary-information.dart';
import '../../../../sevices/roles/rbac_services.dart';
import '../../../../theme-data.dart/box_shadow.dart';
import '../../../../theme-data.dart/form-style.dart';
import '../../../../utils/alerts.dart';
import 'add_rbac.dart';

class RBACScreen extends StatefulWidget {
  const RBACScreen({super.key});

  @override
  State<RBACScreen> createState() => _RBACScreenState();
}

class _RBACScreenState extends State<RBACScreen> {
  ////roles
  final roleFocusNode = FocusNode();
  final roleController = TextEditingController();
  RBAC? selectedRole;

  ////modules
  final moduleFocusNode = FocusNode();
  final moduleController = TextEditingController();
  RBAC? selectedModule;

////permissions
  final permissionFocusNode = FocusNode();
  final permissionController = TextEditingController();
  List<ValueItem> valueItemSelectedPermissions = [];
  List<ValueItem> valueItemPermission = [];

////Object
  RBAC? selectedObject;
  final objectFocusNode = FocusNode();
  final objectController = TextEditingController();

  ////operations
  List<int> operationsId = [];
  List<RBAC> newOperations = [];
  List<ValueItem> valueItemOperation = [];
  List<ValueItem> selectedValueItemOperation = [];

  String? token;

  ////new permission
  List<NewPermission> newPermissions = [];

  final formKey = GlobalKey<FormBuilderState>();
  final addRbacFormKey = GlobalKey<FormBuilderState>();
  final newOperationKey = GlobalKey<FormBuilderState>();
  int? selectedWebUserId;
  bool showAddOperations = false;
  @override
  void dispose() {
    moduleFocusNode.dispose();
    moduleController.dispose();
    roleFocusNode.dispose();
    roleController.dispose();
    permissionFocusNode.dispose();
    permissionController.dispose();
    objectFocusNode.dispose();
    objectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const FittedBox(
            child: Text("Role Based Access Control"),
          ),
          backgroundColor: primary,
        ),
        body: LoadingProgress(

          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoggedIn) {
                token = state.userData!.user!.login!.token;
                return BlocConsumer<RbacBloc, RbacState>(
                  listener: (context, state) {
                    final progress = ProgressHUD.of(context);
                    progress!.showWithText("Please wait...");
                    if (state is RbacScreenSetted || state is RbacErrorState) {
                      final progress = ProgressHUD.of(context);
                      progress!.dismiss();
                    }
                    if (state is RbacAssignedState) {
                      if (state.responseStatus['success']) {
                        successAlert(context, "Assigning Successfull!",
                            state.responseStatus['message'], () {
                          Navigator.of(context).pop();
                          context.read<RbacBloc>().add(LoadRbac());
                        });
                      } else {
                        errorAlert(context, "Assigning Failed!",
                            state.responseStatus['message'], () {
                          Navigator.of(context).pop();
                          context.read<RbacBloc>().add(LoadRbac());
                        });
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is RbacScreenSetted) {
                      //// permission value item
                      valueItemPermission =
                          state.permission.map((RBACPermission permission) {
                        return ValueItem(
                            label:
                                "${permission.operation?.name} - ${permission.object?.name!}",
                            value: permission.id.toString());
                      }).toList();
                      ////value item operation
                      valueItemOperation =
                          state.operations.map((RBAC operation) {
                        return ValueItem(
                            label: operation.name!,
                            value: operation.id.toString());
                      }).toList();
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 32, horizontal: 34),
                        child: FormBuilder(
                            key: formKey,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 38,
                                ),
                                Flexible(
                                    child: Column(
                                  children: [
                                    ////users
                                    SearchableDropdownFormField.paginated(
                                      margin: const EdgeInsets.all(0),
                                      trailingIcon: const Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.grey,
                                          )),
                                      hintText: const Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text(
                                            "Search User",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16),
                                          )),
                                      searchHintText: "Search User",
                                      backgroundDecoration: (child) {
                                        return SizedBox(
                                            width: double.infinity,
                                            child: Container(
                                              width: double.infinity,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: child,
                                            ));
                                      },
                                      paginatedRequest:
                                          (int page, String? searchKey) async {
                                        List<Profile> users = await RbacServices
                                            .instance
                                            .searchUser(
                                                page: page,
                                                name: searchKey ??= "",
                                                token: token!);
                                        return users.map((e) {
                                          String fullname =
                                              "${e.firstName} ${e.lastName}";
                                          return SearchableDropdownMenuItem<
                                              Profile>(
                                            label: fullname,
                                            child: ListTile(
                                              title: Text(fullname),
                                              subtitle:
                                                  Text(e.birthdate.toString()),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                selectedWebUserId = e.webuserId;
                                              });
                                            },
                                          );
                                        }).toList();
                                      },
                                    ),

                                    const SizedBox(
                                      height: 12,
                                    ),
                                    ////Role
                                    StatefulBuilder(
                                        builder: (context, setState) {
                                      return SearchField(
                                          itemHeight: 40,
                                          suggestionsDecoration: searchFieldDecoration(),
                                          suggestions: state.role
                                              .map((RBAC role) =>
                                                  SearchFieldListItem(
                                                      role.name!,
                                                      item: role,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                        child: ListTile(
                                                            title: Text(
                                                          role.name!,
                                                          overflow: TextOverflow
                                                              .visible,
                                                        )),
                                                      )))
                                              .toList(),
                                          validator: (agency) {
                                            if (agency!.isEmpty) {
                                              return "This field is required";
                                            }
                                            return null;
                                          },
                                          focusNode: roleFocusNode,
                                          searchInputDecoration:
                                              normalTextFieldStyle("Role *", "")
                                                  .copyWith(
                                                      suffixIcon: IconButton(
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            onPressed: () {
                                              roleFocusNode.unfocus();
                                            },
                                          )),
                                          onSuggestionTap: (role) {
                                            setState(() {
                                              selectedRole = role.item;
                                              roleFocusNode.unfocus();
                                            });
                                          },
                                          ////Add new role
                                          emptyWidget: AddRbac(
                                            formKey: addRbacFormKey,
                                            title: "Add Role",
                                            onpressed: () {
                                              RBAC? newRole;
                                              if (addRbacFormKey.currentState!
                                                  .saveAndValidate()) {
                                                newRole = RBAC(
                                                    id: null,
                                                    name: addRbacFormKey
                                                        .currentState
                                                        ?.value['object_name'],
                                                    slug: addRbacFormKey
                                                        .currentState
                                                        ?.value['slug'],
                                                    shorthand: addRbacFormKey
                                                        .currentState
                                                        ?.value['shorthand'],
                                                    fontawesomeIcon: null,
                                                    createdAt: null,
                                                    updatedAt: null,
                                                    createdBy: null,
                                                    updatedBy: null);
                                              }
                                              setState(() {
                                                state.role.insert(0, newRole!);
                                              });
                                              roleFocusNode.unfocus();
                                              Navigator.pop(context);
                                            },
                                          ));
                                    }),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    // //// Modules
                                    StatefulBuilder(
                                        builder: (context, setState) {
                                      return SearchField(
                                          itemHeight: 40,
                                          suggestionsDecoration: searchFieldDecoration(),
                                          suggestions: state.modules
                                              .map((RBAC module) =>
                                                  SearchFieldListItem(
                                                      module.name!,
                                                      item: module,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                        child: ListTile(
                                                            title: Text(
                                                          module.name!,
                                                          overflow: TextOverflow
                                                              .visible,
                                                        )),
                                                      )))
                                              .toList(),
                                          validator: (module) {
                                            if (module!.isEmpty) {
                                              return "This field is required";
                                            }
                                            return null;
                                          },
                                          focusNode: moduleFocusNode,
                                          searchInputDecoration:
                                              normalTextFieldStyle(
                                                      "Module *", "")
                                                  .copyWith(
                                                      suffixIcon: IconButton(
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            onPressed: () {
                                              moduleFocusNode.unfocus();
                                            },
                                          )),
                                          onSuggestionTap: (module) {
                                            setState(() {
                                              selectedModule = module.item;
                                              moduleFocusNode.unfocus();
                                            });
                                          },
                                          //       //// Add new module

                                          emptyWidget: AddRbac(
                                            formKey: addRbacFormKey,
                                            title: "Add Module",
                                            onpressed: () {
                                              RBAC? newModule;
                                              if (addRbacFormKey.currentState!
                                                  .saveAndValidate()) {
                                                newModule = RBAC(
                                                    id: null,
                                                    name: addRbacFormKey
                                                        .currentState
                                                        ?.value['object_name'],
                                                    slug: addRbacFormKey
                                                        .currentState
                                                        ?.value['slug'],
                                                    shorthand: addRbacFormKey
                                                        .currentState
                                                        ?.value['shorthand'],
                                                    fontawesomeIcon: null,
                                                    createdAt: null,
                                                    updatedAt: null,
                                                    createdBy: null,
                                                    updatedBy: null);
                                              }
                                              setState(() {
                                                state.modules
                                                    .insert(0, newModule!);
                                              });
                                              moduleFocusNode.unfocus();
                                              Navigator.pop(context);
                                            },
                                          ));
                                    }),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    //// Permission

                                    StatefulBuilder(
                                        builder: (context, setState) {
                                      return SizedBox(
                                        width: double.infinity,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: MultiSelectDropDown(
                                                  onOptionSelected:
                                                      (List<ValueItem>
                                                          selectedOptions) {
                                                    setState(() {
                                                      valueItemSelectedPermissions =
                                                          selectedOptions;
                                                    });
                                                  },
                                                  hint: "Permissions",
                                                  hintStyle: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  options: valueItemPermission,
                                                  selectionType:
                                                      SelectionType.multi,
                                                  chipConfig: const ChipConfig(
                                                      wrapType:
                                                          WrapType.scroll),
                                                  dropdownHeight: 300,
                                                  optionTextStyle:
                                                      const TextStyle(
                                                          fontSize: 16),
                                                  selectedOptionIcon:
                                                      const Icon(
                                                          Icons.check_circle),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              IconButton(
                                                  ////Add Permission not the dialog add button
                                                  onPressed: () {
                                                    final addPermissionFormKey =
                                                        GlobalKey<FormState>();
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          String? objectname;
                                                          String? slug;
                                                          String? shorthand;
                                                          return AlertDialog(
                                                              title: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      child: !showAddOperations
                                                                          ? const Text(
                                                                              "Add new Permission")
                                                                          : const Text(
                                                                              "Add new Operation"),
                                                                    ),
                                                                  ),
                                                                  ////close button
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          showAddOperations =
                                                                              false;
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .close))
                                                                ],
                                                              ),
                                                              content: StatefulBuilder(
                                                                  builder: (context,
                                                                      stateSetter) {
                                                                return showAddOperations
                                                                    ////add permission content if choice is in the choices
                                                                    ? FormBuilder(
                                                                        key:
                                                                            newOperationKey,
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            FormBuilderTextField(
                                                                              onChanged: (value) {
                                                                                objectname = value!;
                                                                              },
                                                                              autovalidateMode: AutovalidateMode.always,
                                                                              validator: FormBuilderValidators.required(errorText: "This field is required"),
                                                                              name: "object_name",
                                                                              decoration: normalTextFieldStyle("Object name *", "Object name "),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 8,
                                                                            ),
                                                                            FormBuilderTextField(
                                                                              onChanged: (value) {
                                                                                slug = value!;
                                                                              },
                                                                              name: "slug",
                                                                              decoration: normalTextFieldStyle("Slug *", "Slug"),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 8,
                                                                            ),
                                                                            FormBuilderTextField(
                                                                              onChanged: (value) {
                                                                                shorthand = value!;
                                                                              },
                                                                              name: "shorthand",
                                                                              decoration: normalTextFieldStyle("Shorthand *", "Shorthand"),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 12,
                                                                            ),
                                                                            SizedBox(
                                                                                width: double.infinity,
                                                                                height: 50,
                                                                                /////Add new Operation submit button
                                                                                child: ElevatedButton(
                                                                                    style: mainBtnStyle(primary, Colors.transparent, second),
                                                                                    onPressed: () async {
                                                                                      if (newOperationKey.currentState!.saveAndValidate()) {
                                                                                        RBAC newOperation = RBAC(id: null, name: objectname, slug: slug, shorthand: shorthand, fontawesomeIcon: null, createdAt: null, updatedAt: null, createdBy: null, updatedBy: null);
                                                                                        stateSetter(() {
                                                                                          newOperations.add(newOperation);
                                                                                          valueItemOperation.insert(0, ValueItem(label: newOperation.name!, value: newOperation.name));
                                                                                          showAddOperations = false;
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                    child: const Text("Add"))),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ////add permission content if choice is in the choices
                                                                    : Form(
                                                                        key:
                                                                            addPermissionFormKey,
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            ////Object
                                                                            SizedBox(
                                                                                width: double.infinity,
                                                                                child:
                                                                                    ////Row ofr operation and add operation
                                                                                    Row(
                                                                                  children: [
                                                                                    ////Operations
                                                                                    Expanded(
                                                                                      child: MultiSelectDropDown(
                                                                                        onOptionSelected: (List<ValueItem> selectedOptions) {
                                                                                          stateSetter(() {
                                                                                            ////get operation ids
                                                                                            selectedValueItemOperation = selectedOptions;
                                                                                          });
                                                                                        },
                                                                                        borderColor: Colors.grey,
                                                                                        borderWidth: 1,
                                                                                        borderRadius: 5,
                                                                                        hint: "Operations",
                                                                                        hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                                                                                        padding: const EdgeInsets.all(8),
                                                                                        options: valueItemOperation,
                                                                                        selectionType: SelectionType.multi,
                                                                                        chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                                                                                        dropdownHeight: 300,
                                                                                        optionTextStyle: const TextStyle(fontSize: 16),
                                                                                        selectedOptionIcon: const Icon(Icons.check_circle),
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                    Container(
                                                                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                                                                                      child: IconButton(
                                                                                          ////Add Operation beside row button
                                                                                          onPressed: () {
                                                                                            stateSetter(() {
                                                                                              showAddOperations = true;
                                                                                            });
                                                                                          },
                                                                                          icon: const Icon(Icons.add)),
                                                                                    )
                                                                                  ],
                                                                                )),
                                                                            const SizedBox(
                                                                              height: 12,
                                                                            ),
                                                                            SearchField(
                                                                                itemHeight: 40,
                                                                                suggestionsDecoration: searchFieldDecoration(),
                                                                                suggestions: state.objects
                                                                                    .map((RBAC object) => SearchFieldListItem(object.name!,
                                                                                        item: object,
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                                          child: ListTile(
                                                                                              title: Text(
                                                                                            object.name!,
                                                                                            overflow: TextOverflow.visible,
                                                                                          )),
                                                                                        )))
                                                                                    .toList(),
                                                                                validator: (module) {
                                                                                  if (module!.isEmpty) {
                                                                                    return "This field is required";
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                focusNode: objectFocusNode,
                                                                                searchInputDecoration: normalTextFieldStyle("Object *", "").copyWith(
                                                                                    suffixIcon: IconButton(
                                                                                  icon: const Icon(Icons.arrow_drop_down),
                                                                                  onPressed: () {
                                                                                    objectFocusNode.unfocus();
                                                                                  },
                                                                                )),
                                                                                onSuggestionTap: (object) {
                                                                                  stateSetter(() {
                                                                                    selectedObject = object.item;
                                                                                    objectFocusNode.unfocus();
                                                                                  });
                                                                                },
                                                                                ////Add new Object
                                                                                emptyWidget: AddRbac(
                                                                                  formKey: addRbacFormKey,
                                                                                  title: "Add Add Object",
                                                                                  onpressed: () {
                                                                                    if (addRbacFormKey.currentState!.saveAndValidate()) {
                                                                                      RBAC? newObject;

                                                                                      if (addRbacFormKey.currentState!.saveAndValidate()) {
                                                                                        newObject = RBAC(id: null, name: addRbacFormKey.currentState?.value['object_name'], slug: addRbacFormKey.currentState?.value['slug'], shorthand: addRbacFormKey.currentState?.value['shorthand'], fontawesomeIcon: null, createdAt: null, updatedAt: null, createdBy: null, updatedBy: null);
                                                                                      }
                                                                                      stateSetter(() {
                                                                                        state.objects.insert(0, newObject!);
                                                                                      });
                                                                                      objectFocusNode.unfocus();
                                                                                      Navigator.pop(context);
                                                                                    }
                                                                                  },
                                                                                )),
                                                                            const SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            SizedBox(
                                                                                width: double.infinity,
                                                                                height: 50,
                                                                                child: ElevatedButton(
                                                                                  onPressed: () {
                                                                                    ////Add Operation
                                                                                    if (addPermissionFormKey.currentState!.validate()) {
                                                                                      for (var e in selectedValueItemOperation) {
                                                                                        setState(() {
                                                                                          // state.permission.insert(0, Permission(id: null, object: selectedObject!, operation: RBAC(id: null, name: e.label, slug: null, shorthand: null, fontawesomeIcon: null, createdAt: null, updatedAt: null, createdBy: null, updatedBy: null), createdAt: null, updatedAt: null, createdBy: null, updatedBy: null));
                                                                                          valueItemPermission.insert(0, ValueItem(label: "${selectedObject!.name} - ${e.label}", value: null));
                                                                                          valueItemPermission = valueItemPermission;
                                                                                        });
                                                                                      }
                                                                                      Navigator.pop(context);
                                                                                      setState(() {});
                                                                                    }
                                                                                  },
                                                                                  style: mainBtnStyle(primary, Colors.transparent, second),
                                                                                  child: const Text("Submit"),
                                                                                ))
                                                                          ],
                                                                        ));
                                                              }));
                                                        });
                                                  },
                                                  icon: const Icon(Icons.add)),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                  ],
                                )),
                                SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      style: mainBtnStyle(
                                          primary, Colors.transparent, second),
                                      onPressed: () {
                                        if (formKey.currentState!
                                            .saveAndValidate()) {
                                          ////existing permission
                                          List<int> permissions =
                                              valueItemSelectedPermissions
                                                  .map((e) =>
                                                      int.parse(e.value!))
                                                  .toList();

                                          context.read<RbacBloc>().add(
                                              AssignedRbac(
                                                  assigneeId:
                                                      selectedWebUserId!,
                                                  assignerId: 63,
                                                  newPermissions: const [],
                                                  permissionId: permissions,
                                                  selectedModule:
                                                      selectedModule,
                                                  selectedRole: selectedRole));
                                        }
                                        print(valueItemSelectedPermissions
                                            .length);
                                      },
                                      child: const Text("submit")),
                                )
                              ],
                            )),
                      );
                    }
                    if (state is RbacErrorState) {
                      return SomethingWentWrong(
                          message: state.message, onpressed: () {});
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
