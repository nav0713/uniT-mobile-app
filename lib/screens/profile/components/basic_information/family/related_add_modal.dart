import 'package:animate_do/animate_do.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../../../bloc/profile/family/family_bloc.dart';
import '../../../../../model/profile/family_backround.dart';
import '../../../../../model/utils/position.dart';
import '../../../../../theme-data.dart/btn-style.dart';
import '../../../../../theme-data.dart/colors.dart';
import '../../../../../theme-data.dart/form-style.dart';
import '../../../../../utils/formatters.dart';
import '../../../../../utils/global.dart';
import '../../../../../utils/text_container.dart';

class RelatedAlert extends StatefulWidget {
  final List<String> nameExtensions;
  final List<String> gender;
  final List<String> sexes;
  final List<String> bloodType;
  final List<String> civilStatus;
  final List<Relationship> relationships;
  final String token;
  final int profileId;
  final FamilyBloc familyBloc;

  const RelatedAlert({
    super.key,
    required this.bloodType,
    required this.token,
    required this.profileId,
    required this.familyBloc,
    required this.civilStatus,
    required this.relationships,
    required this.gender,
    required this.nameExtensions,
    required this.sexes,
  });

  @override
  State<RelatedAlert> createState() => _RelatedAlertState();
}

class _RelatedAlertState extends State<RelatedAlert> {
  final _formKey = GlobalKey<FormBuilderState>();
  final bdayController = TextEditingController();

  ////selected
  String? selectedExtension;
  String? selectedGender;
  String? selectedSex;
  String? selectedBloodType;
  String? selectedCivilStatus;
  Relationship? selectedRelationship;
  bool deceased = false;
@override
  void dispose() {
bdayController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      child: AlertDialog(
          title: const Text("Family - Other Related Person"),
          contentPadding: const EdgeInsets.all(24),
          content: SingleChildScrollView(
            child: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ////Relationship
                    FormBuilderDropdown<Relationship>(
                      decoration: normalTextFieldStyle("Relationship *", ""),
                      name: "extension",
                      validator: FormBuilderValidators.required(
                          errorText: "This field is required"),
                      items: widget.relationships.map(
                        (element) {
                          return DropdownMenuItem<Relationship>(
                            value: element,
                            child: Text(element.type!),
                          );
                        },
                      ).toList(),
                      onChanged: (e) {
                        selectedRelationship = e;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ////name
                    FormBuilderTextField(
                      inputFormatters: [UpperCaseTextFormatter()],
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
                      name: "middlename",
                      decoration: normalTextFieldStyle("Middle name", ""),
                    ),
      
                    const SizedBox(
                      height: 8,
                    ),
                    //// extension
                    FormBuilderDropdown<String>(
                      decoration: normalTextFieldStyle("Name extension", ""),
                      name: "extension",
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
                      firstDate: DateTime(1900),
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
                          child: FormBuilderDropdown<String>(
                            decoration: normalTextFieldStyle("Sex", ""),
                            name: "sex *",
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
                          child: FormBuilderDropdown<String>(
                            decoration: normalTextFieldStyle("Gender", ""),
                            name: "gender",
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
                          child: FormBuilderDropdown<String>(
                            decoration: normalTextFieldStyle("Blood type", ""),
                            name: "bloodtype",
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
                          child: FormBuilderDropdown<String>(
                            decoration: normalTextFieldStyle("Civil status", ""),
                            name: "extension",
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
                            name: "weight",
                            validator:FormBuilderValidators.numeric(errorText: "Enter a number"),
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
      
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: screenWidth,
                      height: 50,
                      child: ElevatedButton(
                          style:
                              mainBtnStyle(primary, Colors.transparent, primary),
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
                              String? civilStatus = selectedCivilStatus == "NONE"
                                  ? null
                                  : selectedCivilStatus;
                              String? sex = selectedSex;
                              Company? company;
                              PositionTitle? position;
                              double? height =
                                  _formKey.currentState?.value['height'] == null
                                      ? null
                                      : double.tryParse(
                                          _formKey.currentState?.value['height']);
                              double? weight =
                                  _formKey.currentState?.value['weight'] == null
                                      ? null
                                      : double.tryParse(
                                          _formKey.currentState?.value['weight']);
                              Relationship relationship = Relationship(
                                  id: 1,
                                  type: "Paternal_Parent",
                                  category: "Family");
                              List<EmergencyContact>? emergnecyContacts;
                              bool incaseOfEmergency = false;
                              String? companyAddress;
                              RelatedPerson person = RelatedPerson(
                                titlePrefix: null,
                                firstName: fname,
                                maidenName: null,
                                middleName: mname,
                                lastName: lastName,
                                birthdate: DateTime.parse(bday),
                                id: null,
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
                                      company: company,
                                      position: position,
                                      relatedPerson: person,
                                      relationship: relationship,
                                      companyAddress: companyAddress,
                                      emergencyContact: emergnecyContacts,
                                      incaseOfEmergency: incaseOfEmergency,
                                      companyContactNumber: null);
                              Navigator.of(context).pop();
      
                              widget.familyBloc.add(AddFamily(
                                  familyBackground: familyBackground,
                                  profileId: widget.profileId,
                                  token: widget.token,
                                  relationshipId: selectedRelationship!.id!));
                            }
                          },
                          child: const Text(submit)),
                    ),
                  ],
                )),
          )),
    );
  }
}
