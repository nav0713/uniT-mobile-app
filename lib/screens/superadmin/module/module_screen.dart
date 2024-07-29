import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:search_page/search_page.dart';
import 'package:unit2/bloc/rbac/rbac_operations/module/module_bloc.dart';
import 'package:unit2/model/rbac/rbac.dart';
import 'package:unit2/screens/superadmin/role/shared_pop_up_menu.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import '../../../theme-data.dart/box_shadow.dart';
import '../../../theme-data.dart/btn-style.dart';
import '../../../theme-data.dart/colors.dart';
import '../../../theme-data.dart/form-style.dart';
import '../../../utils/alerts.dart';
import '../../../utils/global.dart';
import '../../../widgets/empty_data.dart';

class RbacModuleScreen extends StatelessWidget {
  final int id;
  const RbacModuleScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    final bloc = BlocProvider.of<ModuleBloc>(context);
    List<RBAC> modules = [];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primary,
        title: const Text("Module Screen"),
        actions:
            context.watch<ModuleBloc>().state is ModuleLoadingState ||
                    context.watch<ModuleBloc>().state is ModuleErrorState ||
                    context.watch<ModuleBloc>().state is ModuleAddedState ||
                    context.watch<ModuleBloc>().state is ModuleDeletedState ||
                    context.watch<ModuleBloc>().state is ModuleAddedState ||
                    context.watch<ModuleBloc>().state is ModuleUpdatedState
                ? []
                : [
                    IconButton(
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: SearchPage(
                                barTheme: ThemeData(cardColor: Colors.white),
                                builder: (RBAC rbac) {
                                  return Column(
                                    children: [
                                      Container(
                                        width: screenWidth,
                                        decoration: box1(),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                              child: Text(rbac.name!,
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
                                                if (value == 2) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              "Update Module"),
                                                          content: FormBuilder(
                                                            key: formKey,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                FormBuilderTextField(
                                                                  initialValue:
                                                                      rbac.name,
                                                                  name:
                                                                      "object_name",
                                                                  decoration: normalTextFieldStyle(
                                                                      "Module name *",
                                                                      "Module name "),
                                                                  validator: FormBuilderValidators
                                                                      .required(
                                                                          errorText:
                                                                              "This field is required"),
                                                                ),
                                                                const SizedBox(
                                                                  height: 8,
                                                                ),
                                                                FormBuilderTextField(
                                                                  initialValue:
                                                                      rbac.slug,
                                                                  name: "slug",
                                                                  decoration:
                                                                      normalTextFieldStyle(
                                                                          "Slug ",
                                                                          "Slug"),
                                                                ),
                                                                const SizedBox(
                                                                  height: 8,
                                                                ),
                                                                FormBuilderTextField(
                                                                  initialValue:
                                                                      rbac.shorthand,
                                                                  validator: FormBuilderValidators
                                                                      .maxLength(
                                                                          50,
                                                                          errorText:
                                                                              "Max characters only 50"),
                                                                  name:
                                                                      "shorthand",
                                                                  decoration: normalTextFieldStyle(
                                                                      "Shorthand ",
                                                                      "Shorthand"),
                                                                ),
                                                                const SizedBox(
                                                                  height: 12,
                                                                ),
                                                                SizedBox(
                                                                    width: double
                                                                        .infinity,
                                                                    height: 50,
                                                                    child: ElevatedButton(
                                                                        style: mainBtnStyle(primary, Colors.transparent, second),
                                                                        onPressed: () {
                                                                          if (formKey
                                                                              .currentState!
                                                                              .saveAndValidate()) {
                                                                            Navigator.pop(context);
                                                                            String
                                                                                name =
                                                                                formKey.currentState!.value['object_name'];
                                                                            String?
                                                                                slug =
                                                                                formKey.currentState!.value['slug'];
                                                                            String?
                                                                                short =
                                                                                formKey.currentState!.value['shorthand'];

                                                                            ////Update
                                                                            bloc.add(UpdateRbacModule(
                                                                                moduleId: rbac.id!,
                                                                                name: name,
                                                                                slug: slug,
                                                                                short: short,
                                                                                createdBy: rbac.createdBy?.id,
                                                                                updatedBy: id));
                                                                            Navigator.pop(context);
                                                                          }
                                                                        },
                                                                        child: const Text("Update"))),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                }
                                                if (value == 1) {
                                                  ////delete
                                                  Navigator.pop(context);
                                                  confirmAlert(context, () {
                                                    context
                                                        .read<ModuleBloc>()
                                                        .add(DeleteRbacModule(
                                                            moduleId:
                                                                rbac.id!));
                                                  }, "Delete?",
                                                      "Confirm Delete?");
                                                }
                                              },
                                              menuItems: [
                                                popMenuItem(
                                                    text: "Update",
                                                    value: 2,
                                                    icon: Icons.edit),
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
                                filter: (RBAC rbac) {
                                  return [rbac.name];
                                },
                                failure: const Center(
                                  child: Text("No Module found :("),
                                ),
                                items: modules,
                                searchLabel: "Search Module",
                                suggestion: const Center(
                                  child: Text("Search module by name"),
                                )),
                          );
                        },
                        icon: const Icon(Icons.search)),
                    AddLeading(onPressed: () {
                      BuildContext parent = context;
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Add New Module"),
                              content: FormBuilder(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FormBuilderTextField(
                                      name: "object_name",
                                      decoration: normalTextFieldStyle(
                                          "Module name *", "Module name "),
                                      validator: FormBuilderValidators.required(
                                          errorText: "This field is required"),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    FormBuilderTextField(
                                      name: "slug",
                                      decoration:
                                          normalTextFieldStyle("Slug ", "Slug"),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    FormBuilderTextField(
                                      validator:
                                          FormBuilderValidators.maxLength(50,
                                              errorText:
                                                  "Max characters only 50"),
                                      name: "shorthand",
                                      decoration: normalTextFieldStyle(
                                          "Shorthand ", "Shorthand"),
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
                                                String name = formKey
                                                    .currentState!
                                                    .value['object_name'];
                                                String? slug = formKey
                                                    .currentState!
                                                    .value['slug'];
                                                String? short = formKey
                                                    .currentState!
                                                    .value['shorthand'];
                                                parent.read<ModuleBloc>().add(
                                                    AddRbacModule(
                                                        id: id,
                                                        name: name,
                                                        shorthand: short,
                                                        slug: slug));
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

        child: BlocConsumer<ModuleBloc, ModuleState>(
          listener: (context, state) {
            if (state is ModuleLoadingState) {
              final progress = ProgressHUD.of(context);
              progress!.showWithText("Please wait...");
            }
            if (state is ModuleLoaded ||
                state is ModuleErrorState ||
                state is ModuleAddedState ||
                state is ModuleDeletedState ||
                state is ModuleUpdatedState ||
                state is ModuleErrorAddingState ||
                state is ModuleErrorUpdatingState ||
                state is ModuleErrorDeletingState) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }
            ////Added State
            if (state is ModuleAddedState) {
              if (state.response['success']) {
                successAlert(
                    context, "Adding Successfull!", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<ModuleBloc>().add(GetModule());
                });
              } else {
                errorAlert(context, "Adding Failed", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<ModuleBloc>().add(GetModule());
                });
              }
            }
            ////Updated state
            if (state is ModuleUpdatedState) {
              if (state.response['success']) {
                successAlert(
                    context, "Updated Successfull!", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<ModuleBloc>().add(GetModule());
                });
              } else {
                errorAlert(context, "Update Failed", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<ModuleBloc>().add(GetModule());
                });
              }
            }
            ////Deleted State
            if (state is ModuleDeletedState) {
              if (state.success) {
                successAlert(context, "Delete Successfull!",
                    "Module Deleted Successfully", () {
                  Navigator.of(context).pop();
                  context.read<ModuleBloc>().add(GetModule());
                });
              } else {
                errorAlert(context, "Delete Failed", "Module Deletion Failed",
                    () {
                  Navigator.of(context).pop();
                  context.read<ModuleBloc>().add(GetModule());
                });
              }
            }
          },
          builder: (context, state) {
            final parent = context;
            if (state is ModuleLoaded) {
              if (state.module.isNotEmpty) {
                modules = state.module;
                return ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    itemCount: state.module.length,
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
                                    Text(state.module[index].name!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: primary)),
                                  ],
                                )),
                                AppPopupMenu<int>(
                                  offset: const Offset(-10, -10),
                                  elevation: 3,
                                  onSelected: (value) {
                                    if (value == 2) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text("Update Module"),
                                              content: FormBuilder(
                                                key: formKey,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    FormBuilderTextField(
                                                      initialValue: state
                                                          .module[index].name,
                                                      name: "object_name",
                                                      decoration:
                                                          normalTextFieldStyle(
                                                              "Module name *",
                                                              "Module name "),
                                                      validator:
                                                          FormBuilderValidators
                                                              .required(
                                                                  errorText:
                                                                      "This field is required"),
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    FormBuilderTextField(
                                                      initialValue: state
                                                          .module[index].slug,
                                                      name: "slug",
                                                      decoration:
                                                          normalTextFieldStyle(
                                                              "Slug ", "Slug"),
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    FormBuilderTextField(
                                                      initialValue: state
                                                          .module[index]
                                                          .shorthand,
                                                      validator:
                                                          FormBuilderValidators
                                                              .maxLength(50,
                                                                  errorText:
                                                                      "Max characters only 50"),
                                                      name: "shorthand",
                                                      decoration:
                                                          normalTextFieldStyle(
                                                              "Shorthand ",
                                                              "Shorthand"),
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                    SizedBox(
                                                        width: double.infinity,
                                                        height: 50,
                                                        child: ElevatedButton(
                                                            style: mainBtnStyle(
                                                                primary,
                                                                Colors
                                                                    .transparent,
                                                                second),
                                                            onPressed: () {
                                                              if (formKey
                                                                  .currentState!
                                                                  .saveAndValidate()) {
                                                                String name = formKey
                                                                        .currentState!
                                                                        .value[
                                                                    'object_name'];
                                                                String? slug = formKey
                                                                    .currentState!
                                                                    .value['slug'];
                                                                String? short = formKey
                                                                        .currentState!
                                                                        .value[
                                                                    'shorthand'];

                                                                ////Update
                                                                parent.read<ModuleBloc>().add(UpdateRbacModule(
                                                                    moduleId: state
                                                                        .module[
                                                                            index]
                                                                        .id!,
                                                                    name: name,
                                                                    slug: slug,
                                                                    short:
                                                                        short,
                                                                    createdBy: state
                                                                        .module[
                                                                            index]
                                                                        .createdBy
                                                                        ?.id,
                                                                    updatedBy:
                                                                        id));
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            },
                                                            child: const Text(
                                                                "Update"))),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                    if (value == 1) {
                                      ////delete
                                      confirmAlert(context, () {
                                        context.read<ModuleBloc>().add(
                                            DeleteRbacModule(
                                                moduleId:
                                                    state.module[index].id!));
                                      }, "Delete?", "Confirm Delete?");
                                    }
                                  },
                                  menuItems: [
                                    popMenuItem(
                                        text: "Update",
                                        value: 2,
                                        icon: Icons.edit),
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
                    message: "No Module available. Please click + to add.");
              }
            }
            if (state is ModuleErrorState) {
              return SomethingWentWrong(
                  message: state.message,
                  onpressed: () {
                    context.read<ModuleBloc>().add(GetModule());
                  });
            }
            if (state is ModuleErrorAddingState) {
              return SomethingWentWrong(
                  message: "Error adding module. Please try again!",
                  onpressed: () {
                    context.read<ModuleBloc>().add(AddRbacModule(
                        id: state.id,
                        name: state.name,
                        shorthand: state.shorthand,
                        slug: state.slug));
                  });
            }
            if (state is ModuleErrorUpdatingState) {
              return SomethingWentWrong(
                  message: "Error updating module. Please try again!",
                  onpressed: () {
                    context.read<ModuleBloc>().add(UpdateRbacModule(
                        moduleId: state.moduleId,
                        createdBy: state.createdBy,
                        name: state.name,
                        short: state.short,
                        slug: state.slug,
                        updatedBy: state.updatedBy));
                  });
            }
            if (state is ModuleErrorDeletingState) {
              return SomethingWentWrong(
                  message: "Error deleting module. Please try again!",
                  onpressed: () {
                    context
                        .read<ModuleBloc>()
                        .add(DeleteRbacModule(moduleId: state.moduleId));
                  });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
