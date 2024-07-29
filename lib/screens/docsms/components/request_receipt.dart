
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:unit2/screens/docsms/components/doc_info_tile.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/costum_divider.dart';
import 'package:unit2/widgets/text_icon.dart';

import '../../../test_data.dart';
import '../../../theme-data.dart/btn-style.dart';
import '../../../theme-data.dart/form-style.dart';
import '../../../utils/global.dart';

class RequetAutoReceipt extends StatefulWidget {
  const RequetAutoReceipt({super.key});

  @override
  State<RequetAutoReceipt> createState() => _RequetAutoReceiptState();
}

class _RequetAutoReceiptState extends State<RequetAutoReceipt> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primary,
        ),
        body: SingleChildScrollView(
          // ignore: avoid_unnecessary_containers
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const DocInfo(title: "4427", subTitle: documentId),
              const CostumDivider(),
              const DocInfo(title: "Purchase of Diesel", subTitle: documentTitle),
              const CostumDivider(),
              const DocInfo(title: "N/A", subTitle: documentSubject),
              const CostumDivider(),
              const DocInfo(title: "Request for Quotation", subTitle: documentType),
              const CostumDivider(),
              Form(
                child: Column(children: [
                  FormBuilder(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextIcon(title: "Source", icon: Entypo.reply),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              sourceRemarks,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            FormBuilderTextField(
                              name: "remarks",
                              validator:  FormBuilderValidators.required(
                                    errorText: remarksRequired),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              maxLines: 5,
                              decoration: normalTextFieldStyle(
                                  enterRemarks, "..."),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const TextIcon(
                                title: "Destination", icon: Entypo.forward),
                            const SizedBox(
                              height: 8,
                            ),
                            FormBuilderDropdown<String?>(
                                name: 'department',
                                autofocus: false,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: departmentRequired)
                                ]),
                                decoration:
                                    normalTextFieldStyle("Department", ""),
                                items: puroks
                                    .map((purok) => DropdownMenuItem(
                                          value: purok,
                                          child: Text(purok),
                                        ))
                                    .toList()),
                            const SizedBox(
                              height: 12,
                            ),
                            FormBuilderDropdown<String?>(
                                name: 'substation',
                                autofocus: false,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: substationRequired)
                                ]),
                                decoration:
                                    normalTextFieldStyle("Substation", ""),
                                items: puroks
                                    .map((purok) => DropdownMenuItem(
                                          value: purok,
                                          child: Text(purok),
                                        ))
                                    .toList()),
                            const SizedBox(
                              height: 24,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: screenHeight * .06,
                              child: ElevatedButton(
                                style: secondaryBtnStyle(
                                    primary, Colors.transparent, Colors.white54),
                                child: const Text(
                                  requestAutoReceipt,
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!
                                      .saveAndValidate()) {
                                    debugPrint(_formKey
                                        .currentState!.value['remarks']);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )),
                ]),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
