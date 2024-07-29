import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:searchfield/searchfield.dart';
import 'package:unit2/bloc/profile/other_information/org_membership/organization_membership_bloc.dart';
import 'package:unit2/model/utils/agency.dart';
import 'package:unit2/screens/profile/shared/add_for_empty_search.dart';
import 'package:unit2/utils/profile_utilities.dart';
import 'package:unit2/utils/text_container.dart';
import '../../../../../model/utils/category.dart';
import '../../../../../theme-data.dart/box_shadow.dart';
import '../../../../../theme-data.dart/btn-style.dart';
import '../../../../../theme-data.dart/colors.dart';
import '../../../../../theme-data.dart/form-style.dart';
import '../../../../../utils/formatters.dart';

class AddOrgMemberShipScreen extends StatefulWidget {
  final int profileId;
  final String token;
  final List<Agency> agencies;
  final List<Category> agencyCategories;
  final Bloc bloc;
  const AddOrgMemberShipScreen(
      {super.key, required this.profileId, required this.token, required this.agencies, required this.agencyCategories, required this.bloc});

  @override
  State<AddOrgMemberShipScreen> createState() => _AddOrgMemberShipScreenState();
}

bool showAgencyCategory = false;
final agencyFocusNode = FocusNode();
bool showAgencySearchField = true;
final agencyCategoryFocusNode = FocusNode();
final addAgencyController = TextEditingController();
Agency? selectedAgency;
Category? selectedCategory;
Agency? newAgency;
bool showIsPrivateRadio = false;
bool? isPrivate = false;
final _formKey = GlobalKey<FormBuilderState>();

