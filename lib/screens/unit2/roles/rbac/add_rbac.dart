import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:unit2/theme-data.dart/box_shadow.dart';

import '../../../../theme-data.dart/btn-style.dart';
import '../../../../theme-data.dart/colors.dart';
import '../../../../theme-data.dart/form-style.dart';

class AddRbac extends StatefulWidget {

final Function() onpressed;
final GlobalKey<FormBuilderState> formKey;
final String title;
  const AddRbac({super.key,required this.title,required this.onpressed, required this.formKey});

  @override
  State<AddRbac> createState() => _AddRbacState();
}

class _AddRbacState extends State<AddRbac> {
  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: box1(),
      child: Column(mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 24,),
        const Text("No result found"),
        const SizedBox(height: 12,),
        TextButton(onPressed: (){
          showDialog(context: context,builder: (BuildContext context) {
            return AlertDialog(
      title:  Text(widget.title),
      content: FormBuilder(
        key: widget.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormBuilderTextField(
              name: "object_name",
              decoration: normalTextFieldStyle("Object name *", "Object name "),
              validator: FormBuilderValidators.required(errorText: "This field is required"),
            ),
            const SizedBox(
              height: 8,
            ),
            FormBuilderTextField(
              name: "slug",
              decoration: normalTextFieldStyle("Slug ", "Slug"),
            ),
            const SizedBox(
              height: 8,
            ),
            FormBuilderTextField(
              name: "shorthand",
              decoration: normalTextFieldStyle("Shorthand ", "Shorthand"),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: mainBtnStyle(primary, Colors.transparent, second),
                    onPressed: widget.onpressed,
                    child: const Text("Add"))),
          ],
        ),
      ),
    );
          });
        }, child: Text(widget.title))
      ],
      ),
    );
  }
}
