import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:searchfield/searchfield.dart';
import '../../../../../bloc/profile/family/family_bloc.dart';
import '../../../../../model/profile/family_backround.dart';
import '../../../../../model/utils/agency.dart';
import '../../../../../model/utils/category.dart';
import '../../../../../model/utils/position.dart';
import '../../../../../theme-data.dart/box_shadow.dart';
import '../../../../../theme-data.dart/btn-style.dart';
import '../../../../../theme-data.dart/colors.dart';
import '../../../../../theme-data.dart/form-style.dart';
import '../../../../../utils/formatters.dart';
import '../../../../../utils/global.dart';
import '../../../../../utils/text_container.dart';
import '../../../shared/add_for_empty_search.dart';

class SpouseEditAlert extends StatefulWidget {
  final List<String> nameExtensions;
  final List<String> gender;
  final List<String> sexes;
  final List<String> bloodType;
  final List<String> civilStatus;
  final List<PositionTitle> positions;
  final List<Agency> agencies;
  final List<Category> category;
  final FamilyBloc familyBloc;
  final String token;
  final int profileId;
  final FamilyBackground familyBackground;

  const SpouseEditAlert(
      {super.key,
      required this.familyBackground,
      required this.token,
      required this.profileId,
      required this.familyBloc,
      required this.bloodType,
      required this.civilStatus,
      required this.agencies,
      required this.category,
      required this.positions,
      required this.gender,
      required this.nameExtensions,
      required this.sexes});

  @override
  State<SpouseEditAlert> createState() => _SpouseEditAlertState();
}

class _SpouseEditAlertState extends State<SpouseEditAlert> {
  final _formKey = GlobalKey<FormBuilderState>();
  final bdayController = TextEditingController();

  ////selected
  String? selectedExtension;
  String? selectedGender;
  String? selectedSex;
  String? selectedBloodType;
  String? selectedCivilStatus;
  PositionTitle? selectedPosition;
  Category? selectedAgencyCategory;
  Agency? selectedAgency;
  bool deceased = false;

  final agencyFocusNode = FocusNode();
  final positionFocusNode = FocusNode();
  final appointmentStatusNode = FocusNode();
  final agencyCategoryFocusNode = FocusNode();

