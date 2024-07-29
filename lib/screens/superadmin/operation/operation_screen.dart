import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:search_page/search_page.dart';
import 'package:unit2/bloc/rbac/rbac_operations/operation/operation_bloc.dart';
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

class RbacOperationScreen extends StatelessWidget {
  final int id;
  const RbacOperationScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    final bloc = BlocProvider.of<OperationBloc>(context);
    List<RBAC> operations = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text("Operations Screen"),
        centerTitle: true,
        actions: context.watch<OperationBloc>().state
                    is OperationLoadingState ||
                context.watch<OperationBloc>().state is OperationErrorState ||
                context.watch<OperationBloc>().state is OperationAddedState ||
                context.watch<OperationBloc>().state is OperationDeletedState ||
                context.watch<OperationBloc>().state is OperationUpdatedState
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
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          "Update Operation"),
                                                      content: FormBuilder(
                                                        key: formKey,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            FormBuilderTextField(
                                                              initialValue:
                                                                  rbac.name,
                                                              name:
                                                                  "object_name",
                                                              decoration: normalTextFieldStyle(
                                                                  "Operation name *",
                                                                  "Operation name "),
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
                                                              initialValue: rbac
                                                                  .shorthand,
                                                              validator: FormBuilderValidators
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
                                                                width: double
                                                                    .infinity,
                                                                height: 50,
                                                                child:
                                                                    ElevatedButton(
                                                                        style: mainBtnStyle(
                                                                            primary,
                                                                            Colors
                                                                                .transparent,
                                                                            second),
                                                                        onPressed:
                                                                            () {
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

                                                                            bloc.add(UpdateRbacOperation(
                                                                                operationId: rbac.id!,
                                                                                name: name,
                                                                                slug: slug,
                                                                                short: short,
                                                                                createdBy: rbac.createdBy?.id,
                                                                                updatedBy: id));
                                                                            Navigator.pop(context);
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
                                                Navigator.pop(context);
                                                context
                                                    .read<OperationBloc>()
                                                    .add(DeleteRbacOperation(
                                                        operationId: rbac.id!));
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
                            },
                            filter: (RBAC rbac) {
                              return [rbac.name];
                            },
                            failure: const Center(
                              child: Text("No Operation found :("),
                            ),
                            items: operations,
                            searchLabel: "Search Operation",
                            suggestion: const Center(
                              child: Text("Search operation by name"),
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
                          title: const Text("Add New Operation"),
                          content: FormBuilder(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FormBuilderTextField(
                                  name: "object_name",
                                  decoration: normalTextFieldStyle(
                                      "Operation name *", "Operation name "),
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
                                  validator: FormBuilderValidators.maxLength(50,
                                      errorText: "Max characters only 50"),
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
                                            String name = formKey.currentState!
                                                .value['object_name'];
                                            String? slug = formKey
                                                .currentState!.value['slug'];
                                            String? short = formKey
                                                .currentState!
                                                .value['shorthand'];
                                            parent.read<OperationBloc>().add(
                                                AddRbacOperation(
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

        child: BlocConsumer<OperationBloc, OperationState>(
          listener: (context, state) {
            if (state is OperationLoadingState) {
              final progress = ProgressHUD.of(context);
              progress!.showWithText("Please wait...");
            }
            if (state is OperationsLoaded ||
                state is OperationErrorState ||
                state is OperationAddedState ||
                state is OperationUpdatedState ||
                state is OperationDeletedState ||
                state is OperationErrorAddingState ||
                state is OperationErrorUpdatingState ||
                state is OperationErrorDeletingState) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }
            ////Added State
            if (state is OperationAddedState) {
              if (state.response['success']) {
                successAlert(
                    context, "Adding Successfull!", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<OperationBloc>().add(GetOperations());
                });
              } else {
                errorAlert(context, "Adding Failed", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<OperationBloc>().add(GetOperations());
                });
              }
            }
            ////Updated state
            if (state is OperationUpdatedState) {
              if (state.response['success']) {
                successAlert(
                    context, "Updated Successfull!", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<OperationBloc>().add(GetOperations());
                });
              } else {
                errorAlert(context, "Update Failed", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<OperationBloc>().add(GetOperations());
                });
              }
            }
            ////Deleted State
            if (state is OperationDeletedState) {
              if (state.success) {
                successAlert(context, "Delete Successfull!",
                    "Operation Deleted Successfully", () {
                  Navigator.of(context).pop();
                  context.read<OperationBloc>().add(GetOperations());
                });
              } else {
                errorAlert(
                    context, "Delete Failed", "Operation Deletion Failed", () {
                  Navigator.of(context).pop();
                  context.read<OperationBloc>().add(GetOperations());
                });
              }
            }
          },
          builder: (context, state) {
            final parent = context;
            if (state is OperationsLoaded) {
              if (state.operations.isNotEmpty) {
                operations = state.operations;
                return ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    itemCount: state.operations.length,
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
                                    Text(state.operations[index].name!,
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
                                              title: const Text(
                                                  "Update Operation"),
                                              content: FormBuilder(
                                                key: formKey,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    FormBuilderTextField(
                                                      initialValue: state
                                                          .operations[index]
                                                          .name,
                                                      name: "object_name",
                                                      decoration:
                                                          normalTextFieldStyle(
                                                              "Operation name *",
                                                              "Operation name "),
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
                                                          .operations[index]
                                                          .slug,
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
                                                          .operations[index]
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

                                                                parent.read<OperationBloc>().add(UpdateRbacOperation(
                                                                    operationId: state
                                                                        .operations[
                                                                            index]
                                                                        .id!,
                                                                    name: name,
                                                                    slug: slug,
                                                                    short:
                                                                        short,
                                                                    createdBy: state
                                                                        .operations[
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
                                        context.read<OperationBloc>().add(
                                            DeleteRbacOperation(
                                                operationId: state
                                                    .operations[index].id!));
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
                    message: "No Operation available. Please click + to add.");
              }
            }
            if (state is OperationErrorState) {
              return SomethingWentWrong(
                  message: state.message.toString(),
                  onpressed: () {
                    context.read<OperationBloc>().add(GetOperations());
                  });
            }
            if (state is OperationErrorAddingState) {
              return SomethingWentWrong(
                  message: "Error adding operation. Please try again!",
                  onpressed: () {
                    context.read<OperationBloc>().add(AddRbacOperation(
                        id: state.id,
                        name: state.name,
                        shorthand: state.shorthand,
                        slug: state.slug));
                  });
            }
            if (state is OperationErrorUpdatingState) {
              return SomethingWentWrong(
                  message: "Error updating operation. Please try again!",
                  onpressed: () {
                    context.read<OperationBloc>().add(UpdateRbacOperation(
                        operationId: state.operationId,
                        name: state.name,
                        createdBy: state.createdBy,
                        short: state.short,
                        updatedBy: state.updatedBy,
                        slug: state.slug));
                  });
            }
            if (state is OperationErrorDeletingState) {
              return SomethingWentWrong(
                  message: "Error deleting operation. Please try again!",
                  onpressed: () {
                    context.read<OperationBloc>().add(
                        DeleteRbacOperation(operationId: state.operationId));
                  });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
