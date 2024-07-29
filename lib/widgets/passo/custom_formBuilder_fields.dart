import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:unit2/theme-data.dart/form-style.dart';

Widget customTextField(String labelText, String hintText, String keyText) {
  return Container(
    margin: const EdgeInsets.only(left: 0, top: 10, right: 0, bottom: 0),
    child: FormBuilderTextField(
      name: keyText,
      decoration: normalTextFieldStyle(labelText, hintText),
      validator: FormBuilderValidators.compose([]),
    ),
  );
}

Widget customDropDownField(String labelText, String hintText, String keyText,
    List<String> dropdownItems) {
  // Create a Set to keep track of unique values
  Set<String> uniqueItems = {};

  // Iterate through the dropdownItems list to filter out duplicates
  for (var item in dropdownItems) {
    uniqueItems.add(item);
  }

  // Convert the Set back to a List to use for DropdownMenuItem
  List<String> filteredItems = uniqueItems.toList();

  return Container(
    margin: const EdgeInsets.only(left: 0, top: 10, right: 0, bottom: 0),
    child: FormBuilderDropdown<String?>(
      name: keyText,
      autofocus: false,
      decoration: normalTextFieldStyle(labelText, hintText),
      items: filteredItems
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
    ),
  );
}

Widget customDatTimePicker(String labelText, String hintText, String keyText) {
  return Container(
    margin: const EdgeInsets.only(left: 0, top: 10, right: 0, bottom: 0),
    child: FormBuilderDateTimePicker(
      name: keyText,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialValue: DateTime.now(),
      inputType: InputType.date,
      decoration: normalTextFieldStyle(labelText, hintText),
      initialTime: const TimeOfDay(hour: 8, minute: 0),
      // locale: const Locale.fromSubtags(languageCode: 'fr'),
    ),
  );
}
