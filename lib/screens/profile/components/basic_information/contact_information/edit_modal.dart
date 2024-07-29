import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:unit2/bloc/profile/primary_information/contact/contact_bloc.dart';
import 'package:unit2/model/profile/basic_information/contact_information.dart';
import 'package:unit2/sevices/profile/contact_services.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/theme-data.dart/form-style.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/modal_progress_hud.dart';
import '../../../../../theme-data.dart/colors.dart';

class EditContactInformationScreen extends StatefulWidget {
  final int profileId;
  final String token;
  const EditContactInformationScreen(
      {super.key, required this.profileId, required this.token});

  @override
  State<EditContactInformationScreen> createState() =>
      _EditContactInformationScreenState();
}

class _EditContactInformationScreenState
    extends State<EditContactInformationScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  ServiceType? selectedServiceType;
  CommService? selectedCommProvider;
  List<CommService> commServiceProviders = [];
  String? numberMail;
  bool callServiceType = false;
  bool? primaryaContact;
  bool? active;

  var mobileFormatter = MaskTextInputFormatter(
      mask: "+63 (###) ###-####",
     filter: {"#": RegExp(r'^[0-9][0-9]*$')},
      type: MaskAutoCompletionType.lazy,
      initialText: "0");

  var landLineFormatter = MaskTextInputFormatter(
      mask: "(###) ###-###",
      filter: {"#": RegExp(r"^[0-9]")},
      type: MaskAutoCompletionType.lazy,
      initialText: "0");

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
        if (state is ContactEditingState) {
          selectedServiceType = state.selectedServiceType;
          selectedCommProvider = state.selectedProvider;
          commServiceProviders = state.commServiceProviders;
          primaryaContact = state.contactInfo.primary;
          active = state.contactInfo.active;
          numberMailController.text = state.contactInfo.numbermail!;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: FormBuilder(
                key: formKey,
                child: ListView(
                  children: [
                    StatefulBuilder(builder: (context, setState) {
                      return Column(children: [
                        ////Service Type
                        SlideInLeft(
                          child: DropdownButtonFormField<ServiceType>(
                              isExpanded: true,
                              validator: FormBuilderValidators.required(
                                  errorText: "This field is required"),
                              value: selectedServiceType,
                              items: state.serviceTypes
                                  .map<DropdownMenuItem<ServiceType>>(
                                      (ServiceType e) {
                                return DropdownMenuItem<ServiceType>(
                                    value: e, child: Text(e.name!));
                              }).toList(),
                              decoration:
                                  normalTextFieldStyle("Service Type*", ""),
                              onChanged: (var service) async {
                                if (selectedServiceType!.id != service!.id) {
                                  selectedServiceType = service;
                                  setState(() {
                                    callServiceType = true;
                                    callServiceType = true;
                          
                                    numberMailController.text = "";
                                  });
                                  try {
                                    commServiceProviders = await ContactService
                                        .instance
                                        .getServiceProvider(
                                            serviceTypeId:
                                                selectedServiceType!.id!);
                                  } catch (e) {
                                    context.read<ContactBloc>().add(
                                        CallErrorEvent(message: e.toString()));
                                  }
                                  selectedCommProvider = null;
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
                                  value: selectedCommProvider,
                                  validator: FormBuilderValidators.required(
                                      errorText: "This field is required"),
                                  items: commServiceProviders.isEmpty
                                      ? []
                                      : commServiceProviders
                                          .map<DropdownMenuItem<CommService>>(
                                              (CommService e) {
                                          return DropdownMenuItem<CommService>(
                                              value: e,
                                              child: Text(e.serviceProvider!
                                                  .agency!.name!));
                                        }).toList(),
                                  decoration: normalTextFieldStyle(
                                      "Communication Service *", ""),
                                  onChanged: (var commServiceProvider) {
                                    selectedCommProvider = commServiceProvider;
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
                                      name: 'number-mail',
                                      inputFormatters: [landLineFormatter],
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
                                                       delay: const Duration(milliseconds: 140),
                                      child: FormBuilderTextField(
                                          keyboardType: TextInputType.number,
                                          controller: numberMailController,
                                          name: 'number-mail',
                                          inputFormatters: [mobileFormatter],
                                          validator:
                                              FormBuilderValidators.required(
                                                  errorText:
                                                      "This field is required"),
                                          decoration: normalTextFieldStyle(
                                              "Mobile number *",
                                              "+63 (9xx) xxx - xxxx"),
                                              
                                        ),
                                    )
                                    : selectedServiceType!.id == 4
                                        ////Social Media
                                        ? SlideInLeft(
                                                           delay: const Duration(milliseconds: 160),
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
                                                               delay: const Duration(milliseconds: 180),
                                              child: FormBuilderTextField(
                                                  keyboardType: TextInputType.emailAddress,
                                                  controller:
                                                      numberMailController,
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
                                                  decoration:
                                                      normalTextFieldStyle(
                                                          "Email Address*", ""),
                                                ),
                                            )
                                            : Container()
                            : const SizedBox(),
                      ]);
                    }),
                    SizedBox(
                      height: selectedServiceType != null ? 12 : 0,
                    ),
                    //// Primary
                    StatefulBuilder(builder: (context, setState) {
                      return SlideInLeft(
                                         delay: const Duration(milliseconds: 200),
                        child: FormBuilderSwitch(
                          initialValue: primaryaContact,
                          activeColor: second,
                          onChanged: (value) {
                            setState(() {
                              primaryaContact = value;
                            });
                          },
                          decoration: normalTextFieldStyle("", ''),
                          name: 'primary',
                          title: const Text("Primary ?"),
                        ),
                      );
                    }),
                    //// Active
                    const SizedBox(
                      height: 12,
                    ),
                    SlideInLeft(
                                       delay: const Duration(milliseconds: 220),
                      child: StatefulBuilder(builder: (context, setState) {
                        return FormBuilderSwitch(
                          initialValue: active,
                          activeColor: second,
                          onChanged: (value) {
                            setState(() {
                              active = value;
                            });
                          },
                          decoration: normalTextFieldStyle("", ''),
                          name: 'active',
                          title: const Text("Active ?"),
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: SlideInUp(
                                         delay: const Duration(milliseconds: 220),
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.saveAndValidate()) {
                              numberMail =
                                  formKey.currentState!.value['number-mail'];
                              CommService commService = selectedCommProvider!;
                              ContactInfo contactInfo = ContactInfo(
                                  id: state.contactInfo.id,
                                  active: active,
                                  primary: primaryaContact,
                                  numbermail: numberMail,
                                  commService: commService);
                              final progress = ProgressHUD.of(context);
                              progress!.showWithText("Loading...");
                              context.read<ContactBloc>().add(
                                  EditContactInformation(
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
                    )
                  ],
                )),
          );
        }
        return Container();
      },
    );
  }
}
