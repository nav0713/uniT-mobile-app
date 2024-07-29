import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:searchfield/searchfield.dart';
import 'package:unit2/bloc/profile/other_information/non_academic_recognition.dart/non_academic_recognition_bloc.dart';
import 'package:unit2/bloc/profile/profile_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/model/profile/other_information/non_acedimic_recognition.dart';
import 'package:unit2/theme-data.dart/form-style.dart';
import 'package:unit2/utils/global.dart';

import '../../../../../model/utils/agency.dart';
import '../../../../../model/utils/category.dart';
import '../../../../../theme-data.dart/box_shadow.dart';
import '../../../../../theme-data.dart/btn-style.dart';
import '../../../../../theme-data.dart/colors.dart';
import '../../../../../utils/formatters.dart';
import '../../../../../utils/text_container.dart';

class EditNonAcademicRecognitionScreen extends StatefulWidget {
  const EditNonAcademicRecognitionScreen({super.key});

  @override
  State<EditNonAcademicRecognitionScreen> createState() =>
      _EditNonAcademicRecognitionScreenState();
}

class _EditNonAcademicRecognitionScreenState
    extends State<EditNonAcademicRecognitionScreen> {
  bool showAgencyCategory = false;
  final agencyFocusNode = FocusNode();

  final agencyCategoryFocusNode = FocusNode();
  final addAgencyController = TextEditingController();
  Agency? selectedAgency;
  Category? selectedCategory;
  Agency? newAgency;
  bool showIsPrivateRadio = false;
  bool? isPrivate = false;
  NonAcademicRecognition? nonAcademicRecognition;
  final oldAgencyController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  int? profileId;
  String? token;

  @override
  void dispose() {
    agencyFocusNode.dispose();
    agencyCategoryFocusNode.dispose();
    addAgencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoggedIn) {
          token = state.userData!.user!.login!.token;
          profileId = state.userData!.user!.login!.user!.profileId!;
          return BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                return BlocBuilder<NonAcademicRecognitionBloc,
                    NonAcademicRecognitionState>(
                  builder: (context, state) {
                    if (state is EditNonAcademeRecognitionState) {
                      oldAgencyController.text =
                          state.nonAcademicRecognition.presenter!.name!;
                      selectedAgency = state.nonAcademicRecognition.presenter;
                      selectedCategory =
                          state.nonAcademicRecognition.presenter!.category;
                      return SizedBox(
                          height: blockSizeVertical * 90,
                          child: SingleChildScrollView(
                            child: FormBuilder(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 25, horizontal: 18),
                                  child: Column(
                                    children: [
                                      SlideInLeft(
                                        child: FormBuilderTextField(
                                          inputFormatters: [UpperCaseTextFormatter()],
                                          name: 'title',
                                          initialValue:
                                              state.nonAcademicRecognition.title,
                                          decoration: normalTextFieldStyle(
                                              "Recognition / Award Title *",
                                              "Recognition / Award Title"),
                                          validator:
                                              FormBuilderValidators.required(
                                                  errorText:
                                                      "this field is required"),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      StatefulBuilder(
                                          builder: (context, setState) {
                                        //// AGENCY SEARCHFIELD
                                        return Column(
                                          children: [
                                            SlideInLeft(
                                                                            delay: const Duration(milliseconds: 150),
                                              child: SearchField(
                                                inputFormatters: [
                                                  UpperCaseTextFormatter()
                                                ],
                                                controller: oldAgencyController,
                                                itemHeight: 100,
                                                suggestions: state.agencies
                                                    .map((Agency agency) =>
                                                        SearchFieldListItem(
                                                            agency.name!,
                                                            item: agency,
                                                            child: ListTile(
                                                              title: Text(
                                                                agency.name!
                                                                    .toUpperCase(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                              ),
                                                              subtitle: Text(agency
                                                                          .privateEntity ==
                                                                      true
                                                                  ? "Private"
                                                                  : agency.privateEntity ==
                                                                          false
                                                                      ? "Government"
                                                                      : ""),
                                                            )))
                                                    .toList(),
                                              
                                                validator: FormBuilderValidators
                                                    .required(
                                                        errorText:
                                                            "This field is required"),
                                                focusNode: agencyFocusNode,
                                                searchInputDecoration:
                                                    normalTextFieldStyle(
                                                            "Agency *", "")
                                                        .copyWith(
                                                            suffixIcon:
                                                                GestureDetector(
                                                  child: const Icon(
                                                    Icons.arrow_drop_down,
                                                  ),
                                                  onTap: () =>
                                                      agencyCategoryFocusNode
                                                          .unfocus(),
                                                )),
                                                ////agency suggestion tap
                                                onSuggestionTap: (agency) {
                                                  setState(() {
                                                    selectedAgency = agency.item;
                                                    agencyFocusNode.unfocus();
                                                    if (selectedAgency
                                                            ?.category ==
                                                        null) {
                                                      showAgencyCategory = true;
                                                      showIsPrivateRadio = true;
                                                    } else {
                                                      showAgencyCategory = false;
                                                      showIsPrivateRadio = false;
                                                    }
                                                  });
                                                },
                                                emptyWidget: Container(
                                                  decoration: box1(),
                                                  height: 100,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        const Text(
                                                            "No result found..."),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextButton(
                                                            //// Add agency onpressed
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          "Add Agency?"),
                                                                      content:
                                                                          SizedBox(
                                                                        height:
                                                                            130,
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            TextFormField(
                                                                              inputFormatters: [UpperCaseTextFormatter()],
                                                                              controller:
                                                                                  addAgencyController,
                                                                              decoration:
                                                                                  normalTextFieldStyle("", ""),
                                                                            ),
                                                                            const SizedBox(
                                                                              height:
                                                                                  12,
                                                                            ),
                                                                            SizedBox(
                                                                                width: double.infinity,
                                                                                height: 50,
                                                                                child: ElevatedButton(
                                                                                    style: mainBtnStyle(primary, Colors.transparent, second),
                                                                                    //// onpressed
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        newAgency = Agency(id: null, name: addAgencyController.text.toUpperCase(), category: null, privateEntity: null);
                                                                                        state.agencies.insert(0, newAgency!);
                                                                                        addAgencyController.clear();
                                                                                        Navigator.pop(context);
                                                                                      });
                                                                                    },
                                                                                    child: const Text("Add"))),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                            },
                                                            child: const Text(
                                                                "Add position"))
                                                      ]),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            SizedBox(
                                              child: showAgencyCategory
                                                  ? SearchField(
                                                      focusNode:
                                                          agencyCategoryFocusNode,
                                                      itemHeight: 70,
                                                      suggestions: state
                                                          .agencyCategories
                                                          .map((Category
                                                                  category) =>
                                                              SearchFieldListItem(
                                                                  category
                                                                      .name!,
                                                                  item:
                                                                      category,
                                                                  child:
                                                                      ListTile(
                                                                    title: Text(
                                                                        category
                                                                            .name!),
                                                                    subtitle: Text(category
                                                                        .industryClass!
                                                                        .name!),
                                                                  )))
                                                          .toList(),
                                                      emptyWidget: Container(
                                                        height: 100,
                                                        decoration: box1(),
                                                        child: const Center(
                                                            child: Text(
                                                                "No result found ...")),
                                                      ),
                                                      ////agency controller suggestion tap
                                                      onSuggestionTap:
                                                          (agencyCategory) {
                                                        setState(() {
                                                          selectedCategory =
                                                              agencyCategory
                                                                  .item;

                                                          agencyCategoryFocusNode
                                                              .unfocus();
                                                        });
                                                      },
                                                      searchInputDecoration:
                                                          normalTextFieldStyle(
                                                                  "Category *",
                                                                  "")
                                                              .copyWith(
                                                                  suffixIcon:
                                                                      GestureDetector(
                                                        child: const Icon(
                                                          Icons.arrow_drop_down,
                                                        ),
                                                        onTap: () =>
                                                            agencyCategoryFocusNode
                                                                .unfocus(),
                                                      )),
                                                      validator:
                                                          FormBuilderValidators
                                                              .required(
                                                                  errorText:
                                                                      "This field is required"),
                                                    )
                                                  : const SizedBox(),
                                            ),

                                            ////PRVIATE SECTOR
                                            SizedBox(
                                                child: showIsPrivateRadio
                                                    ? FormBuilderRadioGroup(
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          label: Row(
                                                            children: [
                                                              Text(
                                                                "Is this private sector? ",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headlineSmall!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            24),
                                                              ),
                                                              const Icon(FontAwesome
                                                                  .help_circled)
                                                            ],
                                                          ),
                                                        ),

                                                        ////onvhange private sector
                                                        onChanged: (value) {
                                                          setState(() {
                                                            if (value
                                                                    .toString() ==
                                                                "YES") {
                                                              isPrivate = true;
                                                            } else {
                                                              isPrivate = false;
                                                            }
                                                          });
                                                        },

                                                        name: 'isPrivate',
                                                        validator:
                                                            FormBuilderValidators
                                                                .required(
                                                                    errorText:
                                                                        "This field is required"),
                                                        options: ["YES", "NO"]
                                                            .map((lang) =>
                                                                FormBuilderFieldOption(
                                                                    value:
                                                                        lang))
                                                            .toList(
                                                                growable:
                                                                    false),
                                                      )
                                                    : const SizedBox()),
                                          ],
                                        );
                                      }),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      SizedBox(
                                        height: 60,
                                        width: double.infinity,
                                        child: FadeInUp(
                                          child: ElevatedButton(
                                              style: mainBtnStyle(primary,
                                                  Colors.transparent, second),
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .saveAndValidate()) {
                                                  String title = _formKey
                                                      .currentState!
                                                      .value['title'];
                                          
                                                  if (selectedAgency
                                                          ?.privateEntity !=
                                                      null) {
                                                    newAgency = selectedAgency;
                                                  } else {
                                                    newAgency = Agency(
                                                        id: selectedAgency?.id,
                                                        name:
                                                            selectedAgency!.name,
                                                        category:
                                                            selectedCategory,
                                                        privateEntity: isPrivate);
                                                  }
                                                  nonAcademicRecognition =
                                                      NonAcademicRecognition(
                                                          id: state
                                                              .nonAcademicRecognition
                                                              .id,
                                                          title: title,
                                                          presenter: newAgency);
                                                  context
                                                      .read<
                                                          NonAcademicRecognitionBloc>()
                                                      .add(EditNonAcademeRecognition(
                                                          nonAcademicRecognition:
                                                              nonAcademicRecognition!,
                                                          profileId: profileId!,
                                                          token: token!));
                                                }
                                              },
                                              child: const Text(submit)),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          ));
                    }
                    return Container();
                  },
                );
              }
              return Container();
            },
          );
        }
        return Container();
      },
    );
  }
}