  final addAgencyController = TextEditingController();
  final addPositionController = TextEditingController();
  final oldPositionController = TextEditingController();
  final oldAppointmentStatusController = TextEditingController();
  final oldAgencyController = TextEditingController();
  bool hasOccupation = false;
  bool showAgency = false;
  bool? isPrivate = false;
  bool showIsPrivateRadio = false;
  @override
  Widget build(BuildContext context) {
    selectedExtension = widget.familyBackground.relatedPerson?.nameExtension;
    selectedGender = widget.familyBackground.relatedPerson?.gender;
    selectedSex = widget.familyBackground.relatedPerson?.sex;
    selectedBloodType = widget.familyBackground.relatedPerson?.bloodType;
    selectedCivilStatus = widget.familyBackground.relatedPerson?.civilStatus;
    bdayController.text =
        widget.familyBackground.relatedPerson!.birthdate!.toString();
    deceased = widget.familyBackground.relatedPerson!.deceased!;
    hasOccupation = widget.familyBackground.position != null;
    oldPositionController.text = widget.familyBackground.position == null
        ? ""
        : widget.familyBackground.position!.title!;
    oldAgencyController.text = widget.familyBackground.company == null
        ? ""
        : widget.familyBackground.company!.name!;
    selectedAgency = widget.familyBackground.company == null
        ? null
        : Agency(
            id: widget.familyBackground.company!.id,
            name: widget.familyBackground.company!.name,
            category: widget.familyBackground.company!.category,
            privateEntity: widget.familyBackground.company!.privateEntity);
    return AlertDialog(
        title: const Text("Family - Spouse"),
        contentPadding: const EdgeInsets.all(24),
        content: SingleChildScrollView(
          child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ////name
                  FormBuilderTextField(
                    inputFormatters: [UpperCaseTextFormatter()],
                    initialValue:
                        widget.familyBackground.relatedPerson!.lastName,
                    validator: FormBuilderValidators.required(
                        errorText: "This field is required"),
                    name: "lastname",
                    decoration: normalTextFieldStyle("Last name *", ""),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  //// firstname
                  FormBuilderTextField(
                    inputFormatters: [UpperCaseTextFormatter()],
                    initialValue:
                        widget.familyBackground.relatedPerson!.firstName,
                    name: "firstname",
                    validator: FormBuilderValidators.required(
                        errorText: "This field is required"),
                    decoration: normalTextFieldStyle("First name *", ""),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ////middle name
                  FormBuilderTextField(
                    inputFormatters: [UpperCaseTextFormatter()],
                    initialValue:
                        widget.familyBackground.relatedPerson?.middleName,
                    name: "middlename",
                    decoration: normalTextFieldStyle("Middle name", ""),
                  ),

                  const SizedBox(
                    height: 8,
                  ),
                  //// extension
                  DropdownButtonFormField<String>(
                    value: selectedExtension,
                    decoration: normalTextFieldStyle("Name extension", ""),
                    items: widget.nameExtensions
                        .map((element) => DropdownMenuItem<String>(
                              value: element,
                              child: Text(element),
                            ))
                        .toList(),
                    onChanged: (e) {
                      selectedExtension = e;
                    },
                  ),

                  const SizedBox(
                    height: 8,
                  ),
                  ////Bday
                  DateTimePicker(
                    controller: bdayController,
                    use24HourFormat: false,
                    validator: FormBuilderValidators.required(
                        errorText: "This field is required"),
                    timeHintText: "Birthdate",
                    decoration:
                        normalTextFieldStyle("Birthdate *", "").copyWith(
                            prefixIcon: const Icon(
                      Icons.date_range,
                      color: Colors.black87,
                    )),
                    firstDate: DateTime(1970),
                    lastDate: DateTime(2100),
                    icon: const Icon(Icons.date_range),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: screenWidth,
                    child: Row(children: [
                      Flexible(
                        flex: 1,
                        //// sex
                        child: DropdownButtonFormField<String>(
                          decoration: normalTextFieldStyle("Sex *", ""),
                          value: selectedSex,
                          validator: FormBuilderValidators.required(
                              errorText: "This field is required"),
                          items: widget.sexes
                              .map((element) => DropdownMenuItem<String>(
                                  value: element, child: Text(element)))
                              .toList(),
                          onChanged: (e) {
                            selectedSex = e;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ////gender
                      Flexible(
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: normalTextFieldStyle("Gender", ""),
                          value: selectedGender,
                          items: widget.gender
                              .map((element) => DropdownMenuItem<String>(
                                  value: element, child: Text(element)))
                              .toList(),
                          onChanged: (e) {
                            selectedGender = e;
                          },
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: screenWidth,
                    child: Row(children: [
                      ////Blood Type
                      Flexible(
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: normalTextFieldStyle("Blood type", ""),
                          value: selectedBloodType,
                          items: widget.bloodType
                              .map((element) => DropdownMenuItem<String>(
                                  value: element, child: Text(element)))
                              .toList(),
                          onChanged: (e) {
                            selectedBloodType = e;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      //// Civil Status
                      Flexible(
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: normalTextFieldStyle("Civil status", ""),
                          value: selectedCivilStatus,
                          items: widget.civilStatus
                              .map((element) => DropdownMenuItem<String>(
                                  value: element, child: Text(element)))
                              .toList(),
                          onChanged: (e) {
                            selectedCivilStatus = e;
                          },
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: screenWidth,
                    child: Row(children: [
                      Flexible(
                        flex: 1,
                        ////height
                        child: FormBuilderTextField(
                          initialValue: widget.familyBackground.relatedPerson
                                      ?.heightM ==
                                  null
                              ? null
                              : widget.familyBackground.relatedPerson?.heightM
                                  .toString(),
                          name: "height",
                          validator: FormBuilderValidators.numeric(errorText: "Enter a number"),
                          keyboardType: TextInputType.number,
                          decoration: normalTextFieldStyle("Height (Meter)", ""),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        flex: 1,
                        //// weight
                        child: FormBuilderTextField(
                          initialValue: widget.familyBackground.relatedPerson
                                      ?.weightKg ==
                                  null
                              ? null
                              : widget.familyBackground.relatedPerson?.weightKg
                                  .toString(),
                          name: "weight",
                          validator: FormBuilderValidators.numeric(errorText: "Enter a number"),
                          keyboardType: TextInputType.number,
                          decoration: normalTextFieldStyle("Weight (Kg.)", ""),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ////Deceased
                  SizedBox(
                    width: screenWidth,
                    child: StatefulBuilder(builder: (context, setState) {
                      return FormBuilderSwitch(
                        initialValue: deceased,
                        title: Text(deceased ? "YES" : "NO"),
                        decoration: normalTextFieldStyle("Deceased?", ""),
                        ////onvhange private sector
                        onChanged: (value) {
                          setState(() {
                            deceased = value!;
                          });
                        },

                        name: 'deceased',
                        validator: FormBuilderValidators.required(),
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ////Has Occupation
                  SizedBox(
                    width: screenWidth,
                    child: StatefulBuilder(builder: (context, setState) {
                      return Column(
                        children: [
                          FormBuilderSwitch(
                            initialValue: hasOccupation,
                            title: Text(hasOccupation ? "YES" : "NO"),
                            decoration:
                                normalTextFieldStyle("Has Occupation?", ""),
                            ////onvhange private sector
                            onChanged: (value) {
                              setState(() {
                                hasOccupation = value!;
                                print(hasOccupation);
                              });
                            },

                            name: 'hasOccupation',
                            validator: FormBuilderValidators.required(),
                          ),
                          Container(
                            child: hasOccupation
                                ? Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      StatefulBuilder(
                                          builder: (context, setState) {
                                        ////Position
                                        return SearchField(
                                          inputFormatters: [
                                            UpperCaseTextFormatter()
                                          ],
                                          controller: oldPositionController,
                                          suggestionDirection:
                                              SuggestionDirection.down,
                                          itemHeight: 100,
                                                                             suggestionsDecoration:  searchFieldDecoration(),

                                          suggestions: widget.positions
                                              .map((PositionTitle position) =>
                                                  SearchFieldListItem(
                                                      position.title!,
                                                      item: position,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: ListTile(
                                                            title: Text(position
                                                                .title!,overflow:   TextOverflow
                                                                        .visible,),
                                                          ))))
                                              .toList(),
                                          focusNode: positionFocusNode,
                                          searchInputDecoration:
                                              normalTextFieldStyle(
                                                      "Position *", "")
                                                  .copyWith(
                                                      suffixIcon: IconButton(
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
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
                                          emptyWidget: Container(
                                            padding: const EdgeInsets.only(top: 25),
                                            child: EmptyWidget(
                                                title: "Add Position",
                                                controller: addPositionController,
                                                onpressed: () {
                                                  setState(() {
                                                    PositionTitle newAgencyPosition =
                                                        PositionTitle(
                                                            id: null,
                                                            title:
                                                                addPositionController
                                                                    .text
                                                                    .toUpperCase());
                                          
                                                    widget.positions.insert(
                                                        0, newAgencyPosition);
                                          
                                                    addPositionController.text =
                                                        "";
                                                    Navigator.pop(context);
                                                  });
                                                }),
                                          ),
                                          validator: (position) {
                                            if (position!.isEmpty) {
                                              return "This field is required";
                                            }
                                            return null;
                                          },
                                        );
                                      }),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      StatefulBuilder(
                                          builder: (context, setState) {
                                        return Column(
                                          children: [
                                            ////Company
                                            SearchField(
                                                inputFormatters: [
                                                  UpperCaseTextFormatter()
                                                ],
                                                controller: oldAgencyController,
                                                itemHeight: 100,
                                                suggestionDirection:
                                               SuggestionDirection.down,
                                                focusNode: agencyFocusNode,
                                                suggestions: widget.agencies
                                                    .map((Agency agency) =>
                                                        SearchFieldListItem(
                                                            agency.name!,
                                                            item: agency,
                                                            child: ListTile(
                                                              title: Text(
                                                                agency.name!,
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
                                                searchInputDecoration:
                                                    normalTextFieldStyle(
                                                            "Agency *", "")
                                                        .copyWith(
                                                            suffixIcon:
                                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  onPressed: () {
                                                    agencyFocusNode.unfocus();
                                                  },
                                                )),
                                                onSuggestionTap: (agency) {
                                                  setState(() {
                                                    selectedAgency =
                                                        agency.item;

                                                    if (selectedAgency!
                                                            .privateEntity ==
                                                        null) {
                                                      showIsPrivateRadio = true;
                                                    } else {
                                                      showIsPrivateRadio =
                                                          false;
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
                                                    controller:
                                                        addAgencyController,
                                                    onpressed: () {
                                                      setState(() {
                                                        Agency newAgency = Agency(
                                                            id: null,
                                                            name: addAgencyController
                                                                .text
                                                                .toUpperCase(),
                                                            category: null,
                                                            privateEntity:
                                                                null);

                                                        widget.agencies.insert(
                                                            0, newAgency);
                                                        selectedAgency =
                                                            newAgency;
                                                        addAgencyController
                                                            .text = "";
                                                        showAgency = true;

                                                        showIsPrivateRadio =
                                                            true;

                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    title: "Add Agency")),

                                            SizedBox(
                                              height: showAgency ? 12 : 0,
                                            ),
                                            ////SHOW CATEGORY AGENCY
                                            SizedBox(
                                              child: showAgency
                                                  ? SearchField(
                                                      focusNode:
                                                          agencyCategoryFocusNode,
                                                      itemHeight: 70,
                                                      suggestions: widget
                                                          .category
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
                                                      onSuggestionTap:
                                                          (agencyCategory) {
                                                        setState(() {
                                                          selectedAgencyCategory =
                                                              agencyCategory
                                                                  .item;
                                                          agencyCategoryFocusNode
                                                              .unfocus();
                                                          selectedAgency = Agency(
                                                              id: null,
                                                              name:
                                                                  selectedAgency!
                                                                      .name,
                                                              category:
                                                                  selectedAgencyCategory,
                                                              privateEntity:
                                                                  null);
                                                        });
                                                      },
                                                      searchInputDecoration:
                                                          normalTextFieldStyle(
                                                                  "Category *",
                                                                  "")
                                                              .copyWith(
                                                                  suffixIcon:
                                                                      IconButton(
                                                        icon: const Icon(Icons
                                                            .arrow_drop_down),
                                                        onPressed: () {
                                                          agencyCategoryFocusNode
                                                              .unfocus();
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
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            ////PRVIATE SECTOR
                                            SizedBox(
                                                width: screenWidth,
                                                child: showIsPrivateRadio
                                                    ? FormBuilderSwitch(
                                                        initialValue: isPrivate,
                                                        title: Text(isPrivate!
                                                            ? "YES"
                                                            : "NO"),
                                                        decoration:
                                                            normalTextFieldStyle(
                                                                "Private Entity?",
                                                                ""),
                                                        ////onvhange private sector
                                                        onChanged: (value) {
                                                          setState(() {
                                                            isPrivate = value;
                                                            selectedAgency = Agency(
                                                                id: null,
                                                                name:
                                                                    selectedAgency!
                                                                        .name,
                                                                category:
                                                                    selectedAgencyCategory,
                                                                privateEntity:
                                                                    isPrivate);
                                                            agencyFocusNode
                                                                .unfocus();
                                                            agencyCategoryFocusNode
                                                                .unfocus();
                                                          });
                                                        },

                                                        name: 'isPrivate',
                                                        validator:
                                                            FormBuilderValidators
                                                                .required(),
                                                      )
                                                    : const SizedBox()),

                                            const SizedBox(
                                              height: 8,
                                            ),
                                            ////Company Address
                                            FormBuilderTextField(
                                              initialValue: widget
                                                  .familyBackground
                                                  .companyAddress,
                                              validator: FormBuilderValidators
                                                  .required(
                                                      errorText:
                                                          "This field is required"),
                                              name: "company_address",
                                              decoration: normalTextFieldStyle(
                                                  "Company Address/Business Address *",
                                                  "Company Address/Business Address *"),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            ////Company Tel Number
                                            FormBuilderTextField(
                                              initialValue: widget
                                                  .familyBackground
                                                  .companyContactNumber,
                                              validator: FormBuilderValidators
                                                  .required(
                                                      errorText:
                                                          "This field is required"),
                                              name: "company_tel",
                                              decoration: normalTextFieldStyle(
                                                  "Company /Business Tel./Mobile # *",
                                                  "Company /Business Tel./Mobile # *"),
                                            ),
                                          ],
                                        );
                                      }),
                                    ],
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      );
                    }),
                  ),

                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: screenWidth,
                    height: 50,
                    child: ElevatedButton(
                        style:
                            mainBtnStyle(second, Colors.transparent, primary),
                        onPressed: () {
  
                            if (_formKey.currentState!.saveAndValidate()) {
                              String fname =
                                  _formKey.currentState!.value['firstname'];
                              String lastName =
                                  _formKey.currentState!.value['lastname'];
                              String? mname =
                                  _formKey.currentState?.value['middlename'];
                              String bday = bdayController.text;
                              String? gender = selectedGender == "NONE"
                                  ? null
                                  : selectedGender;
                              String? extension = selectedExtension == "NONE"
                                  ? null
                                  : selectedExtension;
                              String? blood = selectedBloodType == "NONE"
                                  ? null
                                  : selectedBloodType;
                              String? civilStatus =
                                  selectedCivilStatus == "NONE"
                                      ? null
                                      : selectedCivilStatus;
                              String? sex = selectedSex;
                              String? companyAddress = _formKey
                                  .currentState?.value['company_address'];
                              String? companyContactNumber =
                                  _formKey.currentState?.value['company_tel'];
                              Company? company = selectedAgency == null
                                  ? null
                                  : Company(
                                      id: selectedAgency?.id,
                                      name: selectedAgency?.name,
                                      category: selectedAgencyCategory,
                                      privateEntity: isPrivate);
                              PositionTitle? position = selectedPosition;
                              double? height = _formKey
                                          .currentState?.value['height'] ==
                                      null
                                  ? null
                                  : double.tryParse(
                                      _formKey.currentState?.value['height']);
                              double? weight = _formKey
                                          .currentState?.value['weight'] ==
                                      null
                                  ? null
                                  : double.tryParse(
                                      _formKey.currentState?.value['weight']);
                              Relationship relationship = Relationship(
                                  id: 1,
                                  type: "Paternal_Parent",
                                  category: "Family");
                              List<EmergencyContact>? emergnecyContacts;
                              bool incaseOfEmergency = false;
                              RelatedPerson person = RelatedPerson(
                                titlePrefix: null,
                                firstName: fname,
                                maidenName: null,
                                middleName: mname,
                                lastName: lastName,
                                birthdate: DateTime.parse(bday),
                                id: widget.familyBackground.relatedPerson!.id,
                                sex: sex,
                                gender: gender,
                                deceased: deceased,
                                heightM: height,
                                weightKg: weight,
                                esigPath: null,
                                bloodType: blood,
                                photoPath: null,
                                uuidQrcode: null,
                                nameExtension: extension,
                                civilStatus: civilStatus,
                                titleSuffix: null,
                                showTitleId: false,
                              );
                              FamilyBackground familyBackground =
                                  FamilyBackground(
                                      company: hasOccupation ? company : null,
                                      position: hasOccupation ? position : null,
                                      relatedPerson: person,
                                      relationship: relationship,
                                      companyAddress:
                                          hasOccupation ? companyAddress : null,
                                      emergencyContact: emergnecyContacts,
                                      incaseOfEmergency: incaseOfEmergency,
                                      companyContactNumber: hasOccupation
                                          ? companyContactNumber
                                          : null);
                              Navigator.of(context).pop();

                              widget.familyBloc.add(Updatefamily(
                                  familyBackground: familyBackground,
                                  profileId: widget.profileId,
                                  token: widget.token,
                                  relationshipId: 3));
                            }
                          
                        },
                        child: const Text(submit)),
                  ),
                ],
              )),
        ));
  }
}
