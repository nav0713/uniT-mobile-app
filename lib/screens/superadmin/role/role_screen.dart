import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:search_page/search_page.dart';
import 'package:unit2/bloc/rbac/rbac_operations/role/role_bloc.dart';
import 'package:unit2/screens/superadmin/role/shared_pop_up_menu.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import '../../../model/rbac/rbac.dart';
import '../../../theme-data.dart/box_shadow.dart';
import '../../../theme-data.dart/btn-style.dart';
import '../../../theme-data.dart/colors.dart';
import '../../../theme-data.dart/form-style.dart';
import '../../../utils/alerts.dart';
import '../../../utils/global.dart';
import '../../../widgets/empty_data.dart';

class RbacRoleScreen extends StatelessWidget {
  final int id;
  const RbacRoleScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<RoleBloc>(context);
    final formKey = GlobalKey<FormBuilderState>();
    List<RBAC> roles = [];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primary,
        title: const Text("Role Screen"),
        actions:
            context.watch<RoleBloc>().state is RoleLoadingState ||
                    context.watch<RoleBloc>().state is RoleErrorState ||
                    context.watch<RoleBloc>().state is RoleDeletedState? ||
                    context.watch<RoleBloc>().state is RoleAddedState? ||
                    context.watch<RoleBloc>().state is RoleUpdatedState
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
                                                child: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(rbac.name!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: primary)),
                                                ),
                                              ],
                                            )),
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
                                                              "Update Role"),
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
                                                                      "Role name *",
                                                                      "Role name "),
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

                                                                            bloc.add(UpdateRbacRole(
                                                                                roleId: rbac.id!,
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
                                                    bloc.add(DeleteRbacRole(
                                                        roleId: rbac.id!));
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
                                items: roles,
                                searchLabel: "Search Role",
                                suggestion: const Center(
                                  child: Text("Search role by name"),
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
                              title: const Text("Add New Role"),
                              content: FormBuilder(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FormBuilderTextField(
                                      name: "object_name",
                                      decoration: normalTextFieldStyle(
                                          "Role name *", "Role name "),
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
                                                parent.read<RoleBloc>().add(
                                                    AddRbacRole(
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

        child: BlocConsumer<RoleBloc, RoleState>(
          listener: (context, state) {
            if (state is RoleLoadingState) {
              final progress = ProgressHUD.of(context);
              progress!.showWithText("Please wait...");
            }
            if (state is RoleLoadedState ||
                state is RoleErrorState ||
                state is RoleAddedState ||
                state is RoleDeletedState ||
                state is RoleUpdatedState ||
                state is RoleAddingErrorState ||
                state is RoleUpdatingErrorState ||
                state is RoleDeletingErrorState) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }
            ////Added State
            if (state is RoleAddedState) {
              if (state.response['success']) {
                successAlert(
                    context, "Adding Successfull!", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<RoleBloc>().add(GetRoles());
                });
              } else {
                errorAlert(context, "Adding Failed", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<RoleBloc>().add(GetRoles());
                });
              }
            }
            ////Updated state
            if (state is RoleUpdatedState) {
              if (state.response['success']) {
                successAlert(
                    context, "Updated Successfull!", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<RoleBloc>().add(GetRoles());
                });
              } else {
                errorAlert(context, "Update Failed", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<RoleBloc>().add(GetRoles());
                });
              }
            }
            ////Deleted State
            if (state is RoleDeletedState) {
              if (state.success) {
                successAlert(
                    context, "Delete Successfull!", "Role Deleted Successfully",
                    () {
                  Navigator.of(context).pop();
                  context.read<RoleBloc>().add(GetRoles());
                });
              } else {
                errorAlert(context, "Delete Failed", "Role Delete Failed", () {
                  Navigator.of(context).pop();
                  context.read<RoleBloc>().add(GetRoles());
                });
              }
            }
          },
          builder: (context, state) {
            final parent = context;
            if (state is RoleLoadedState) {
              if (state.roles.isNotEmpty) {
                roles = state.roles;
                return ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    itemCount: state.roles.length,
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
                                      child: Text(state.roles[index].name!,
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
                                    if (value == 2) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Update Role"),
                                              content: FormBuilder(
                                                key: formKey,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    FormBuilderTextField(
                                                      initialValue: state
                                                          .roles[index].name,
                                                      name: "object_name",
                                                      decoration:
                                                          normalTextFieldStyle(
                                                              "Role name *",
                                                              "Role name "),
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
                                                          .roles[index].slug,
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
                                                          .roles[index]
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

                                                                parent.read<RoleBloc>().add(UpdateRbacRole(
                                                                    roleId: state
                                                                        .roles[
                                                                            index]
                                                                        .id!,
                                                                    name: name,
                                                                    slug: slug,
                                                                    short:
                                                                        short,
                                                                    createdBy: state
                                                                        .roles[
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
                                        context.read<RoleBloc>().add(
                                            DeleteRbacRole(
                                                roleId:
                                                    state.roles[index].id!));
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
                    message: "No Role available. Please click + to add.");
              }
            }
            if (state is RoleErrorState) {
              return SomethingWentWrong(
                  message: state.message,
                  onpressed: () {
                    context.read<RoleBloc>().add(GetRoles());
                  });
            }
            if (state is RoleAddingErrorState) {
              return SomethingWentWrong(
                  message: "Error adding role. Please try again!",
                  onpressed: () {
                    context.read<RoleBloc>().add(AddRbacRole(
                        id: state.id,
                        name: state.name,
                        shorthand: state.shorthand,
                        slug: state.slug));
                  });
            }
            if (state is RoleUpdatingErrorState) {
              return SomethingWentWrong(
                  message: "Error updating role. Please try again!",
                  onpressed: () {
                    context.read<RoleBloc>().add(UpdateRbacRole(
                        roleId: state.roleId,
                        createdBy: state.createdBy,
                        name: state.name,
                        short: state.short,
                        slug: state.slug,
                        updatedBy: state.updatedBy));
                  });
            }
            if (state is RoleDeletingErrorState) {
              return SomethingWentWrong(
                  message: "Error deleting role. Please try again!",
                  onpressed: () {
                    context
                        .read<RoleBloc>()
                        .add(DeleteRbacRole(roleId: state.roleId));
                  });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
