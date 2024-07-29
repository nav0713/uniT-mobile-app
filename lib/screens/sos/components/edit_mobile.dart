import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/utils/validators.dart';

import '../../../theme-data.dart/colors.dart';
import '../../../theme-data.dart/form-style.dart';

class EditMobile extends StatelessWidget {
  final String initialValue;
  final String title;
  final String label;
  final Function() onpressed;
  final Function(String?) onchanged;
  const EditMobile(
      {super.key, 
      required this.initialValue,
      required this.label,
      required this.title,
      required this.onpressed,
      required this.onchanged});


  @override
  
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    return Container(
      height: 300,
      padding: const EdgeInsets.all(26),
      child: Stack(
        children: [
          Positioned(
            top: -16,
            right: -10,
            child: IconButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                icon: const Icon(
                  Icons.close,
                  size: 18,
                )),
          ),
          FormBuilder(
            key: formKey,
            child: Column(
              children: [
                Text(title),
                const SizedBox(
                  height: 25,
                ),
                FormBuilderTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  name: "mobile",
                  onChanged: onchanged,
                  validator: mobileNumberValidator,
                  keyboardType: TextInputType.number,
                  initialValue: initialValue,
                  decoration: normalTextFieldStyle(label, label),
                  maxLength: 11,
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                      onPressed: (){
                        if(formKey.currentState!.saveAndValidate()){
                          onpressed();
                        }
                      },
                      style: mainBtnStyle(success2, Colors.transparent, success),
                      child: const Text("Submit")),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
