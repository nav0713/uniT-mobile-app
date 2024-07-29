import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:searchfield/searchfield.dart';
import 'package:unit2/bloc/rbac/rbac_operations/object/object_bloc.dart';
import 'package:unit2/bloc/role/pass_check/est_point_person/assign_area/assign_area_agency_bloc.dart';
import 'package:unit2/model/utils/category.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import '../../../../model/utils/agency.dart';
import '../../../../theme-data.dart/box_shadow.dart';
import '../../../../theme-data.dart/btn-style.dart';
import '../../../../theme-data.dart/colors.dart';
import '../../../../theme-data.dart/form-style.dart';
import '../../../../utils/global.dart';
import '../../../../utils/global_context.dart';
import '../../../../widgets/Leadings/add_leading.dart';
import '../../../../widgets/empty_data.dart';

class EstPorintPersonAgencyScreen extends StatelessWidget {
  const EstPorintPersonAgencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    List<Category> agencyCategory = [];
    Category? selectedAgencyCategory;
    bool? isPrivate;
    final agencyCategoryFocusNode = FocusNode();
    BuildContext parent;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text("Agencies"),
        actions: [
          AddLeading(onPressed: () {
            parent = context;
            showDialog(
                context: NavigationService.navigatorKey.currentContext!,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Add Agency"),
                    content: FormBuilder(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FormBuilderTextField(
                              validator: FormBuilderValidators.required(
                                  errorText: "This field is required"),
                              name: "name",
                              decoration: normalTextFieldStyle(
                                  "Agency name ", "Agency name"),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            SearchField(
                              focusNode: agencyCategoryFocusNode,
                              itemHeight: 80,
                              suggestions: agencyCategory
                                  .map((Category category) =>
                                      SearchFieldListItem(category.name!,
                                          item: category,
                                          child: ListTile(
                                            title: Text(category.name!),
                                            subtitle: Text(
                                                category.industryClass!.name!),
                                          )))
                                  .toList(),
                              emptyWidget: Container(
                                height: 100,
                                decoration: box1(),
                                child: const Center(
                                    child: Text("No result found ...")),
                              ),
                              onSuggestionTap: (agencyCategory) {
                                selectedAgencyCategory = agencyCategory.item;
                                agencyCategoryFocusNode.unfocus();
                              },
                              searchInputDecoration:
                                  normalTextFieldStyle("Category *", "")
                                      .copyWith(
                                          suffixIcon: IconButton(
                                icon: const Icon(Icons.arrow_drop_down),
                                onPressed: () {
                                  agencyCategoryFocusNode.unfocus();
                                },
                              )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This field is required";
                                }
                                return null;
                              },
                            ),
                            FormBuilderRadioGroup(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                label: Row(
                                  children: [
                                    Text(
                                      "Is this private sector? ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(fontSize: 24),
                                    ),
                                    const Icon(FontAwesome.help_circled)
                                  ],
                                ),
                              ),

                              ////onvhange private sector
                              onChanged: (value) {
                                if (value.toString() == "YES") {
                                  isPrivate = true;
                                } else {
                                  isPrivate = false;
                                }
                              },

                              name: 'isPrivate',
                              validator: FormBuilderValidators.required(),
                              options: ["YES", "NO"]
                                  .map((lang) =>
                                      FormBuilderFieldOption(value: lang))
                                  .toList(growable: false),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              height: 50,
                              width: double.maxFinite,
                              child: ElevatedButton(
                                  style: mainBtnStyle(
                                      primary, Colors.transparent, second),
                                  onPressed: () {
                                    if (formKey.currentState!
                                        .saveAndValidate()) {
                                      String name =
                                          formKey.currentState!.value['name'];
                                      parent.read<AssignAreaAgencyBloc>().add(
                                          EstPointPersonAddAgency(
                                              agency: Agency(
                                                  category:
                                                      selectedAgencyCategory,
                                                  id: null,
                                                  name: name,
                                                  privateEntity: isPrivate)));
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text("Add")),
                            )
                          ],
                        )),
                  );
                });
          })
        ],
      ),
      body: LoadingProgress(

        child: BlocConsumer<AssignAreaAgencyBloc, AssignAreaAgencyState>(
          listener: (context, state) {
            if (state is EstPointPersonAgencyLoadingState) {
              final progress = ProgressHUD.of(context);
              progress!.showWithText("Please wait...");
            }
            if (state is EstPointPersonAgenciesLoaded ||
                state is EstPointPersonAgencyAddesState ||
                state is EstPointAgencyErrorState) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }
          },
          builder: (context, state) {
            final parent = context;
            if (state is EstPointPersonAgenciesLoaded) {
              agencyCategory = state.agencyCategory;
              if (state.agencies != null && state.agencies!.isNotEmpty) {
                return ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    itemCount: state.agencies!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            width: screenWidth,
                            decoration: box1(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Expanded(
                                child: Row(
                              children: [
                                CircleAvatar(
                                  child: Text('${index + 1}'),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Flexible(
                                  child: Text(state.agencies![index].areaName!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: primary)),
                                ),
                              ],
                            )),
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
            if (state is EstPointAgencyErrorState) {
              return SomethingWentWrong(
                  message: state.message,
                  onpressed: () {
                    context.read<ObjectBloc>().add(GetObjects());
                  });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
