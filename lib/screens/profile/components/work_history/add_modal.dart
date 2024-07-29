import 'package:animate_do/animate_do.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:searchfield/searchfield.dart';
import 'package:unit2/bloc/profile/workHistory/workHistory_bloc.dart';
import 'package:unit2/model/profile/work_history.dart';
import 'package:unit2/model/utils/agency.dart';
import 'package:unit2/model/utils/agency_position.dart';
import 'package:unit2/model/utils/category.dart';
import 'package:unit2/theme-data.dart/box_shadow.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/theme-data.dart/form-style.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/profile_utilities.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/utils/validators.dart';
import '../../../../model/utils/position.dart';
import '../../../../utils/formatters.dart';
import '../../shared/add_for_empty_search.dart';

class AddWorkHistoryScreen extends StatefulWidget {
  final int profileId;
  final String token;
  const AddWorkHistoryScreen(
      {super.key, required this.profileId, required this.token});

  @override
  State<AddWorkHistoryScreen> createState() => _AddWorkHistoryScreenState();
}

class _AddWorkHistoryScreenState extends State<AddWorkHistoryScreen> {
  final addAgencyController = TextEditingController();
  final addPositionController = TextEditingController();
  final toDateController = TextEditingController();
  final fromDateController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  PositionTitle? selectedPosition;
  Agency? selectedAgency;
  AppoinemtStatus? selectedStatus;
  Category? selectedAgencyCategory;
  String? salary;
  String? salaryGrade;
  String? salaryGradeStep;
  String? accomplishment;
  String? duties;
  String? sFname;
  String? sLname;
  String? sMname;
  String? sOffice;
  bool showAgency = false;
  bool showSalaryGradeAndSalaryStep = false;
  bool? isPrivate = false;
  bool showIsPrivateRadio = false;
  bool currentlyEmployed = false;
  bool showAgencySearchField = true;
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
    return BlocConsumer<WorkHistoryBloc, WorkHistoryState>(
        listener: (context, state) {
      if (state is AddWorkHistoryState) {
        final progress = ProgressHUD.of(context);
        progress!.dismiss();
      }
    }, builder: (context, state) {
      if (state is AddWorkHistoryState) {
        return FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                         ////AGENCY
                  StatefulBuilder(builder: (context, setState) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: showAgencySearchField
                              ? SlideInLeft(
                                child: SearchableDropdown.paginated(
                                    backgroundDecoration: (child) {
                                      return Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: child,
                                        ),
                                      );
                                    },
                                    hintText: const Text("Search Agency"),
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
                                            showAgency = true;
                                            showIsPrivateRadio = true;
                                            showAgencySearchField =
                                             false;
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
                                             if(e.privateEntity == true){
                                                showSalaryGradeAndSalaryStep = false;
                                             }else{
                                                       showSalaryGradeAndSalaryStep = true;
                                             }
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
                                    }),
                              )
                              : const SizedBox()
                                                 
                        ),
                        FadeIn(
                          child: SizedBox(
                            child: !showAgencySearchField
                                ? TextFormField(
                                    initialValue: selectedAgency!.name,
                                    decoration:
                                        normalTextFieldStyle("", "").copyWith(
                                            labelText: "Training",
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    selectedAgency = null;
                                                    showAgency = false;
                                                    showIsPrivateRadio = false;
                                                    showAgencySearchField =
                                                        !showAgencySearchField;
                                                  });
                                                },
                                                icon: const Icon(Icons.close))),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                        SizedBox(
                          height: showAgency ? 12 : 0,
                        ),
                        ////SHOW CATEGORY AGENCY
                        SlideInLeft(
                          child: SizedBox(
                            child: showAgency
                                ? SearchField(
                                    focusNode: agencyCategoryFocusNode,
                                    itemHeight: 70,
                                    suggestions: state.agencyCategory
                                        .map((Category category) =>
                                            SearchFieldListItem(category.name!,
                                                item: category,
                                                child: ListTile(
                                                  title: Text(category.name!),
                                                  subtitle: Text(category
                                                      .industryClass!.name!),
                                                )))
                                        .toList(),
                                    emptyWidget: Container(
                                      height: 100,
                                      decoration: box1(),
                                      child: const Center(
                                          child: Text("No result found ...")),
                                    ),
                                    onSuggestionTap: (agencyCategory) {
                                      setState(() {
                                        selectedAgencyCategory =
                                            agencyCategory.item;
                                        agencyCategoryFocusNode.unfocus();
                                        selectedAgency = Agency(
                                            id: null,
                                            name: selectedAgency!.name,
                                            category: selectedAgencyCategory,
                                            privateEntity: null);
                                      });
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
                                  )
                                : const SizedBox(),
                          ),
                        ),

                        ////PRVIATE SECTOR
                        SlideInLeft(
                          child: SizedBox(
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
                                            const Icon(FontAwesome.help_circled)
                                          ],
                                        ),
                                      ),
                          
                                      ////onvhange private sector
                                      onChanged: (value) {
                                        setState(() {
                                          if (value.toString() == "YES") {
                                            isPrivate = true;
                                            showSalaryGradeAndSalaryStep = false;
                                          } else {
                                            isPrivate = false;
                                            showSalaryGradeAndSalaryStep = true;
                                          }
                                          selectedAgency = Agency(
                                              id: null,
                                              name: selectedAgency!.name,
                                              category: selectedAgencyCategory,
                                              privateEntity: isPrivate
                                                 );
                                          agencyFocusNode.unfocus();
                                          agencyCategoryFocusNode.unfocus();
                                        });
                                       
                                      },
                          
                                      name: 'isPrivate',
                                      validator: FormBuilderValidators.required(),
                                      options: ["YES", "NO"]
                                          .map((lang) =>
                                              FormBuilderFieldOption(value: lang))
                                          .toList(growable: false),
                                    )
                                  : const SizedBox()),
                        ),
                      

                            const SizedBox(
                    height: 12,
                  ),

                  ////POSITIONS
                  StatefulBuilder(builder: (context, setState) {
                    return SlideInLeft(
                      delay: const Duration(milliseconds: 150),
                      child: SearchField(
                        inputFormatters: [UpperCaseTextFormatter()],
                        itemHeight: 70,
                        suggestionsDecoration: searchFieldDecoration(),
                        suggestions: state.agencyPositions
                            .map((PositionTitle position) => SearchFieldListItem(
                                position.title!,
                                item: position,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: ListTile(
                                      title: Text(
                                        position.title!,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ))))
                            .toList(),
                        focusNode: positionFocusNode,
                        searchInputDecoration:
                            normalTextFieldStyle("Position *", "").copyWith(
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
                        ////EMPTY WIDGET
                        emptyWidget: EmptyWidget(
                            title: "Add Position",
                            controller: addPositionController,
                            onpressed: () {
                              setState(() {
                                PositionTitle newAgencyPosition = PositionTitle(
                                    id: null,
                                    title:
                                        addPositionController.text.toUpperCase());
                      
                                state.agencyPositions
                                    .insert(0, newAgencyPosition);
                                selectedPosition = newAgencyPosition;
                                addPositionController.text = "";
                                Navigator.pop(context);
                              });
                            }),
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
                                          delay: const Duration(milliseconds: 170),
                    child: SearchField(
                        inputFormatters: [UpperCaseTextFormatter()],
                        suggestions: state.appointmentStatus
                            .map((AppoinemtStatus status) => SearchFieldListItem(
                                status.label,
                                item: status,
                                child: Padding(
                                    padding: const EdgeInsets.all(8),
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
                        searchInputDecoration:
                            normalTextFieldStyle("Appointment Status", "")
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
           
                  ////MONTHLY SALARY
                  StatefulBuilder(builder: (context, setState) {
                    return Column(
                      children: [
                        SlideInLeft(
                                                delay: const Duration(milliseconds: 190),
                          child: FormBuilderTextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                salary = value;
                              });
                            },
                            validator: numericRequired,
                            name: "salary",
                            decoration: normalTextFieldStyle("Monthly Salary *", "")
                                .copyWith(prefix: const Text("₱ ")),
                          ),
                        ),
                        
                      ],
                    );
                  }),
                       
                        ////SALARY GRADE AND SALARY GRADE STEP
                        SlideInLeft(
                          child: SizedBox(
                              child: showSalaryGradeAndSalaryStep
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Gap(12),
                                        Row(
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              child: FormBuilderTextField(
                                                name: 'salary_grade',
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: normalTextFieldStyle(
                                                    "Salary Grade (SG)", "0"),
                                                onChanged: (value) {
                                                  salaryGrade = value;
                                                },
                                                validator: FormBuilderValidators
                                                    .compose([
                                                  FormBuilderValidators.integer(
                                                      radix: 10,
                                                      errorText:
                                                          "Please enter a number"),
                                                  FormBuilderValidators.numeric(
                                                      errorText:
                                                          "Please enter a number")
                                                ]),
                                                autovalidateMode: AutovalidateMode
                                                    .onUserInteraction,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: FormBuilderTextField(
                                                name: 'salary_step',
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: normalTextFieldStyle(
                                                    "SG Step (SG)", "0"),
                                                validator: FormBuilderValidators
                                                    .compose([
                                                  FormBuilderValidators.integer(
                                                      radix: 10,
                                                      errorText:
                                                          "Please enter a number"),
                                                  FormBuilderValidators.numeric(
                                                      errorText:
                                                          "Please enter a number")
                                                ]),
                                                autovalidateMode: AutovalidateMode
                                                    .onUserInteraction,
                                                onChanged: (value) {
                                                  setState(() {
                                                    salaryGradeStep = value;
                                                  });
                                                },
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SlideInLeft(
                                            delay: const Duration(milliseconds: 210),
                      child: Text(
                        "Immediate SuperVisor",
                        textAlign: TextAlign.start,
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
                      onChanged: (value) {
                        sFname = value;
                      },
                      validator: FormBuilderValidators.required(
                          errorText: "This field is required"),
                      name: 'supervisor_firstname',
                      decoration:
                          normalTextFieldStyle("First name", "First Name"),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SlideInLeft(
                                    delay: const Duration(milliseconds: 250),
                    child: FormBuilderTextField(
                      onChanged: (value) {
                        sMname = value;
                      },
                      name: 'supervisor_middlename',
                      decoration:
                          normalTextFieldStyle("Middle name", "Middle Name"),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SlideInLeft(
                                    delay: const Duration(milliseconds: 270),
                    child: FormBuilderTextField(
                      onChanged: (value) {
                        sLname = value;
                      },
                      validator: FormBuilderValidators.required(
                          errorText: "This field is required"),
                      name: 'supervisor_lastname',
                      decoration: normalTextFieldStyle("Last name", "Last Name"),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //// NAME OF OFFICE UNIT
                  SlideInLeft(
                                    delay: const Duration(milliseconds: 290),
                    child: FormBuilderTextField(
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
                      mainAxisAlignment: MainAxisAlignment.start,
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
                            child: Row(
                              children: [
                                //// FROM DATE
                                Flexible(
                                    flex: 1,
                                    child: DateTimePicker(
                                      validator: FormBuilderValidators.required(
                                          errorText: "This field is required"),
                                      use24HourFormat: false,
                                      icon: const Icon(Icons.date_range),
                                      controller: fromDateController,
                                      firstDate: DateTime(1990),
                                      lastDate: DateTime(2100),
                                      selectableDayPredicate: (date) {
                                        if (to != null &&
                                            to!.microsecondsSinceEpoch <=
                                                date.microsecondsSinceEpoch) {
                                          return false;
                                        }
                                        return true;
                                      },
                                      timeHintText:
                                          "Date of Examination/Conferment",
                                      decoration:
                                          normalTextFieldStyle("From *", "From *")
                                              .copyWith(
                                                  prefixIcon: const Icon(
                                        Icons.date_range,
                                        color: Colors.black87,
                                      )),
                                      onChanged: (value) {
                                        setState(() {
                                          from = DateTime.parse(value);
                                        });
                                      },
                                      initialDate: to == null
                                          ? DateTime.now()
                                          : to!.subtract(const Duration(days: 1)),
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
                                          decoration: normalTextFieldStyle("", "")
                                              .copyWith(),
                                        )
                                      : DateTimePicker(
                                          validator:
                                              FormBuilderValidators.required(
                                                  errorText:
                                                      "This field is required"),
                                          controller: toDateController,
                                          firstDate: DateTime(1990),
                                          lastDate: DateTime(2100),
                                          selectableDayPredicate: (date) {
                                            if (from != null &&
                                                from!.microsecondsSinceEpoch >=
                                                    date.microsecondsSinceEpoch) {
                                              return false;
                                            }
                                            return true;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              to = DateTime.parse(value);
                                            });
                                          },
                                          initialDate: from == null
                                              ? DateTime.now()
                                              : from!
                                                  .add(const Duration(days: 1)),
                                          decoration:
                                              normalTextFieldStyle("To *", "To *")
                                                  .copyWith(
                                                      prefixIcon: const Icon(
                                                        Icons.date_range,
                                                        color: Colors.black87,
                                                      ),
                                                      prefixText:
                                                          currentlyEmployed
                                                              ? "PRESENT"
                                                              : ""),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SlideInLeft(
                                                          delay: const Duration(milliseconds: 330),
                      child: Text(
                        "Work Experience",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SlideInLeft(
                                                        delay: const Duration(milliseconds: 350),
                    child: FormBuilderTextField(
                      maxLines: 3,
                      onChanged: (value) {
                        accomplishment = value;
                      },
                      name: "accomplishment",
                      decoration: normalTextFieldStyle(
                        "List of Accomplishment and Contribution",
                        "Enter items separated by commas",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SlideInLeft(
                                                         delay: const Duration(milliseconds: 370),
                    child: FormBuilderTextField(
                      maxLines: 3,
                      onChanged: (value) {
                        duties = value;
                      },
                      validator: FormBuilderValidators.required(
                          errorText: "This field is required"),
                      name: "summary",
                      decoration: normalTextFieldStyle(
                        "Summary of Actual Duties,",
                        "Enter items separated by commas",
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
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
                      
                            if (_formKey.currentState!.validate()) {
                                       
                              WorkHistory workHistory = WorkHistory(
                                  attachments: null,
                                  accomplishment: null,
                                  actualDuties: null,
                                  agencydepid: null,
                                  supervisor: Supervisor(
                                      agencyId: selectedAgency?.id,
                                      id: null,
                                      lastname: sLname,
                                      firstname: sFname,
                                      middlename: sMname,
                                      stationName: sOffice),
                                  position: selectedPosition,
                                  id: null,
                                  agency: selectedAgency,
                                  fromDate: fromDateController.text.isEmpty
                                      ? null
                                      : DateTime.parse(fromDateController.text),
                                  toDate: toDateController.text.isEmpty ||
                                          toDateController.text.toUpperCase() ==
                                              "PRESENT"
                                      ? null
                                      : DateTime.parse(toDateController.text),
                                  salarygrade: salaryGrade == null
                                      ? null
                                      : int.parse(salaryGrade!),
                                  sgstep: salaryGradeStep == null
                                      ? null
                                      : int.parse(salaryGradeStep!),
                                  monthlysalary: double.parse(salary!),
                                  statusAppointment: selectedStatus!.value);
                              context.read<WorkHistoryBloc>().add(AddWorkHistory(
                                  accomplishment: accomplishment,
                                  actualDuties: duties,
                                  workHistory: workHistory,
                                  profileId: widget.profileId,
                                  token: widget.token,
                                  isPrivate: selectedAgency!.privateEntity!));
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
      return Container();
    });
  }
}
