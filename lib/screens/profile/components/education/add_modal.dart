import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:searchfield/searchfield.dart';
import 'package:unit2/bloc/profile/education/education_bloc.dart';
import 'package:unit2/model/profile/educational_background.dart';
import 'package:unit2/theme-data.dart/box_shadow.dart';
import 'package:unit2/theme-data.dart/form-style.dart';
import 'package:unit2/utils/global.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../../../theme-data.dart/btn-style.dart';
import '../../../../theme-data.dart/colors.dart';
import '../../../../utils/formatters.dart';
import '../../../../utils/text_container.dart';
import '../../shared/add_for_empty_search.dart';

class AddEducationScreen extends StatefulWidget {
  final int profileId;
  final String token;
  const AddEducationScreen(
      {super.key, required this.profileId, required this.token});

  @override
  State<AddEducationScreen> createState() => _AddEducationScreenState();
}

class _AddEducationScreenState extends State<AddEducationScreen> {
  final List<EducationLevel> educationLevel = [
    const EducationLevel(type: "label", value: "Basic Education", group: 1),
    const EducationLevel(type: "level", value: "Elementary", group: 1),
    const EducationLevel(type: "level", value: "Secondary (non-K12)", group: 1),
    const EducationLevel(type: "level", value: "Junior High", group: 1),
    const EducationLevel(type: "level", value: "Senior High", group: 1),
    const EducationLevel(type: "label", value: "Higher Education", group: 2),
    const EducationLevel(type: "level", value: "Collegiate", group: 2),
    const EducationLevel(type: "level", value: "Vocational", group: 2),
    const EducationLevel(type: "label", value: "Post Graduate", group: 2),
    const EducationLevel(type: "level", value: "Masteral", group: 2),
    const EducationLevel(type: "level", value: "Doctorate", group: 2),
  ];
  List<ValueItem> valueItemHonorList = [];
////selected
  EducationLevel? selectedLevel;
  School? selectedSchool;
  Course? selectedProgram;
  List<Honor> selectedHonors = [];
  List<ValueItem>? selectedValueItem;
  final formKey = GlobalKey<FormBuilderState>();
  ////congrollers
  final addProgramController = TextEditingController();
  final addSchoolController = TextEditingController();
  final fromController = TextEditingController();
  final untilController = TextEditingController();
  final yearGraduated = TextEditingController();
  ////focus node
  final programFocusNode = FocusNode();
  final schoolFocusNode = FocusNode();
  final honorFocusNode = FocusNode();
  ////booleans
  bool graduated = true;
  int? unitsEarned;
  ////
@override
  void dispose() {
  addProgramController.dispose(); 
   addSchoolController.dispose(); 
   fromController.dispose(); 
   untilController.dispose(); 

   programFocusNode.dispose();
   schoolFocusNode.dispose();
   honorFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EducationBloc, EducationState>(
      builder: (context, state) {
        if (state is AddEducationState) {
          valueItemHonorList = state.honors.map((Honor honor) {
            return ValueItem(label: honor.name!, value: honor.name);
          }).toList();
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: FormBuilder(
              key: formKey,
              child: SizedBox(
                child: ListView(children: [    
                  //// LEVEL
                  StatefulBuilder(builder: (context, setState) {
                    return Column(
                      children: [
                        SlideInLeft(
                          child: FormBuilderDropdown(
                              validator: FormBuilderValidators.required(
                                  errorText: "This field is required"),
                              decoration:
                                  normalTextFieldStyle("level*", "level"),
                              name: "education_level",
                              onChanged: (EducationLevel? level) {
                                setState(() {
                                  selectedLevel = level;
                                });
                              },
                              items: educationLevel
                                  .map<DropdownMenuItem<EducationLevel>>(
                                      (EducationLevel level) {
                                return level.type == "label"
                                    ? DropdownMenuItem(
                                        enabled: false,
                                        value: level,
                                        child: Text(level.value.toUpperCase(),
                                            style: const TextStyle(
                                                color: Colors.black38)))
                                    : DropdownMenuItem(
                                        value: level,
                                        enabled: true,
                                        child: Text(
                                            "  ${level.value.toUpperCase()}"));
                              }).toList()),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ////school
                        StatefulBuilder(builder: (context, setState) {
                          return SlideInLeft(
                            delay: const Duration(milliseconds: 150),
                            child: SearchField(
                              inputFormatters: [UpperCaseTextFormatter()],
                              itemHeight: 70,
                                                              suggestionsDecoration:  searchFieldDecoration(),
                            
                              suggestions: state.schools
                                  .map((School school) =>
                                      SearchFieldListItem(school.name!,
                                          item: school,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: ListTile(
                                                title: Text(school.name!,overflow: TextOverflow.visible,)),
                                          )))
                                  .toList(),
                              validator: (agency) {
                                if (agency!.isEmpty) {
                                  return "This field is required";
                                }
                                return null;
                              },
                              focusNode: schoolFocusNode,
                              searchInputDecoration:
                                  normalTextFieldStyle("School *", "").copyWith(
                                      suffixIcon: IconButton(
                                icon: const Icon(Icons.arrow_drop_down),
                                onPressed: () {
                                  schoolFocusNode.unfocus();
                                },
                              )),
                              onSuggestionTap: (school) {
                                setState(() {
                                  selectedSchool = school.item;
                                  schoolFocusNode.unfocus();
                                });
                              },
                              emptyWidget: EmptyWidget(
                                  title: "Add School",
                                  controller: addSchoolController,
                                  onpressed: () {
                                    setState(() {
                                      School newSchool = School(
                                          id: null,
                                          name: addSchoolController.text
                                              .toUpperCase());
                                      state.schools.insert(0, newSchool);
                                      addSchoolController.text = "";
                                            
                                      Navigator.pop(context);
                                    });
                                  }),
                            ),
                          );
                        }),
                        const SizedBox(
                          height: 12,
                        ),
                        ////Programs
                        Container(
                            child: selectedLevel != null &&
                                    selectedLevel!.group != 1
                                ? SlideInLeft(
                                  child: SearchField(
                                      inputFormatters: [
                                                      UpperCaseTextFormatter()
                                                    ],
                                      itemHeight: 100,
                                                                             suggestionsDecoration:  searchFieldDecoration(),
                                  
                                      suggestions: state.programs
                                          .map((Course program) =>
                                              SearchFieldListItem(
                                                  program.program!,
                                                  item: program,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: ListTile(
                                                        title: Text(
                                                            program.program!,overflow: TextOverflow.visible,)),
                                                  )))
                                          .toList(),
                                      validator: (agency) {
                                        if (agency!.isEmpty) {
                                          return "This field is required";
                                        }
                                        return null;
                                      },
                                      focusNode: programFocusNode,
                                      searchInputDecoration:
                                          normalTextFieldStyle(
                                                  "Course/Programs *", "")
                                              .copyWith(
                                                  suffixIcon: GestureDetector(
                                                    onTap: () => programFocusNode.unfocus(),
                                                    child: const Icon(
                                                        Icons.arrow_drop_down),
                                                  )),
                                      onSuggestionTap: (position) {
                                        setState(() {
                                          selectedProgram = position.item;
                                          programFocusNode.unfocus();
                                        });
                                      },
                                      emptyWidget: EmptyWidget(
                                          title: "Add Program",
                                          controller: addProgramController,
                                          onpressed: () {
                                            setState(() {
                                              Course newProgram = Course(
                                                  id: null,
                                                  program: addProgramController
                                                      .text
                                                      .toUpperCase());
                                              state.programs
                                                  .insert(0, newProgram);
                                              addProgramController.text = "";
                                                  
                                              Navigator.pop(context);
                                            });
                                          }),
                                    ),
                                )
                                : Container())
                      ],
                    );
                  }),
                  const SizedBox(
                    height: 12,
                  ),
                  StatefulBuilder(builder: (context, setState) {
                    return Column(
                      children: [
                        //// GRADUATED SWITCH
                        SlideInLeft(
                          delay: const Duration(milliseconds: 170),
                          child: FormBuilderSwitch(
                            initialValue: graduated,
                            activeColor: second,
                            onChanged: (value) {
                              setState(() {
                                graduated = value!;
                                if (graduated) {
                                  unitsEarned = null;
                                } else {
                                  yearGraduated.text = "";
                                }
                              });
                            },
                            decoration: normalTextFieldStyle(
                                "Graduated?", 'Graduated?'),
                            name: 'graudated',
                            title: Text(graduated ? "YES" : "NO"),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ////FROM
                        SlideInLeft(
                                                    delay: const Duration(milliseconds: 190),
                          child: SizedBox(
                            width: screenWidth,
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: FormBuilderTextField(
                                    validator: FormBuilderValidators.required(
                                        errorText: "This fied is required"),
                                    decoration:
                                        normalTextFieldStyle("from *", "from"),
                                    name: "",
                                    controller: fromController,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: SizedBox(
                                              width: 300,
                                              height: 300,
                                              child: YearPicker(
                                                firstDate: DateTime(
                                                    DateTime.now().year - 100,
                                                    1),
                                                lastDate: DateTime(
                                                    DateTime.now().year + 100,
                                                    1),
                                                initialDate: DateTime.now(),
                                                selectedDate: DateTime.now(),
                                                onChanged: (DateTime dateTime) {
                                                  fromController.text =
                                                      dateTime.year.toString();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                ////UNTIL
                                Flexible(
                                  flex: 1,
                                  child: FormBuilderTextField(
                                    validator: FormBuilderValidators.required(
                                        errorText: "This fied is required"),
                                    decoration: normalTextFieldStyle(
                                        "until *", "until"),
                                    name: "",
                                    controller: untilController,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: SizedBox(
                                              width: 300,
                                              height: 300,
                                              child: YearPicker(
                                                firstDate: DateTime(
                                                    DateTime.now().year - 100,
                                                    1),
                                                lastDate: DateTime(
                                                    DateTime.now().year + 100,
                                                    1),
                                                initialDate: DateTime.now(),
                                                selectedDate: DateTime.now(),
                                                onChanged: (DateTime dateTime) {
                                                  untilController.text =
                                                      dateTime.year.toString();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          child: graduated
                              ////GRADUATED YEAR
                              ? SlideInLeft(
                          delay: const Duration(milliseconds: 210),
                                child: FormBuilderTextField(
                                    validator: FormBuilderValidators.required(
                                        errorText: "This fied is required"),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: SizedBox(
                                              width: 300,
                                              height: 300,
                                              child: YearPicker(
                                                firstDate: DateTime(
                                                    DateTime.now().year - 100,
                                                    1),
                                                lastDate: DateTime(
                                                    DateTime.now().year + 100,
                                                    1),
                                                initialDate: DateTime.now(),
                                                selectedDate: DateTime.now(),
                                                onChanged: (DateTime dateTime) {
                                                  yearGraduated.text =
                                                      dateTime.year.toString();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    name: "year_graduated",
                                    controller: yearGraduated,
                                    decoration: normalTextFieldStyle(
                                        "Year Graduated *", "Year Graduated *"),
                                  ),
                              )
                              //// HIGHEST UNITS EARNED
                              : SlideInLeft(
                                child: FormBuilderTextField(
                                  keyboardType: TextInputType.number,
                                    validator: FormBuilderValidators.required(
                                        errorText: "This fied is required"),
                                    name: "units_earned",
                                    decoration: normalTextFieldStyle(
                                        "Highest Level/Units Earned *",
                                        "Highest Level/Units Earned *")),
                              ),
                        ),
                      ],
                    );
                  }),
                
                  const SizedBox(
                    height: 12,
                  ),
                  //// HONORS
                  SlideInLeft(
                                              delay: const Duration(milliseconds: 230),
                    child: MultiSelectDropDown(
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        selectedValueItem = selectedOptions;
                      },
                      borderColor: Colors.grey,
                      borderWidth: 1,
                      borderRadius: 5,
                      hint: "Honors",
                      padding: const EdgeInsets.all(8),
                      options: valueItemHonorList,
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 300,
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionIcon: const Icon(Icons.check_circle),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ////sumit button
                
                 FadeInUp(
                   child: SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                                style:
                                    mainBtnStyle(primary, Colors.transparent, second),
                                onPressed: () {
                                  if (formKey.currentState!.saveAndValidate()) {
                                    //// program
                                    if (selectedLevel!.value == "Elementary" ||
                                        selectedLevel!.value ==
                                            "Secondary (non-K12)" ||
                                        selectedLevel!.value == "Junior High" ||
                                        selectedLevel!.value == "Senior High") {
                                      selectedProgram = null;
                                    }
                                    if (!graduated) {
                                      unitsEarned = int.parse(formKey
                                          .currentState!.value['units_earned']);
                                      yearGraduated.text = '';
                                    } else {}
                                    ////education
                                    Education newEducation = Education(
                                        id: null,
                                        level: selectedLevel!.value,
                                        course: selectedProgram,
                                        school: selectedSchool);
                                    ////honors
                                    if (selectedValueItem != null) {
                                      for (var honor in selectedValueItem!) {
                                        Honor newHonor = state.honors.firstWhere(
                                            (element) => element.name == honor.value);
                                        selectedHonors.add(newHonor);
                                      }
                                    }
                      
                                    EducationalBackground educationalBackground =
                                        EducationalBackground(
                                      id: null,
                                      honors: null,
                                      education: newEducation,
                                      periodTo: untilController.text,
                                      periodFrom: fromController.text,
                                      yearGraduated:
                                          graduated ? yearGraduated.text : null,
                                      unitsEarned: !graduated ? unitsEarned : null,
                                      attachments: null,
                                    );
                                   
                                    context.read<EducationBloc>().add(AddEducation(
                                        educationalBackground: educationalBackground,
                                        profileId: widget.profileId,
                                        token: widget.token,
                                        honors: selectedHonors));
                                  }
                                },
                                child: const Text(submit)),
                               
                          ),
                 ),

                ]),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}

class EducationLevel {
  final String value;
  final String type;
  final int group;
  const EducationLevel(
      {required this.type, required this.value, required this.group});
}
