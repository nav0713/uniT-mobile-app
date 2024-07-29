import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:unit2/theme-data.dart/form-style.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/label.dart';
import '../../../../../test_data.dart';
import '../../../../../theme-data.dart/btn-style.dart';
import '../../../../../theme-data.dart/colors.dart';

class AddPerson extends StatefulWidget {
  const AddPerson({super.key});

  @override
  State<AddPerson> createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson> {
  final _formKey = GlobalKey<FormBuilderState>();

  DateFormat dteFormat = DateFormat("y-M-d");
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SingleChildScrollView(
        child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Label(text: basicInformation),
                //Firstname
                FormBuilderTextField(
                  name: 'firstname',
                  validator: FormBuilderValidators.required(
                      errorText: "First name is required"),
                  autofocus: false,
                  decoration: normalTextFieldStyle("First name", ""),
                  textCapitalization: TextCapitalization.characters,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 10,
                ),
                //Firstname
                FormBuilderTextField(
                    name: 'lastname',
                    validator: FormBuilderValidators.required(
                        errorText: "Middle name is required"),
                    autofocus: false,
                    textCapitalization: TextCapitalization.characters,
                    keyboardType: TextInputType.text,
                    decoration: normalTextFieldStyle("Last name", "")),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: FormBuilderTextField(
                          name: 'middlename',
                          validator: FormBuilderValidators.required(
                              errorText: "Middle name is required"),
                          autofocus: false,
                          textCapitalization: TextCapitalization.characters,
                          keyboardType: TextInputType.text,
                          decoration: normalTextFieldStyle("Middle name", "")),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: DateTimePicker(
                        decoration: normalTextFieldStyle("Birth date", ""),
                        initialValue: '',
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Date',
                        onChanged: (val) => print(val),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Birthdate is required";
                          }
                          return null;
                        },
                        onSaved: (val) => print(val),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: FormBuilderTextField(
                          name: 'extension-name',
                          autofocus: false,
                          textCapitalization: TextCapitalization.characters,
                          keyboardType: TextInputType.text,
                          decoration:
                              normalTextFieldStyle("Extenstion name", "")),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: FormBuilderDropdown<String?>(
                          validator: FormBuilderValidators.required(
                              errorText: "Gender is required"),
                          name: 'gender',
                          autofocus: false,
                          decoration: normalTextFieldStyle("Gender", ""),
                          items: genders
                              .map((gender) => DropdownMenuItem(
                                    value: gender,
                                    child: Text(gender),
                                  ))
                              .toList()),
                    )
                  ],
                ),
                const Label(text: address),
                FormBuilderDropdown<String?>(
                    name: 'region',
                    autofocus: false,
                    validator: FormBuilderValidators.required(
                        errorText: "Region is required"),
                    decoration: normalTextFieldStyle("Region", ""),
                    items: regions
                        .map((region) => DropdownMenuItem(
                              value: region,
                              child: Text(region),
                            ))
                        .toList()),
                const SizedBox(
                  height: 10,
                ),
                FormBuilderDropdown<String?>(
                    name: 'province',
                    autofocus: false,
                    validator: FormBuilderValidators.required(
                        errorText: "Province is required"),
                    decoration: normalTextFieldStyle("Province", ""),
                    items: provinces
                        .map((province) => DropdownMenuItem(
                              value: province,
                              child: Text(province),
                            ))
                        .toList()),
                const SizedBox(
                  height: 10,
                ),
                FormBuilderDropdown<String?>(
                    name: 'municipality',
                    autofocus: false,
                    validator: FormBuilderValidators.required(
                        errorText: "Municipality is required"),
                    decoration: normalTextFieldStyle("Municipalities", ""),
                    items: municipalities
                        .map((municipality) => DropdownMenuItem(
                              value: municipality,
                              child: Text(municipality),
                            ))
                        .toList()),
                const SizedBox(
                  height: 10,
                ),
                FormBuilderDropdown<String?>(
                    name: 'barangay',
                    autofocus: false,
                    validator: FormBuilderValidators.required(
                        errorText: "Barangay is required"),
                    decoration: normalTextFieldStyle("Barangay", ""),
                    items: barangays
                        .map((barangay) => DropdownMenuItem(
                              value: barangay,
                              child: Text(barangay),
                            ))
                        .toList()),
                const SizedBox(
                  height: 10,
                ),
                FormBuilderDropdown<String?>(
                    name: 'purok',
                    autofocus: false,
                    validator: FormBuilderValidators.required(
                        errorText: "Purok is required"),
                    decoration: normalTextFieldStyle("Purok", ""),
                    items: puroks
                        .map((purok) => DropdownMenuItem(
                              value: purok,
                              child: Text(purok),
                            ))
                        .toList()),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * .06,
                  child: ElevatedButton(
                    style: secondaryBtnStyle(
                        second, Colors.transparent, Colors.white54),
                    child: const Text(
                      submit,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      print(_formKey.currentState!.value['firstname']);
                      if (_formKey.currentState!.saveAndValidate()) {}
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            )),
      ),
    );
  }
}
