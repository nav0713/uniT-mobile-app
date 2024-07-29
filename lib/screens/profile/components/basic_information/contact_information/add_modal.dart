import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:unit2/bloc/profile/primary_information/contact/contact_bloc.dart';
import 'package:unit2/model/profile/basic_information/contact_information.dart';
import 'package:unit2/sevices/profile/contact_services.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/theme-data.dart/form-style.dart';
import 'package:unit2/utils/global_context.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/modal_progress_hud.dart';

import '../../../../../theme-data.dart/colors.dart';
import '../../../../../utils/formatters.dart';

class AddContactInformationScreen extends StatefulWidget {
  final int profileId;
  final String token;
  const AddContactInformationScreen(
      {super.key, required this.profileId, required this.token});

  @override
  State<AddContactInformationScreen> createState() =>
      _AddContactInformationScreenState();
}

class _AddContactInformationScreenState
    extends State<AddContactInformationScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  ServiceType? selectedServiceType;
  CommService? selectedCommServiceProvider;
  List<CommService> commServiceProviders = [];
  bool callServiceType = false;
  bool primaryaContact = false;
  bool active = false;
  String? numberMail;
  final numberMailController = TextEditingController();

  @override
  void dispose() {
    numberMailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactBloc, ContactState>(
      builder: (context, state) {
        if (state is ContactAddingState) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: FormBuilder(
                key: formKey,
                child: StatefulBuilder(builder: (context, setState) {
                  return ListView(
                    children: [
                      ////Service Type
                      SlideInLeft(
                        child: FormBuilderDropdown<ServiceType>(
                            validator: FormBuilderValidators.required(
                                errorText: "This field is required"),
                            name: "service_type",
                            items: state.serviceTypes
                                .map<DropdownMenuItem<ServiceType>>(
                                    (ServiceType e) {
                              return DropdownMenuItem<ServiceType>(
                                  value: e, child: Text(e.name!));
                            }).toList(),
                            decoration: normalTextFieldStyle("Service Type*", ""),
                            onChanged: (var service) async {
                              if (selectedServiceType != service) {
                                selectedServiceType = service;
                                setState(() {
                                  callServiceType = true;
                                  selectedCommServiceProvider = null;
                                  numberMailController.text = "";
                                });
                        
                                try {
                                  commServiceProviders = await ContactService
                                      .instance
                                      .getServiceProvider(
                                          serviceTypeId:
                                              selectedServiceType!.id!);
                                } catch (e) {
                                  NavigationService.navigatorKey.currentContext!
                                      .read<ContactBloc>()
                                      .add(CallErrorEvent(message: e.toString()));
                                }
                                setState(() {
                                  setState(() {
                                    callServiceType = false;
                                  });
                                });
                              }
                            }),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ////Service Provider
                      SizedBox(
                        height: 60,
                        child: ProgressModalHud(
    
                          inAsyncCall: callServiceType,
                          child: SlideInLeft(
                                         delay: const Duration(milliseconds: 100),
                            child: DropdownButtonFormField<CommService>(
                                isExpanded: true,
                                validator: FormBuilderValidators.required(
                                    errorText: "This field is required"),
                                items: commServiceProviders.isEmpty
                                    ? []
                                    : commServiceProviders
                                        .map<DropdownMenuItem<CommService>>(
                                            (CommService e) {
                                        return DropdownMenuItem<CommService>(
                                            value: e,
                                            child: Text(e
                                                .serviceProvider!.agency!.name!));
                                      }).toList(),
                                decoration: normalTextFieldStyle(
                                    "Communication Service *", ""),
                                onChanged: (var serviceProvider) {
                                  selectedCommServiceProvider = serviceProvider;
                                }),
                          ),
                        ),
                      ),
                      selectedServiceType != null
                          ? selectedServiceType?.id == 2
                              //// Landline
                              ? SlideInLeft(
                                     delay: const Duration(milliseconds: 120),
                                child: FormBuilderTextField(
                                    keyboardType: TextInputType.number,
                                    controller: numberMailController,
                                    inputFormatters: [landLineFormatter],
                                    name: 'number-mail',
                                    validator: FormBuilderValidators.required(
                                        errorText: "This field is required"),
                                    decoration: normalTextFieldStyle(
                                        "Landline number *",
                                        "(area code) xxx - xxxx"),
                                  ),
                              )
                              : selectedServiceType!.id == 1 ||
                                      selectedServiceType!.id == 19
                                  //// Mobile  number
                                  ? SlideInLeft(
                                                delay: const Duration(milliseconds: 120),
                                    child: FormBuilderTextField(
                                        keyboardType: TextInputType.number,
                                        controller: numberMailController,
                                        name: 'number-mail',
                                        inputFormatters: [mobileFormatter],
                                        validator: FormBuilderValidators.required(
                                            errorText: "This field is required"),
                                        decoration: normalTextFieldStyle(
                                            "Mobile number *",
                                            "+63 (9xx) xxx - xxxx").copyWith(helperText: "Please input your mobile number excluding the 0"),
                                      ),
                                  )
                                  : selectedServiceType!.id == 4
                                      ////Social Media
                                      ? SlideInLeft(
                                                    delay: const Duration(milliseconds: 120),
                                        child: FormBuilderTextField(
                                            controller: numberMailController,
                                            name: 'number-mail',
                                            validator:
                                                FormBuilderValidators.required(
                                                    errorText:
                                                        "This field is required"),
                                            decoration: normalTextFieldStyle(
                                                "Account ID / Username *", ""),
                                          ),
                                      )
                                      : selectedServiceType!.id == 3
                                          ////Email Address
                                          ? SlideInLeft(
                                                        delay: const Duration(milliseconds: 120),
                                            child: FormBuilderTextField(
                                                keyboardType: TextInputType.emailAddress,
                                                controller: numberMailController,
                                                name: 'number-mail',
                                                validator: FormBuilderValidators
                                                    .compose([
                                                  FormBuilderValidators.email(
                                                      errorText:
                                                          "Input vaild email"),
                                                  FormBuilderValidators.required(
                                                      errorText:
                                                          "This field is required")
                                                ]),
                                                decoration: normalTextFieldStyle(
                                                    "Email Address*", ""),
                                              ),
                                          )
                                          : Container()
                          : const SizedBox(),
                      SizedBox(
                        height: selectedServiceType != null ? 12 : 0,
                      ),
                      //// Primary
                      SlideInLeft(
                                        delay: const Duration(milliseconds: 140),
                        child: FormBuilderSwitch(
                          initialValue: primaryaContact,
                          activeColor: second,
                          onChanged: (value) {
                            setState(() {
                              primaryaContact = value!;
                            });
                          },
                          decoration:
                              normalTextFieldStyle("Primary?", 'Primary?'),
                          name: 'overseas',
                          title: Text(primaryaContact ? "YES" : "NO"),
                        ),
                      ),
                      //// Active
                      const SizedBox(
                        height: 12,
                      ),
                      SlideInLeft(
                                         delay: const Duration(milliseconds: 160),
                        child: FormBuilderSwitch(
                          initialValue: primaryaContact,
                          activeColor: second,
                          onChanged: (value) {
                            setState(() {
                              active = value!;
                            });
                          },
                          decoration: normalTextFieldStyle("Active?", ''),
                          name: 'overseas',
                          title: Text(active ? "YES" : "NO"),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: SlideInUp(
                                           delay: const Duration(milliseconds: 180),
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.saveAndValidate()) {
                                numberMail =
                                    formKey.currentState!.value['number-mail'];
                                CommService commService =
                                    selectedCommServiceProvider!;
                                ContactInfo contactInfo = ContactInfo(
                                    id: null,
                                    active: active,
                                    primary: primaryaContact,
                                    numbermail: numberMail,
                                    commService: commService);
                                                
                                context.read<ContactBloc>().add(
                                    AddContactInformation(
                                        contactInfo: contactInfo,
                                        profileId: widget.profileId,
                                        token: widget.token));
                              }
                            },
                            style:
                                mainBtnStyle(primary, Colors.transparent, second),
                            child: const Text(submit),
                          ),
                        ),
                      ),
                    ],
                  );
                })),
          );
        }
        return Container();
      },
    );
  }
}
