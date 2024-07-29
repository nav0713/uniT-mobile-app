import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:search_page/search_page.dart';
import 'package:unit2/bloc/rbac/rbac_operations/object/object_bloc.dart';
import 'package:unit2/model/rbac/rbac.dart';
import 'package:unit2/screens/superadmin/role/shared_pop_up_menu.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import '../../../theme-data.dart/box_shadow.dart';
import '../../../theme-data.dart/btn-style.dart';
import '../../../theme-data.dart/colors.dart';
import '../../../theme-data.dart/form-style.dart';
import '../../../utils/alerts.dart';
import '../../../utils/global.dart';
import '../../../widgets/Leadings/add_leading.dart';
import '../../../widgets/empty_data.dart';

class RbacObjectScreen extends StatelessWidget {
  final int id;
  const RbacObjectScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    final bloc = BlocProvider.of<ObjectBloc>(context);
    List<RBAC> objects = [];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primary,
        title: const Text("Objects Screen"),
        actions:
            context.watch<ObjectBloc>().state is ObjectLoadingState ||
                    context.watch<ObjectBloc>().state is ObjectAddedState ||
                    context.watch<ObjectBloc>().state is ObjectErrorState ||
                    context.watch<ObjectBloc>().state is ObjectDeletedState ||
                    context.watch<ObjectBloc>().state is ObjectUpdatedState
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
                                                              "Update Object"),
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
                                                                      "Object name *",
                                                                      "Object name "),
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

                                                                            bloc.add(UpdateRbacObject(
                                                                                objectId: rbac.id!,
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
                                                  confirmAlert(context, () {
                                                    Navigator.pop(context);
                                                    bloc.add(DeleteRbacObject(
                                                        objectId: rbac.id!));
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
                                  child: Text("No Role found :("),
                                ),
                                items: objects,
                                searchLabel: "Search Object",
                                suggestion: const Center(
                                  child: Text("Search object by name"),
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
                              title: const Text("Add New Object"),
                              content: FormBuilder(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FormBuilderTextField(
                                      name: "object_name",
                                      decoration: normalTextFieldStyle(
                                          "Object name *", "Object name "),
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
                                                parent.read<ObjectBloc>().add(
                                                    AddRbacObject(
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

        child: BlocConsumer<ObjectBloc, ObjectState>(
          listener: (context, state) {
            if (state is ObjectLoadingState) {
              final progress = ProgressHUD.of(context);
              progress!.showWithText("Please wait...");
            }
            if (state is ObjectLoaded ||
                state is ObjectAddedState ||
                state is ObjectErrorState ||
                state is ObjectUpdatedState ||
                state is ObjectAddingErrorState ||
                state is ObjectUpdatingErrorState ||
                state is ObjectDeletingErrorState) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }
            ////Added State
            if (state is ObjectAddedState) {
              if (state.response['success']) {
                successAlert(
                    context, "Adding Successfull!", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<ObjectBloc>().add(GetObjects());
                });
              } else {
                errorAlert(context, "Adding Failed", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<ObjectBloc>().add(GetObjects());
                });
              }
            }
            ////Updated state
            if (state is ObjectUpdatedState) {
              if (state.response['success']) {
                successAlert(
                    context, "Updated Successfull!", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<ObjectBloc>().add(GetObjects());
                });
              } else {
                errorAlert(context, "Update Failed", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<ObjectBloc>().add(GetObjects());
                });
              }
            }
            ////Deleted State
            if (state is ObjectDeletedState) {
              if (state.success) {
                successAlert(context, "Delete Successfull!",
                    "Object Deleted Successfully", () {
                  Navigator.of(context).pop();
                  context.read<ObjectBloc>().add(GetObjects());
                });
              } else {
                errorAlert(context, "Delete Failed", "Object Deletion Failed",
                    () {
                  Navigator.of(context).pop();
                  context.read<ObjectBloc>().add(GetObjects());
                });
              }
            }
          },
          builder: (context, state) {
            final parent = context;
            if (state is ObjectLoaded) {
              if (state.objects.isNotEmpty) {
                objects = state.objects;
                return ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    itemCount: state.objects.length,
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
                                    Text(state.objects[index].name!,
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
                                                  const Text("Update Object"),
                                              content: FormBuilder(
                                                key: formKey,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    FormBuilderTextField(
                                                      initialValue: state
                                                          .objects[index].name,
                                                      name: "object_name",
                                                      decoration:
                                                          normalTextFieldStyle(
                                                              "Object name *",
                                                              "Object name "),
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
                                                          .objects[index].slug,
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
                                                          .objects[index]
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

                                                                parent.read<ObjectBloc>().add(UpdateRbacObject(
                                                                    objectId: state
                                                                        .objects[
                                                                            index]
                                                                        .id!,
                                                                    name: name,
                                                                    slug: slug,
                                                                    short:
                                                                        short,
                                                                    createdBy: state
                                                                        .objects[
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
                                      confirmAlert(context, () {
                                        context.read<ObjectBloc>().add(
                                            DeleteRbacObject(
                                                objectId:
                                                    state.objects[index].id!));
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
                    message: "No Object available. Please click + to add.");
              }
            }
            if (state is ObjectErrorState) {
              return SomethingWentWrong(
                  message: state.message,
                  onpressed: () {
                    context.read<ObjectBloc>().add(GetObjects());
                  });
            }
            if (state is ObjectAddingErrorState) {
              return SomethingWentWrong(
                  message: "Error adding object. Please try again!",
                  onpressed: () {
                    context.read<ObjectBloc>().add(AddRbacObject(
                        id: state.id,
                        name: state.name,
                        shorthand: state.shorthand,
                        slug: state.slug));
                  });
            }
            if (state is ObjectUpdatingErrorState) {
              return SomethingWentWrong(
                  message: "Error updating object. Please try again!",
                  onpressed: () {
                    context.read<ObjectBloc>().add(UpdateRbacObject(
                        objectId: state.objectId,
                        createdBy: state.createdBy,
                        name: state.name,
                        short: state.short,
                        slug: state.slug,
                        updatedBy: state.updatedBy));
                  });
            }
            if (state is ObjectDeletingErrorState) {
              return SomethingWentWrong(
                  message: "Error deleting object. Please try again!",
                  onpressed: () {
                    context
                        .read<ObjectBloc>()
                        .add(DeleteRbacObject(objectId: state.objectId));
                  });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