class _AddOrgMemberShipScreenState extends State<AddOrgMemberShipScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
                    key: _formKey,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical:24, horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          
                            StatefulBuilder(builder: (context, setState) {
                              //// AGENCY SEARCHFIELD
                              return Column(
                                children: [
                           SizedBox(
                          child: showAgencySearchField
                              ? SearchableDropdown.paginated(
                                  backgroundDecoration: (child) {
                                    return Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: child,
                                      ),
                                    );
                                  },
                                  hintText: const Text("Search Organization"),
                                  changeCompletionDelay:
                                      const Duration(milliseconds: 1200),
                                  ////Empty result
                                  noRecordText: EmptyWidget(
                                      controller: addAgencyController,
                                      onpressed: () {
                                        setState(() {
                                          Agency newAgency = Agency(
                                              id: null,
                                              name: addAgencyController.text
                                                  .toUpperCase(),
                                              category: null,
                                              privateEntity: null);
                                          selectedAgency = newAgency;
                                          addAgencyController.text = "";
                                          showAgencyCategory = true;
                                          showIsPrivateRadio = true;
                                          showAgencySearchField =
                                              !showAgencySearchField;
                                          Navigator.pop(context);

                                          Navigator.of(context).pop();
                                        });
                                      },
                                      title: "Add Agency"),
                                     
                                  paginatedRequest:
                                      (int page, String? key) async {
                                    List<Agency> paginatedAgency = [];
                                    try {
                                      paginatedAgency = await ProfileUtilities
                                          .instance
                                          .getPaginatedAgencies(
                                              key: key ??= '');
                                      return paginatedAgency.map((e) {
                                        return SearchableDropdownMenuItem(
                                            value: e,
                                            onTap: () {
                                             setState((){
                                               selectedAgency = e;
                                                             showAgencySearchField =
                                           false;
                                             });
                                            },
                                            label: e.name!,
                                            child: ListTile(
                                              title: Text(e.name!),
                                              subtitle: e.privateEntity == true
                                                  ? const Text("Private")
                                                  : const Text("Government"),
                                            ));
                                      }).toList();
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    }
                                    return null;
                                  })
                              : const SizedBox(),
                        ),
                             const Gap(12),
                        SizedBox(
                          child: !showAgencySearchField
                              ? Column(
                                children: [
                            
                                  TextFormField(
                                      initialValue: selectedAgency!.name,
                                      decoration:
                                          normalTextFieldStyle("", "").copyWith(
                                              labelText: "Training",
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedAgency = null;
                                                      showAgencyCategory = false;
                                                      showIsPrivateRadio = false;
                                                      showAgencySearchField =
                                                          !showAgencySearchField;
                                                    });
                                                  },
                                                  icon: const Icon(Icons.close))),
                                    ),
                                                          const Gap(12),
                                ],
                              )
                              : const SizedBox(),
                        ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                    child: showAgencyCategory
                                        ? SearchField(
                                            focusNode: agencyCategoryFocusNode,
                                            itemHeight: 70,
                                            suggestions: widget.agencyCategories
                                                .map((Category category) =>
                                                    SearchFieldListItem(
                                                        category.name!,
                                                        item: category,
                                                        child: ListTile(
                                                          title:
                                                              Text(category.name!),
                                                          subtitle: Text(category
                                                              .industryClass!
                                                              .name!),
                                                        )))
                                                .toList(),
                                            emptyWidget: Container(
                                              height: 100,
                                              decoration: box1(),
                                              child: const Center(
                                                  child:
                                                      Text("No result found ...")),
                                            ),
                                            ////agency controller suggestion tap
                                            onSuggestionTap: (agencyCategory) {
                                              setState(() {
                                                selectedCategory =
                                                    agencyCategory.item;
                      
                                                agencyCategoryFocusNode.unfocus();
                                              });
                                            },
                                            searchInputDecoration:
                                                normalTextFieldStyle(
                                                        "Category *", "")
                                                    .copyWith(
                                                        suffixIcon: GestureDetector(
                                              child: const Icon(
                                                Icons.arrow_drop_down,
                                              ),
                                              onTap: () =>
                                                  agencyCategoryFocusNode.unfocus(),
                                            )),
                                            validator:
                                                FormBuilderValidators.required(
                                                    errorText:
                                                        "This field is required"),
                                          )
                                        : const SizedBox(),
                                  ),
                      
                                  ////PRVIATE SECTOR
                                  SizedBox(
                                      child: showIsPrivateRadio
                                          ? FormBuilderRadioGroup(
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
                                                    const Icon(
                                                        FontAwesome.help_circled)
                                                  ],
                                                ),
                                              ),
                      
                                              ////onvhange private sector
                                              onChanged: (value) {
                                                setState(() {
                                                  if (value.toString() == "YES") {
                                                    isPrivate = true;
                                                  } else {
                                                    isPrivate = false;
                                                  }
                                                });
                                              },
                      
                                              name: 'isPrivate',
                                              validator:
                                                  FormBuilderValidators.required(
                                                      errorText:
                                                          "This field is required"),
                                              options: ["YES", "NO"]
                                                  .map((lang) =>
                                                      FormBuilderFieldOption(
                                                          value: lang))
                                                  .toList(growable: false),
                                            )
                                          : const SizedBox()),
                                ],
                              );
                            }),
                            ////SHOW CATEGORY AGENCY
                      
                            const SizedBox(
                              height: 24,
                            ),
                            SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: mainBtnStyle(
                                      primary, Colors.transparent, second),
                                  onPressed: () {
                                    if (_formKey.currentState!.saveAndValidate()) {
                                      if (selectedAgency?.privateEntity != null) {
                                        newAgency = selectedAgency;
                                      } else {
                                        newAgency = Agency(
                                            id: selectedAgency?.id,
                                            name: selectedAgency!.name,
                                            category: selectedCategory,
                                            privateEntity: isPrivate);
                                      }
                                 Navigator.of(context).pop();
                                     widget.bloc
                                          .add(AddOrgMembership(
                                              agency: newAgency!,
                                              profileId: widget.profileId,
                                              token: widget.token));
                                      setState(() {
                                        showAgencyCategory = false;
                                        showIsPrivateRadio = false;
                                      });
                                    }
                                  },
                                  child: const Text(submit)),
                            )
                          ]),
                    ));
  }
}
