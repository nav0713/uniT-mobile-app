import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:unit2/bloc/rbac/rbac_operations/module_objects/module_objects_bloc.dart';
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

class RbacModuleObjectsScreen extends StatelessWidget {
  final int id;
  const RbacModuleObjectsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final parent = context;
    Map<String, List<Content>> moduleObjects = {};
    List<RBAC> modules = [];
    List<RBAC> objects = [];
    RBAC? selectedModule;
    List<ValueItem> valueItemObjects = [];
    List<ValueItem> selectedValueItemObjects = [];
    final formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primary,
        title: const Text("Module Object Screen"),
        actions: context.watch<ModuleObjectsBloc>().state
                    is ModuleObjectLoadingState ||
                context.watch<ModuleObjectsBloc>().state
                    is ModuleObjectsErrorState ||
                context.watch<ModuleObjectsBloc>().state
                    is ModuleObjectAddedState ||
                context.watch<ModuleObjectsBloc>().state
                    is ModuleObjectDeletedState
            ? []
            : [
                AddLeading(onPressed: () {
                  showDialog(
                      context:
                          NavigationService.navigatorKey.currentState!.context,
                      builder: (BuildContext context) {
                        valueItemObjects = objects.map((e) {
                          return ValueItem(label: e.name!, value: e.name);
                        }).toList();
                        return AlertDialog(
                          title: const Text("Add New Module Object"),
                          content: FormBuilder(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FormBuilderDropdown<RBAC>(
                                    validator: FormBuilderValidators.required(
                                        errorText: "This field is required"),
                                    name: "module",
                                    decoration: normalTextFieldStyle(
                                        "Module", "Module"),
                                    items: modules.isEmpty
                                        ? []
                                        : modules.map((e) {
                                            return DropdownMenuItem(
                                                value: e, child: Text(e.name!));
                                          }).toList(),
                                    onChanged: (RBAC? object) {
                                      selectedModule = object;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  MultiSelectDropDown(
                                    onOptionSelected:
                                        (List<ValueItem> selectedOptions) {
                                      selectedValueItemObjects =
                                          selectedOptions;
                                    },
                                    borderColor: Colors.grey,
                                    borderWidth: 1,
                                    borderRadius: 5,
                                    hint: "Objects",
                                    padding: const EdgeInsets.all(8),
                                    options: valueItemObjects,
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
                                              selectedValueItemObjects
                                                  .isNotEmpty) {
                                            int assignerId = id;
                                            int moduleId = selectedModule!.id!;
                                            List<int> objectId = [];
                                            for (var object in objects) {
                                              for (var element in selectedValueItemObjects) {
                                                if (element.label
                                                        .toLowerCase() ==
                                                    object.name
                                                        ?.toLowerCase()) {
                                                  objectId.add(object.id!);
                                                }
                                              }
                                            }
                                            Navigator.of(context).pop();
                                            parent
                                                .read<ModuleObjectsBloc>()
                                                .add(AddRbacModuleObjects(
                                                    assignerId: assignerId,
                                                    moduleId: moduleId,
                                                    objectsId: objectId));
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

        child: BlocConsumer<ModuleObjectsBloc, ModuleObjectsState>(
          listener: (context, state) {
            if (state is ModuleObjectLoadingState) {
              final progress = ProgressHUD.of(context);
              progress!.showWithText("Please wait...");
            }
            if (state is ModuleObjectLoadedState ||
                state is ModuleObjectsErrorState ||
                state is ModuleObjectAddedState ||
                state is ModuleObjectDeletedState ||
                state is ModuleObjectErrorAddingState ||
                state is ModuleObjectErrorDeletingState) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }

            ////Deleted State
            if (state is ModuleObjectDeletedState) {
              if (state.success) {
                successAlert(context, "Delete Successfull!",
                    "Module Object Deleted Successfully", () {
                  Navigator.of(context).pop();
                  context.read<ModuleObjectsBloc>().add(GetModuleObjects());
                });
              } else {
                errorAlert(
                    context, "Delete Failed", "Module Object Deletion Failed",
                    () {
                  Navigator.of(context).pop();
                  context.read<ModuleObjectsBloc>().add(GetModuleObjects());
                });
              }
            }
            ////Added State
            if (state is ModuleObjectAddedState) {
              if (state.response['success']) {
                successAlert(
                    context, "Adding Successfull!", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<ModuleObjectsBloc>().add(GetModuleObjects());
                });
              } else {
                errorAlert(context, "Adding Failed", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<ModuleObjectsBloc>().add(GetModuleObjects());
                });
              }
            }
          },
          builder: (context, state) {
            if (state is ModuleObjectLoadedState) {
              modules = state.modules;
              objects = state.objecs;
              moduleObjects = {};
              if (state.moduleObjects.isNotEmpty) {
                for (var modObjects in state.moduleObjects) {
                  if (!moduleObjects.keys
                      .contains(modObjects.module.name!.toLowerCase())) {
                    moduleObjects
                        .addAll({modObjects.module.name!.toLowerCase(): []});
                    moduleObjects[modObjects.module.name!.toLowerCase()]!.add(
                        Content(
                            id: modObjects.id, name: modObjects.object.name!));
                  } else {
                    moduleObjects[modObjects.module.name!.toLowerCase()]!.add(
                        Content(
                            id: modObjects.id, name: modObjects.object.name!));
                  }
                }
              }

              if (state.moduleObjects.isNotEmpty) {
                return GroupListView(
                  sectionsCount: moduleObjects.keys.toList().length,
                  countOfItemInSection: (int section) {
                    return moduleObjects.values.toList()[section].length;
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
                            context.read<ModuleObjectsBloc>().add(
                                DeleteRbacModuleObject(
                                    moduleObjectId: moduleObjects.values
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
                              moduleObjects.values
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
                      tileColor: Colors.white,
                      title: Text(
                        moduleObjects.keys.toList()[section].toUpperCase(),
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
                        "No Module Object available. Please click + to add.");
              }
            }
            if (state is ModuleObjectsErrorState) {
              return SomethingWentWrong(
                  message: state.message,
                  onpressed: () {
                    parent.read<ModuleObjectsBloc>().add(GetModuleObjects());
                  });
            }
            if (state is ModuleObjectErrorAddingState) {
              return SomethingWentWrong(
                  message: "Error adding module object. Please try again!",
                  onpressed: () {
                    context.read<ModuleObjectsBloc>().add(AddRbacModuleObjects(
                        assignerId: state.assignerId,
                        moduleId: state.moduleId,
                        objectsId: state.objectsId));
                  });
            }
            if (state is ModuleObjectErrorDeletingState) {
              return SomethingWentWrong(
                  message: "Error deleing mobule object. Please try again!",
                  onpressed: () {
                    context.read<ModuleObjectsBloc>().add(
                        DeleteRbacModuleObject(
                            moduleObjectId: state.moduleObjectId));
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
