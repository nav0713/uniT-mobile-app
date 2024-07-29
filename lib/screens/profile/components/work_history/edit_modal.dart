import 'package:animate_do/animate_do.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:searchfield/searchfield.dart';
import 'package:unit2/screens/profile/shared/add_for_empty_search.dart';
import '../../../../bloc/profile/workHistory/workHistory_bloc.dart';
import '../../../../model/profile/work_history.dart';
import '../../../../model/utils/agency.dart';
import '../../../../model/utils/agency_position.dart';
import '../../../../model/utils/category.dart';
import '../../../../model/utils/position.dart';
import '../../../../theme-data.dart/box_shadow.dart';
import '../../../../theme-data.dart/btn-style.dart';
import '../../../../theme-data.dart/colors.dart';
import '../../../../theme-data.dart/form-style.dart';
import '../../../../utils/formatters.dart';
import '../../../../utils/global.dart';
import '../../../../utils/text_container.dart';
import '../../../../utils/validators.dart';

class EditWorkHistoryScreen extends StatefulWidget {
  final int profileId;
  final String token;
  const EditWorkHistoryScreen(
      {super.key, required this.profileId, required this.token});

  @override
  State<EditWorkHistoryScreen> createState() => _EditWorkHistoryScreenState();
}

class _EditWorkHistoryScreenState extends State<EditWorkHistoryScreen> {
  final addAgencyController = TextEditingController();
  final addPositionController = TextEditingController();
  final toDateController = TextEditingController();
  final fromDateController = TextEditingController();
  final oldPositionController = TextEditingController();
  final oldAppointmentStatusController = TextEditingController();
  final oldAgencyController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  PositionTitle? selectedPosition;
  Agency? selectedAgency;
  AppoinemtStatus? selectedStatus;
  Category? selectedAgencyCategory;
  String? salary;
  String? salaryGrade;
  String? salaryGradeStep;
  String? accomplishments;
  String? duties;
  String? sFname;
  String? sMname;
  String? sLname;
  String? sOffice;
  //show agency category is a variable to show adding of agency category if you add agency manually
  bool showAgencyCategory = false;
  //showSalaryGadeAndSalaryStep is a variable that will show salary
  //and salary step if selected agency is government
  bool showSalaryGradeAndSalaryStep = false;
  //isPrivate is the value of the isPrivate radion button
  bool? isPrivate = false;
  //showIsPrivateRadion is a variable that will show isPrivate radio if you
  //add agency manually
  bool showIsPrivateRadio = false;
  bool currentlyEmployed = false;
  final agencyFocusNode = FocusNode();
  final positionFocusNode = FocusNode();
  final appointmentStatusNode = FocusNode();
  final agencyCategoryFocusNode = FocusNode();
  DateTime? from;
  DateTime? to;
  @override
  void dispose() {
    addPositionController.dispose();
    addAgencyController.dispose();
    toDateController.dispose();
    fromDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkHistoryBloc, WorkHistoryState>(
      builder: (context, state) {
        if (state is EditWorkHistoryState) {
          oldPositionController.text = state.workHistory.position!.title!;
          oldAppointmentStatusController.text =
              state.workHistory.statusAppointment!;
          oldAgencyController.text = state.workHistory.agency!.name!;
          currentlyEmployed = state.workHistory.toDate == null ? true : false;
          showSalaryGradeAndSalaryStep =
              !state.workHistory.agency!.privateEntity!;
          fromDateController.text = state.workHistory.fromDate.toString();
          toDateController.text = state.workHistory.toDate.toString();
          currentlyEmployed = state.workHistory.toDate == null ? true : false;
          from = state.workHistory.fromDate;
          to = state.workHistory.toDate;
          accomplishments = state.workHistory.accomplishment == null
              ? null
              : state.workHistory.accomplishment!.first.accomplishment!;
          duties = state.workHistory.actualDuties == null
              ? null
              : state.workHistory.actualDuties!.first.description;
          sFname = state.workHistory.supervisor?.firstname;
          sMname = state.workHistory.supervisor?.middlename;
          sLname = state.workHistory.supervisor?.lastname;
          sOffice = state.workHistory.supervisor?.stationName;
          return FormBuilder(
            key: _formKey,
            child: SizedBox(
              height: blockSizeVertical * 90,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
                child: Column(
                  children: [
                    Flexible(
                      child: ListView(
                        children: [
                          ////POSITIONS
                          StatefulBuilder(builder: (context, setState) {
                            return SlideInLeft(
                              child: SearchField(
                                inputFormatters: [UpperCaseTextFormatter()],
                                controller: oldPositionController,
                                itemHeight: 100,
                                suggestionsDecoration: searchFieldDecoration(),
                                suggestions: state.agencyPositions
                                    .map((PositionTitle position) =>
                                        SearchFieldListItem(position.title!,
                                            item: position,
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: ListTile(
                                                  title: Text(
                                                    position.title!,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                ))))
                                    .toList(),
                                focusNode: positionFocusNode,
                                searchInputDecoration:
                                    normalTextFieldStyle("Position *", "")
                                        .copyWith(
                                            suffixIcon: IconButton(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onPressed: () {
                                    positionFocusNode.unfocus();
                                  },
                                )),
                                onSuggestionTap: (position) {
                                  setState(() {
                                    selectedPosition = position.item;
                                    positionFocusNode.unfocus();
                                  });
                                },
                                emptyWidget: EmptyWidget(
                                    controller: addPositionController,
                                    onpressed: () {
                                      setState(() {
                                        PositionTitle newAgencyPosition =
                                            PositionTitle(
                                                id: null,
                                                title: addPositionController
                                                    .text
                                                    .toUpperCase());
                                        state.agencyPositions
                                            .insert(0, newAgencyPosition);
                                        selectedPosition = newAgencyPosition;
                                        addPositionController.text = "";
                                        Navigator.pop(context);
                                      });
                                    },
                                    title: "Add Position"),
                                validator: (position) {
                                  if (position!.isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                              ),
                            );
                          }),
                          const SizedBox(
                            height: 12,
                          ),
                          ////APPOINTMENT STATUS'
                          SlideInLeft(
                            delay: const Duration(milliseconds: 150),
                            child: SearchField(
                                inputFormatters: [UpperCaseTextFormatter()],
                                controller: oldAppointmentStatusController,
                                suggestions: state.appointmentStatus
                                    .map((AppoinemtStatus status) =>
                                        SearchFieldListItem(status.label,
                                            item: status,
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Text(status.label))))
                                    .toList(),
                                focusNode: appointmentStatusNode,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                onSuggestionTap: (status) {
                                  selectedStatus = status.item;
                                  appointmentStatusNode.unfocus();
                                },
                                searchInputDecoration: normalTextFieldStyle(
                                        "Appointment Status", "")
                                    .copyWith(
                                        suffixIcon: IconButton(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onPressed: () {
                                    appointmentStatusNode.unfocus();
                                  },
                                ))),
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          ////AGENCY
                          StatefulBuilder(builder: (context, setState) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SlideInLeft(
                                                 delay: const Duration(milliseconds: 170),
                                  child: SearchField(
                                      enabled: false,
                                      inputFormatters: [UpperCaseTextFormatter()],
                                      controller: oldAgencyController,
                                      itemHeight: 100,
                                      focusNode: agencyFocusNode,
                                      suggestions: state.agencies
                                          .map((Agency agency) =>
                                              SearchFieldListItem(agency.name!,
                                                  item: agency,
                                                  child: ListTile(
                                                    title: Text(
                                                      agency.name!,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                    subtitle: Text(
                                                        agency.privateEntity ==
                                                                true
                                                            ? "Private"
                                                            : "Government"),
                                                  )))
                                          .toList(),
                                      searchInputDecoration:
                                          normalTextFieldStyle("Agency *", "")
                                              .copyWith(
                                                  suffixIcon: IconButton(
                                        icon: const Icon(Icons.arrow_drop_down),
                                        onPressed: () {
                                          agencyFocusNode.unfocus();
                                        },
                                      )),
                                      onSuggestionTap: (agency) {
                                        setState(() {
                                          selectedAgency = agency.item;
                                          if (selectedAgency!.privateEntity ==
                                              null) {
                                            showIsPrivateRadio = true;
                                          } else {
                                            showIsPrivateRadio = false;
                                          }
                                          if (selectedAgency!.privateEntity ==
                                              true) {
                                            showSalaryGradeAndSalaryStep = false;
                                          }
                                          if (selectedAgency!.privateEntity ==
                                              false) {
                                            showSalaryGradeAndSalaryStep = true;
                                          }
                                          agencyFocusNode.unfocus();
                                        });
                                      },
                                      validator: (agency) {
                                        if (agency!.isEmpty) {
                                          return "This field is required";
                                        }
                                        return null;
                                      },
                                      emptyWidget: EmptyWidget(
                                          controller: addAgencyController,
                                          onpressed: () {
                                            setState(() {
                                              Agency newAgency = Agency(
                                                  id: null,
                                                  name: addAgencyController.text
                                                      .toUpperCase(),
                                                  category: null,
                                                  privateEntity: null);
                                              state.agencies.insert(0, newAgency);
                                              selectedAgency = newAgency;
                                              addAgencyController.text = "";
                                              showAgencyCategory = true;
                                  
                                              showIsPrivateRadio = true;
                                  
                                              Navigator.pop(context);
                                            });
                                          },
                                          title: "Add Agency")),
                                ),
                                SlideInLeft(
                                                 delay: const Duration(milliseconds: 170),
                                  child: Text(
                                    "You cannot change agency on update mode",
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),

                                SizedBox(
                                  height: showAgencyCategory ? 12 : 0,
                                ),
                                ////SHOW AGENCY CATEGORY
                                SizedBox(
                                  child: showAgencyCategory
                                      ? SearchField(
                                          focusNode: agencyCategoryFocusNode,
                                          itemHeight: 70,
                                          suggestions: state.agencyCategory
                                              .map((Category category) =>
                                                  SearchFieldListItem(
                                                      category.name!,
                                                      item: category,
                                                      child: ListTile(
                                                        title: Text(
                                                            category.name!),
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
                                          onSuggestionTap: (agencyCategory) {
                                            setState(() {
                                              selectedAgencyCategory =
                                                  agencyCategory.item;
                                              agencyCategoryFocusNode.unfocus();
                                              selectedAgency = Agency(
                                                  id: null,
                                                  name: selectedAgency!.name,
                                                  category:
                                                      selectedAgencyCategory,
                                                  privateEntity: null);
                                            });
                                          },
                                          searchInputDecoration:
                                              normalTextFieldStyle(
                                                      "Category *", "")
                                                  .copyWith(
                                                      suffixIcon: IconButton(
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
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
                                                  showSalaryGradeAndSalaryStep =
                                                      false;
                                                } else {
                                                  isPrivate = false;
                                                  showSalaryGradeAndSalaryStep =
                                                      true;
                                                }
                                                selectedAgency = Agency(
                                                    id: null,
                                                    name: selectedAgency!.name,
                                                    category:
                                                        selectedAgencyCategory,
                                                    privateEntity:
                                                        value == "YES"
                                                            ? true
                                                            : false);
                                                agencyFocusNode.unfocus();
                                                agencyCategoryFocusNode
                                                    .unfocus();
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
                                SizedBox(
                                  height: showSalaryGradeAndSalaryStep ? 12 : 0,
                                ),
                                ////SALARY GRADE AND SALARY GRADE STEP
                                SlideInLeft(
                                           delay: const Duration(milliseconds: 190),
                                  child: SizedBox(
                                      child: showSalaryGradeAndSalaryStep
                                          ? Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    ////SALARY GRADE
                                                    Flexible(
                                                      flex: 1,
                                                      child: FormBuilderTextField(
                                                        initialValue: state
                                                            .workHistory
                                                            .salarygrade
                                                            ?.toString(),
                                                        name: 'salary_grade',
                                                        keyboardType:
                                                            TextInputType.number,
                                                        decoration:
                                                            normalTextFieldStyle(
                                                                "Salary Grade (SG)",
                                                                "0"),
                                                        validator:
                                                            integerAndNumeric,
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 12,
                                                    ),
                                                    //// SALARY STEP
                                                    Flexible(
                                                      flex: 1,
                                                      child: FormBuilderTextField(
                                                        initialValue: state
                                                            .workHistory.sgstep
                                                            ?.toString(),
                                                        name: 'salary_step',
                                                        keyboardType:
                                                            TextInputType.number,
                                                        decoration:
                                                            normalTextFieldStyle(
                                                                "SG Step (SG)",
                                                                "0"),
                                                        validator:
                                                            integerAndNumeric,
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )
                                          : null),
                                ),
                              ],
                            );
                          }),

                          const SizedBox(
                            height: 12,
                          ),
                          ////MONTHLY SALARY
                          SlideInLeft(
                                     delay: const Duration(milliseconds: 210),
                            child: FormBuilderTextField(
                              initialValue:
                                  state.workHistory.monthlysalary.toString(),
                              onChanged: (value) {
                                setState(() {
                                  salary = value;
                                });
                              },
                              validator: numericRequired,
                              name: "salary",
                              decoration:
                                  normalTextFieldStyle("Monthly Salary *", "")
                                      .copyWith(prefix: const Text("₱ ")),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SlideInLeft(
                                               delay: const Duration(milliseconds: 210),
                              child: Text(
                                "Immediate SuperVisor",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          ////IMMEDIATE SUPERVISOR
                          SlideInLeft(
                                                                 delay: const Duration(milliseconds: 230),
                            child: FormBuilderTextField(
                              initialValue: sFname,
                              onChanged: (value) {
                                sFname = value;
                              },
                              validator: FormBuilderValidators.required(
                                  errorText: "This field is required"),
                              name: 'supervisor_firstname',
                              decoration: normalTextFieldStyle(
                                  "First name", "First Name"),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SlideInLeft(
                                                                                             delay: const Duration(milliseconds: 250),
                            child: FormBuilderTextField(
                              initialValue: sMname,
                              onChanged: (value) {
                                sMname = value;
                              },
                              name: 'supervisor_middlename',
                              decoration: normalTextFieldStyle(
                                  "Middle name", "Middle Name"),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SlideInLeft(
                                                                                             delay: const Duration(milliseconds: 270),
                            child: FormBuilderTextField(
                              initialValue: sLname,
                              onChanged: (value) {
                                sLname = value;
                              },
                              validator: FormBuilderValidators.required(
                                  errorText: "This field is required"),
                              name: 'supervisor_lastname',
                              decoration:
                                  normalTextFieldStyle("Last name", "Last Name"),
                            ),
                          ),

                          const SizedBox(
                            height: 12,
                          ),
                          //// NAME OF OFFICE UNIT
                          SlideInLeft(
                                                                                             delay: const Duration(milliseconds: 290),
                            child: FormBuilderTextField(
                              initialValue: sOffice,
                              onChanged: (value) {
                                sOffice = value;
                              },
                              validator: FormBuilderValidators.required(
                                  errorText: "This field is required"),
                              name: 'office',
                              decoration: normalTextFieldStyle(
                                  "Name of Office/Unit", "Name of Office/Unit"),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          StatefulBuilder(builder: (context, setState) {
                            return Column(
                              children: [
                                ////CURRENTLY EMPLOYED
                                SlideInLeft(
                                                                                                   delay: const Duration(milliseconds: 310),
                                  child: FormBuilderSwitch(
                                    initialValue: currentlyEmployed,
                                    activeColor: second,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          currentlyEmployed = true;
                                          toDateController.text = "PRESENT";
                                        } else {
                                          currentlyEmployed = false;
                                          toDateController.text = "";
                                        }
                                      });
                                    },
                                    decoration: normalTextFieldStyle("", ''),
                                    name: 'overseas',
                                    title: const Text("Currently Employed?"),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                SlideInLeft(
                                     delay: const Duration(milliseconds: 330),
                                  child: SizedBox(
                                    width: screenWidth,
                                    child: StatefulBuilder(
                                        builder: (context, setState) {
                                      return Row(
                                        children: [
                                          //// FROM DATE
                                          Flexible(
                                              flex: 1,
                                              child: DateTimePicker(
                                                validator: FormBuilderValidators
                                                    .required(
                                                        errorText:
                                                            "This field is required"),
                                                use24HourFormat: false,
                                                icon:
                                                    const Icon(Icons.date_range),
                                                controller: fromDateController,
                                                firstDate: DateTime(1990),
                                                lastDate: DateTime(2100),
                                                timeHintText:
                                                    "Date of Examination/Conferment",
                                                decoration: normalTextFieldStyle(
                                                        "From *", "From *")
                                                    .copyWith(
                                                        prefixIcon: const Icon(
                                                  Icons.date_range,
                                                  color: Colors.black87,
                                                )),
                                                selectableDayPredicate: (date) {
                                                  if (to != null &&
                                                      to!.microsecondsSinceEpoch <=
                                                          date.microsecondsSinceEpoch) {
                                                    return false;
                                                  }
                                                  return true;
                                                },
                                                onChanged: (value) {
                                                  setState(() {
                                                    from = DateTime.parse(value);
                                                  });
                                                },
                                                initialDate: to == null
                                                    ? DateTime.now()
                                                    : to!.subtract(
                                                        const Duration(days: 1)),
                                              )),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          //// TO DATE
                                          Flexible(
                                            flex: 1,
                                            child: currentlyEmployed
                                                ? TextFormField(
                                                    enabled: false,
                                                    initialValue: "PRESENT",
                                                    style: const TextStyle(
                                                        color: Colors.black45),
                                                    decoration:
                                                        normalTextFieldStyle(
                                                                "", "")
                                                            .copyWith(
                                                                prefixIcon:
                                                                    const Icon(
                                                      Icons.date_range,
                                                      color: Colors.black45,
                                                    )),
                                                  )
                                                : DateTimePicker(
                                                    validator: FormBuilderValidators
                                                        .required(
                                                            errorText:
                                                                "This field is required"),
                                                    controller: toDateController,
                                                    firstDate: DateTime(1990),
                                                    lastDate: DateTime(2100),
                                                    selectableDayPredicate:
                                                        (date) {
                                                      if (from != null &&
                                                          from!.microsecondsSinceEpoch >=
                                                              date.microsecondsSinceEpoch) {
                                                        return false;
                                                      }
                                                      return true;
                                                    },
                                                    onChanged: (value) {
                                                      setState(() {
                                                        to =
                                                            DateTime.parse(value);
                                                      });
                                                    },
                                                    initialDate: from == null
                                                        ? DateTime.now()
                                                        : from!.add(
                                                            const Duration(
                                                                days: 1)),
                                                    decoration: normalTextFieldStyle(
                                                            "To *", "To *")
                                                        .copyWith(
                                                            prefixIcon:
                                                                const Icon(
                                                              Icons.date_range,
                                                              color:
                                                                  Colors.black87,
                                                            ),
                                                            prefixText:
                                                                currentlyEmployed
                                                                    ? "PRESENT"
                                                                    : ""),
                                                    initialValue: null,
                                                  ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SlideInLeft(
                                       delay: const Duration(milliseconds: 330),
                                    child: Text(
                                      "Work Experience",
                                      textAlign: TextAlign.start,
                                      style:
                                          Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SlideInLeft(
                                                                         delay: const Duration(milliseconds: 350),
                                  child: FormBuilderTextField(
                                    initialValue: accomplishments,
                                    maxLines: 3,
                                    onChanged: (value) {
                                      accomplishments = value;
                                    },
                                    name: "accomplishment",
                                    decoration: normalTextFieldStyle(
                                      "List of Accomplishment and Contribution",
                                      "",
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                SlideInLeft(
                                                         
                                                                         delay: const Duration(milliseconds: 350),
                                  child: FormBuilderTextField(
                                    initialValue: duties,
                                    maxLines: 3,
                                    onChanged: (value) {
                                      duties = value;
                                    },
                                    validator: FormBuilderValidators.required(
                                        errorText: "This field is required"),
                                    name: "summary",
                                    decoration: normalTextFieldStyle(
                                      "Summary of Actual Duties",
                                      "",
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ////SUBMIT BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: FadeInUp(
                        child: ElevatedButton(
                            style:
                                mainBtnStyle(primary, Colors.transparent, second),
                            onPressed: () {
                              if (_formKey.currentState!.saveAndValidate()) {
                                final progress = ProgressHUD.of(context);
                                progress!.showWithText("Loading...");
                                salary = _formKey.currentState!.value['salary'];
                                selectedPosition ??= state.workHistory.position;
                                salaryGrade =
                                    _formKey.currentState!.value['salary_grade'];
                                salaryGradeStep =
                                    _formKey.currentState!.value['salary_step'];
                                selectedAgency ??= state.workHistory.agency;
                        
                                selectedStatus ??= AppoinemtStatus(
                                    value: state.workHistory.statusAppointment!,
                                    label: state.workHistory.statusAppointment!);
                                WorkHistory newWorkHistory = WorkHistory(
                                  attachments: null,
                                  accomplishment: accomplishments == null
                                      ? null
                                      : [
                                          Accomplishment(
                                              id: state.workHistory
                                                  .accomplishment!.first.id,
                                              workExperienceId:
                                                  state.workHistory.id,
                                              accomplishment: accomplishments)
                                        ],
                                  actualDuties: duties == null
                                      ? null
                                      : [
                                          ActualDuty(
                                              id: state.workHistory.actualDuties!
                                                  .first.id,
                                              workExperienceId:
                                                  state.workHistory.id,
                                              description: duties!)
                                        ],
                                  agencydepid: state.workHistory.agency!.id,
                                  supervisor: Supervisor(
                                      agencyId: state.workHistory.agencydepid,
                                      id: state.workHistory.supervisor!.id,
                                      firstname: sFname,
                                      middlename: sMname,
                                      lastname: sLname,
                                      stationName: sOffice),
                                  id: state.workHistory.id,
                                  position: selectedPosition,
                                  agency: selectedAgency,
                                  fromDate: fromDateController.text.isEmpty
                                      ? null
                                      : DateTime.parse(fromDateController.text),
                                  toDate: toDateController.text.isEmpty ||
                                          toDateController.text.toUpperCase() ==
                                              "PRESENT" ||
                                          toDateController.text.toLowerCase() ==
                                              'null'
                                      ? null
                                      : DateTime.parse(toDateController.text),
                                  monthlysalary: double.parse(salary!),
                                  statusAppointment: selectedStatus!.value,
                                  salarygrade: salaryGrade == null
                                      ? null
                                      : int.parse(salaryGrade!),
                                  sgstep: salaryGradeStep == null
                                      ? null
                                      : int.parse(salaryGradeStep!),
                                );
                                context.read<WorkHistoryBloc>().add(
                                    UpdateWorkHistory(
                                        isPrivate: state
                                            .workHistory.agency!.privateEntity!,
                                        profileId: widget.profileId,
                                        token: widget.token,
                                        workHistory: newWorkHistory));
                              }
                            },
                            child: const Text(submit)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(
          child: Text("Add Work History"),
        );
      },
    );
  }
}
