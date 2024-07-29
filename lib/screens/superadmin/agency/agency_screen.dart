import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:search_page/search_page.dart';
import 'package:searchfield/searchfield.dart';
import 'package:unit2/bloc/rbac/rbac_operations/agency/agency_bloc.dart';
import 'package:unit2/bloc/rbac/rbac_operations/object/object_bloc.dart';
import 'package:unit2/model/utils/agency.dart';
import 'package:unit2/model/utils/category.dart';
import 'package:unit2/utils/formatters.dart';
import 'package:unit2/utils/global_context.dart';
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

class RbacAgencyScreen extends StatelessWidget {
  const RbacAgencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    List<Agency> agencies = [];
    List<Category> agencyCategory = [];
    Category? selectedAgencyCategory;
    bool? isPrivate;
    final agencyCategoryFocusNode = FocusNode();
    BuildContext parent;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primary,
        title: const Text("Agencies"),
        actions: context.watch<AgencyBloc>().state is AgencyLoadingState || context.watch<AgencyBloc>().state is AgencyErrorState || context.watch<AgencyBloc>().state is AgencyAddesState?[]:[
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchPage(
                      barTheme: ThemeData(cardColor: primary),
                      builder: (Agency rbac) {
                        return Column(
                          children: [
                          ListTile(
                                title: Text(rbac.name!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: primary)),
                                            subtitle: rbac.privateEntity!?const Text("Private agency"): const Text("Government agency"),
                              ),
                            const Divider(),
                          ],
                        );
                      },
                      filter: (Agency rbac) {
                        return [rbac.name];
                      },
                      failure: const Center(
                        child: Text("No Agency found :("),
                      ),
                      items: agencies,
                      searchLabel: "Search Agency",
                      suggestion: const Center(
                        child: Text("Search agency by name"),
                      )),
                );
              },
              icon: const Icon(Icons.search)),
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
                              inputFormatters: [UpperCaseTextFormatter()],
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
                                      Navigator.pop(context);
                                      parent.read<AgencyBloc>().add(AddAgency(
                                          agency: Agency(
                                              category: selectedAgencyCategory,
                                              id: null,
                                              name: name,
                                              privateEntity: isPrivate)));
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
        child: BlocConsumer<AgencyBloc, AgencyState>(
          listener: (context, state) {
            if (state is AgencyLoadingState) {
              final progress = ProgressHUD.of(context);
              progress!.showWithText("Please wait...");
            }
            if (state is AgenciesLoaded ||
                state is AgencyAddesState ||
                state is AgencyErrorState || state is AgencyAddingErrorState) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }

            ////Deleted State
            if (state is AgencyDeletedState) {
              if (state.success) {
                successAlert(context, "Delete Successfull!",
                    "Agency Deleted Successfully", () {
                  Navigator.of(context).pop();
                  context.read<AgencyBloc>().add(GetAgencies());
                });
              } else {
                errorAlert(context, "Delete Failed", "Object Delete Failed",
                    () {
                  Navigator.of(context).pop();
                  context.read<ObjectBloc>().add(GetObjects());
                });
              }
            }
            ////ADDED STATE
            if (state is AgencyAddesState) {
              if (state.response['success']) {
                successAlert(
                    context, "Adding Successfull!", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<AgencyBloc>().add(GetAgencies());
                });
              } else {
                errorAlert(context, "Adding Failed",
                    "Something went wrong. Please try again.", () {
                  Navigator.of(context).pop();
                  context.read<AgencyBloc>().add(GetAgencies());
                });
              }
            }
          },
          builder: (context, state) {
            final parent = context;
            if (state is AgenciesLoaded) {
              agencies = state.agencies;
              agencyCategory = state.agencyCategory;
              if (state.agencies.isNotEmpty) {
                return ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    itemCount: state.agencies.length,
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
                            CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Flexible(
                              child: AnimationConfiguration.staggeredList(
                                position: index,

                                child: FlipAnimation(
                                  duration: const Duration(milliseconds: 250),
                                  child: ListTile(
                                    title: Text(state.agencies[index].name!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: primary)),
                                                subtitle: state.agencies[index].privateEntity!?const Text("Private agency"): const Text("Government agency"),
                                  ),
                                ),
                              ),
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
                    message: "No Agency available. Please click + to add.");
              }
            }if (state is AgencyErrorState) {
              return SomethingWentWrong(
                  message: state.message,
                  onpressed: () {
                    parent.read<AgencyBloc>().add(GetAgencies());
                  });
            }if(state is AgencyAddingErrorState){
              return SomethingWentWrong(message: "Error adding Agency. Please try again! ", onpressed: (){
                context.read<AgencyBloc>().add(AddAgency(agency: state.agency));
              });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
