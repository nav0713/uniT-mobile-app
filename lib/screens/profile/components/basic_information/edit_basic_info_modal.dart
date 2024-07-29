import 'package:animate_do/animate_do.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:unit2/bloc/profile/profile_bloc.dart';
import 'package:unit2/model/profile/basic_information/primary-information.dart';
import 'package:unit2/screens/profile/components/basic_information/profile_other_info.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/utils/formatters.dart';
import '../../../../theme-data.dart/colors.dart';
import '../../../../theme-data.dart/form-style.dart';
import '../../../../utils/global.dart';
import '../../../../utils/validators.dart';

class EditBasicProfileInfoScreen extends StatefulWidget {
  final int profileId;
  final String token;
  const EditBasicProfileInfoScreen(
      {super.key, required this.profileId, required this.token});

  @override
  State<EditBasicProfileInfoScreen> createState() =>
      _EditBasicProfileInfoScreenState();
}

final bdayController = TextEditingController();
ProfileOtherInfo? selectedIndigency;
ProfileOtherInfo? selectedEthnicity;
ProfileOtherInfo? selectedReligion;
ProfileOtherInfo? selectedDisability;
ProfileOtherInfo? selectedGender;
String? selectedSex;
String? selectedBloodType;
String? selectedStatus;
String? selectedExtension;
final _formKey = GlobalKey<FormBuilderState>();

