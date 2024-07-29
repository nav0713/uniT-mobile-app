import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:unit2/bloc/profile/family/family_bloc.dart';
import 'package:unit2/model/profile/family_backround.dart';

import '../../../../../model/utils/position.dart';
import '../../../../../theme-data.dart/btn-style.dart';
import '../../../../../theme-data.dart/colors.dart';
import '../../../../../theme-data.dart/form-style.dart';
import '../../../../../utils/formatters.dart';
import '../../../../../utils/global.dart';
import '../../../../../utils/text_container.dart';

class FatherEditAlert extends StatefulWidget {
  final FamilyBackground familyBackground;
  final List<String> nameExtensions;
  final List<String> gender;
  final List<String> sexes;
  final List<String> bloodType;
  final List<String> civilStatus;
  final String token;
  final int profileId;
  final FamilyBloc familyBloc;

  const FatherEditAlert(
      {super.key,
      required this.familyBackground,
      required this.bloodType,
      required this.civilStatus,
      required this.gender,
      required this.nameExtensions,
      required this.sexes,
      required this.familyBloc,
      required this.profileId,
      required this.token});

  @override
  State<FatherEditAlert> createState() => _FatherEditAlertState();
}

class _FatherEditAlertState extends State<FatherEditAlert> {
  final _formKey = GlobalKey<FormBuilderState>();
  final bdayController = TextEditingController();

  ////selected
  String? selectedExtension;
  String? selectedGender;
  String? selectedSex;
  String? selectedBloodType;
  String? selectedCivilStatus;
  bool deceased = false;

  @override
  void dispose() {
    bdayController.dispose();
    super.dispose();
  }
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
    return AlertDialog(
        title: const Text("Family - Parental Parent"),
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
                          validator: FormBuilderValidators.numeric(errorText: "Number only"),
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
                          validator: FormBuilderValidators.numeric(errorText: "Number only"),
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
                                    company: company,
                                    position: position,
                                    relatedPerson: person,
                                    relationship: relationship,
                                    companyAddress: companyAddress,
                                    emergencyContact: emergnecyContacts,
                                    incaseOfEmergency: incaseOfEmergency,
                                    companyContactNumber: null);
                            Navigator.of(context).pop();

                            widget.familyBloc.add(Updatefamily(
                                familyBackground: familyBackground,
                                profileId: widget.profileId,
                                token: widget.token,
                                relationshipId: 1));
                          }
                        },
                        child: const Text(submit)),
                  ),
                ],
              )),
        ));
  }
}
