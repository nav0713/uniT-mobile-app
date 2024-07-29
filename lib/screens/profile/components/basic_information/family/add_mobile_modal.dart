import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../../../theme-data.dart/btn-style.dart';
import '../../../../../theme-data.dart/colors.dart';
import '../../../../../theme-data.dart/form-style.dart';
import '../../../../../utils/formatters.dart';

class AddMobileNumber extends StatelessWidget {
  final Function onPressed;
  final GlobalKey<FormBuilderState> formKey;
  const AddMobileNumber({super.key, required this.onPressed,required this.formKey});

  @override
  
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Emergency Contact Information"),
      content: FormBuilder(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormBuilderTextField(
              keyboardType: TextInputType.number,
              name: 'number_mail',
              inputFormatters: [mobileFormatter],
              validator: FormBuilderValidators.required(
                  errorText: "This field is required"),
              decoration: normalTextFieldStyle(
                  "Mobile number *", "+63 (9xx) xxx - xxxx"),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                style: mainBtnStyle(primary, Colors.transparent, second),
                child: const Text("Submit"),
                onPressed: () {
                  if (formKey.currentState!.saveAndValidate()) {
                   onPressed();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