class _EditBasicProfileInfoScreenState
    extends State<EditBasicProfileInfoScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is BasicInformationEditingState) {
          bdayController.text = state.primaryInformation.birthdate.toString();
          selectedSex = state.sexes.firstWhere((element) =>
              element.toLowerCase() ==
              state.primaryInformation.sex!.toLowerCase());
          if (state.primaryInformation.bloodType != null &&
              state.primaryInformation.bloodType != "N/A" &&   state.primaryInformation.bloodType != "") {
            selectedBloodType = state.bloodTypes.firstWhere((element) =>
                element.toLowerCase() ==
                state.primaryInformation.bloodType?.toLowerCase());
          }
          if (state.primaryInformation.nameExtension != null &&
              state.primaryInformation.nameExtension != ""  && state.primaryInformation.nameExtension != null) {
            selectedExtension = state.extensions.firstWhere((element) =>
                element.toLowerCase() ==
                state.primaryInformation.nameExtension?.toLowerCase());
          }
          if (state.primaryInformation.gender != null &&
              state.primaryInformation.gender != "N/A") {
            selectedGender = state.genders.firstWhere((element) =>
                element.name!.toLowerCase() ==
                state.primaryInformation.gender?.toLowerCase());
          }
          if (state.primaryInformation.ip != null &&
              state.primaryInformation.ip != "N/A") {
            selectedIndigency = state.indigenous.firstWhere((element) =>
                element.name!.toLowerCase() ==
                state.primaryInformation.ip!.toLowerCase());
          }
          if (state.primaryInformation.ethnicity != null &&
              state.primaryInformation.ethnicity != "N/A") {
            selectedEthnicity = state.ethnicity.firstWhere((element) =>
                element.name!.toLowerCase() ==
                state.primaryInformation.ethnicity!.toLowerCase());
          }
          if (state.primaryInformation.religion != null &&
              state.primaryInformation.religion != "N/A") {
            selectedReligion = state.religion.firstWhere((element) =>
                element.name!.toLowerCase() ==
                state.primaryInformation.religion!.toLowerCase());
          }
          if (state.primaryInformation.disability != null &&
              state.primaryInformation.disability != "N/A") {
            selectedDisability = state.disability.firstWhere((element) =>
                element.name!.toLowerCase() ==
                state.primaryInformation.disability!.toLowerCase());
          }
 if (state.primaryInformation.civilStatus != null && state.primaryInformation.civilStatus != "" && state.primaryInformation.civilStatus != 'N/A') {
            selectedStatus = state.civilStatus.firstWhere((element) =>
                element.toLowerCase() ==
                state.primaryInformation.civilStatus?.toLowerCase());
          }
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  Flexible(
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        FlipInY(
                                            duration: const Duration(milliseconds: 1500),
                          child: FormBuilderTextField(
                            name: "lastname",
                            inputFormatters: [UpperCaseTextFormatter()],
                            initialValue: state.primaryInformation.lastName,
                            decoration: normalTextFieldStyle("Last name *", ""),
                            validator: FormBuilderValidators.required(
                                errorText: "This field is required"),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        FlipInY(
                                            duration: const Duration(milliseconds: 1500),
                          child: FormBuilderTextField(
                            name: "firstname",
                            inputFormatters: [UpperCaseTextFormatter()],
                            initialValue: state.primaryInformation.firstName,
                            decoration: normalTextFieldStyle("First name *", ""),
                            validator: FormBuilderValidators.required(
                                errorText: "This field is required"),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: screenWidth,
                          child: Row(children: [
                            Flexible(
                              flex: 2,
                              child: FlipInY(
                                                  duration: const Duration(milliseconds: 1500),
                                child: FormBuilderTextField(
                                  inputFormatters: [UpperCaseTextFormatter()],
                                  name: "middlename",
                                  initialValue:
                                      state.primaryInformation.middleName ?? '',
                                  decoration:
                                      normalTextFieldStyle("Middle name", ""),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 1,
                              //// name extension
                              child: FlipInY(
                                                  duration: const Duration(milliseconds: 1500),
                                child: DropdownButtonFormField<String>(
                                  value: selectedExtension,
                                  decoration:
                                      normalTextFieldStyle("Name Extension", ""),
                                  items: state.extensions
                                      .map((element) => DropdownMenuItem<String>(
                                          value: element, child: Text(element)))
                                      .toList(),
                                  onChanged: (e) {
                                    selectedExtension = e;
                                  },
                                ),
                              ),
                            )
                          ]),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: screenWidth,
                          child: Row(children: [
                            ////Bday
                            Flexible(
                              flex: 1,
                              child: FlipInY(
                                                  duration: const Duration(milliseconds: 1500),
                                child: DateTimePicker(
                                  controller: bdayController,
                                  use24HourFormat: false,
                                  validator: FormBuilderValidators.required(
                                      errorText: "This field is required"),
                                  timeHintText: "Birthdate",
                                  decoration:
                                      normalTextFieldStyle("Birthdate *", "*")
                                          .copyWith(
                                              prefixIcon: const Icon(
                                    Icons.date_range,
                                    color: Colors.black87,
                                  )),
                                  firstDate: DateTime(1970),
                                  lastDate: DateTime(2100),
                                  icon: const Icon(Icons.date_range),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),

                            ////sex
                            Flexible(
                              flex: 1,
                              child: FlipInY(
                                                  duration: const Duration(milliseconds: 1500),
                                child: FormBuilderDropdown<String>(
                                  initialValue: selectedSex,
                                  decoration: normalTextFieldStyle("Sex *", ""),
                                  name: "sex",
                                  validator: FormBuilderValidators.required(
                                      errorText: "This field is required"),
                                  items: state.sexes
                                      .map((element) => DropdownMenuItem<String>(
                                          value: element, child: Text(element)))
                                      .toList(),
                                  onChanged: (e) {
                                    selectedSex = e;
                                  },
                                ),
                              ),
                            )
                          ]),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: screenWidth,
                          child: Row(children: [
                            ////blood type
                            Flexible(
                              flex: 1,
                              child: FlipInY(
                                                  duration: const Duration(milliseconds: 1500),
                                child: FormBuilderDropdown<String>(
                                  initialValue: selectedBloodType,
                                  validator: FormBuilderValidators.required(
                                      errorText: "This field is required"),
                                  decoration:
                                      normalTextFieldStyle("Blood type *", ""),
                                  name: "bloodtype",
                                  items: state.bloodTypes
                                      .map((element) => DropdownMenuItem<String>(
                                          value: element, child: Text(element)))
                                      .toList(),
                                  onChanged: (e) {
                                    selectedBloodType = e;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            //// civil status
                            Flexible(
                              flex: 1,
                              child: FlipInY(
                                                  duration: const Duration(milliseconds: 1500),
                                child: FormBuilderDropdown<String>(
                                  initialValue: selectedStatus,
                                  decoration:
                                      normalTextFieldStyle("Civil status *", ""),
                                  validator: FormBuilderValidators.required(
                                      errorText: "This field is required"),
                                  name: "extension",
                                  items: state.civilStatus
                                      .map((element) => DropdownMenuItem<String>(
                                          value: element, child: Text(element)))
                                      .toList(),
                                  onChanged: (e) {
                                    selectedStatus = e;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            //// gender
                            Flexible(
                              flex: 1,
                              child: FlipInY(
                                                  duration: const Duration(milliseconds: 1500),
                                child: DropdownButtonFormField<ProfileOtherInfo>(
                                  isExpanded: true,
                                  value: selectedGender,
                                  decoration: normalTextFieldStyle("Gender", ""),
                                  items: state.genders
                                      .map((element) =>
                                          DropdownMenuItem<ProfileOtherInfo>(
                                              value: element,
                                              child: Text(element.name!)))
                                      .toList(),
                                  onChanged: (e) {
                                    selectedGender = e;
                                  },
                                ),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: screenWidth,
                          child: Row(children: [
                            Flexible(
                              flex: 1,
                              child: FlipInY(
                                                  duration: const Duration(milliseconds: 1500),
                                child: FormBuilderTextField(
                                  name: "height",
                                  validator: numericRequired,
                                  initialValue: state.primaryInformation.heightM==null?"N/A":state.primaryInformation.heightM
                                      .toString(),
                                  decoration: normalTextFieldStyle(
                                      "Height (Meter) *", ""),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 1,
                              child: FlipInY(
                                                  duration: const Duration(milliseconds: 1500),
                                child: FormBuilderTextField(
                                  validator: numericRequired,
                                  name: "weigth",
                                  initialValue: state.primaryInformation.weightKg==null?"N/A":state.primaryInformation.weightKg
                                      .toString(),
                                  decoration:
                                      normalTextFieldStyle("Weight (Kg) *", ""),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: screenWidth,
                          child: Row(children: [
                            Flexible(
                              flex: 1,
                              child: FlipInY(
                                                  duration: const Duration(milliseconds: 1500),
                                child: FormBuilderTextField(
                                  name: "prefix",
                                  initialValue: state
                                      .primaryInformation.titlePrefix
                                      .toString()
                                      .toString(),
                                  decoration: normalTextFieldStyle(
                                      "Title Prefix", "Dr.,Atty.,Engr."),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 1,
                              child: FlipInY(
                                                  duration: const Duration(milliseconds: 1500),
                                child: FormBuilderTextField(
                                  name: "suffix",
                                  initialValue:
                                      state.primaryInformation.titleSuffix,
                                  decoration: normalTextFieldStyle(
                                      "Title Suffix", "PhD.,MD.,MS.,CE"),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: screenWidth,
                          child: Row(children: [
                            ////Indigency
                            Flexible(
                              flex: 1,
                              child: FlipInY(
                                                  duration: const Duration(milliseconds: 1500),
                                child: DropdownButtonFormField<ProfileOtherInfo>(
                                  isExpanded: true,
                                  value: selectedIndigency,
                                  decoration:
                                      normalTextFieldStyle("Indigency", ""),
                                  items: state.indigenous
                                      .map((element) =>
                                          DropdownMenuItem<ProfileOtherInfo>(
                                              value: element,
                                              child: Text(element.name!)))
                                      .toList(),
                                  onChanged: (e) {
                                    selectedIndigency = e;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ////Ethnicity
                            Flexible(
                              flex: 1,
                              child: FlipInY(
                                                  duration: const Duration(milliseconds: 1500),
                                child: DropdownButtonFormField<ProfileOtherInfo>(
                                  isExpanded: true,
                                  value: selectedEthnicity,
                                  decoration:
                                      normalTextFieldStyle("Ethnicity", ""),
                                  items: state.ethnicity
                                      .map((element) =>
                                          DropdownMenuItem<ProfileOtherInfo>(
                                              value: element,
                                              child: Text(element.name!)))
                                      .toList(),
                                  onChanged: (e) {
                                    selectedEthnicity = e;
                                                       
                                  },
                                ),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: screenWidth,
                          child: Row(children: [
                            ////religion
                            Flexible(
                              flex: 1,
                              child: FlipInY(
                                                  duration: const Duration(milliseconds: 1500),
                                child: DropdownButtonFormField<ProfileOtherInfo>(
                                  isExpanded: true,
                                  value: selectedReligion,
                                  decoration:
                                      normalTextFieldStyle("Religion", ""),
                                  items: state.religion
                                      .map((element) =>
                                          DropdownMenuItem<ProfileOtherInfo>(
                                              value: element,
                                              child: Text(element.name!)))
                                      .toList(),
                                  onChanged: (e) {
                                    selectedReligion = e;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ////disabilty
                            Flexible(
                              flex: 1,
                              child: FlipInY(
                                                  duration: const Duration(milliseconds: 1500),
                                child: DropdownButtonFormField<ProfileOtherInfo>(
                                  isExpanded: true,
                                  value: selectedDisability,
                                  decoration:
                                      normalTextFieldStyle("Disability", ""),
                                  items: state.disability
                                      .map((element) =>
                                          DropdownMenuItem<ProfileOtherInfo>(
                                              value: element,
                                              child: Text(element.name!)))
                                      .toList(),
                                  onChanged: (e) {
                                    selectedDisability = e;
                                  },
                                ),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: SlideInUp(
                              
                            child: ElevatedButton(
                                style: mainBtnStyle(
                                    primary, Colors.transparent, second),
                                onPressed: () {
                                  if (_formKey.currentState!.saveAndValidate()) {
                                    String lastName =
                                        _formKey.currentState!.value['lastname'];
                                    String firstName =
                                        _formKey.currentState!.value['firstname'];
                                    String? middleName = _formKey
                                        .currentState?.value['middlename'];
                                    String? pref =
                                        _formKey.currentState?.value['prefix'];
                                    String suf =
                                        _formKey.currentState?.value['suffix'];
                                    DateTime birthdate =
                                        DateTime.parse(bdayController.text);
                                    double? hM =
                                        _formKey.currentState!.value['height'] ==
                                                null
                                            ? null
                                            : double.tryParse(_formKey
                                                .currentState?.value['height']);
                                    double? wKg =
                                        _formKey.currentState!.value['weigth'] ==
                                                null
                                            ? null
                                            : double.tryParse(_formKey
                                                .currentState?.value['weigth']);
                                    Profile primaryInformation = Profile(
                                        webuserId: null,
                                        id: state.primaryInformation.id,
                                        lastName: lastName,
                                        firstName: firstName,
                                        middleName: middleName,
                                        nameExtension: selectedExtension,
                                        sex: selectedSex,
                                        birthdate: birthdate,
                                        civilStatus: selectedStatus,
                                        bloodType: selectedBloodType == "NONE"
                                            ? null
                                            : selectedBloodType,
                                        heightM: hM,
                                        weightKg: wKg,
                                        photoPath:
                                            state.primaryInformation.photoPath,
                                        esigPath:
                                            state.primaryInformation.esigPath,
                                        maidenName:
                                            state.primaryInformation.maidenName,
                                        deceased:
                                            state.primaryInformation.deceased,
                                        uuidQrcode:
                                            state.primaryInformation.uuidQrcode,
                                        titlePrefix: pref,
                                        titleSuffix: suf,
                                        showTitleId:
                                            state.primaryInformation.showTitleId,
                                        ethnicity: selectedEthnicity?.name,
                                        disability: selectedDisability?.name,
                                        gender: selectedGender?.name,
                                        religion: selectedReligion?.name,
                                        ip: selectedIndigency?.name);
                              
                                    context.read<ProfileBloc>().add(
                                        EditBasicProfileInformation(
                                            disabilityId: selectedDisability?.id,
                                            ethnicityId: selectedEthnicity?.id,
                                            genderId: selectedGender?.id,
                                            indigencyId: selectedIndigency?.id,
                                            profileId: widget.profileId,
                                            profileInformation:
                                                primaryInformation,
                                            religionId: selectedReligion?.id,
                                            token: widget.token));
                                  }
                                },
                                child: const Text("Submit")),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
