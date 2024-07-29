import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:unit2/bloc/sos/sos_bloc.dart';
import 'package:unit2/screens/sos/components/mobile.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/text_container.dart';

import '../../../theme-data.dart/btn-style.dart';
import '../../../theme-data.dart/form-style.dart';
import '../../../utils/global.dart';
import 'edit_mobile.dart';

class RequestSOS extends StatefulWidget {
  const RequestSOS({super.key});

  @override
  State<RequestSOS> createState() => _RequestSOSState();
}

class _RequestSOSState extends State<RequestSOS> {
  final formKey = GlobalKey<FormBuilderState>();
    DateFormat dteFormat = DateFormat("y-M-d H:m:s");

    String? mobileNumber1;
        String? mobileNumber2;
  @override
  Widget build(BuildContext context) {
     return BlocBuilder<SosBloc, SosState>(
        builder: (context, state) {
          if(state is RequestSosState){
              return SingleChildScrollView(
            child: Container(
                height: screenHeight * .82,
                padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 10),
                child: FormBuilder(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: blockSizeVertical * 2,
                      ),
                      SvgPicture.asset(
                        'assets/svgs/request_sos.svg',
                        height: blockSizeVertical * 22,
                        allowDrawingOutsideViewBox: true,
                      ),
                      Mobile(
                          title: state.mobile1,
                          subtitle: mobile1,
                          //// edit modal
                                onPressed: () {
                                  showBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return EditMobile(
                                          title: "Edit Mobile 1",
                                          label: "Mobile number 1",
                                          initialValue: state.mobile1,
                                          onchanged: (value) {
                                            mobileNumber1 = value;
                                          },
                                          onpressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            BlocProvider.of<SosBloc>(context)
                                                .add(SubmitMobile(
                                                    mobile1: mobileNumber1!,
                                                    mobile2: state.mobile2));
                                          },
                                        );
                                      });
                                },),
                      const Divider(),
                      ////edit mobile 2
                      Mobile(
                          title: state.mobile2??"N/A",
                          subtitle: mobile2,
                          onPressed: () {
                              showBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return EditMobile(
                                          title: "Edit Mobile 2",
                                          label: "Mobile number 2",
                                          initialValue: state.mobile2??'',
                                          onchanged: (value) {
                                            mobileNumber2 = value;
                                          },
                                          onpressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            BlocProvider.of<SosBloc>(context)
                                                .add(SubmitMobile(
                                                    mobile1: state.mobile1,
                                                    mobile2: mobileNumber2));
                                          },
                                        );
                                      });
                          }),
                      const Divider(),
                      ListTile(
                        leading: const Icon(
                          Typicons.location,
                          color: second,
                        ),
                        title: Text("${state.locationData.latitude}/${state.locationData.longitude}"),
                        subtitle: Text(
                          currentLocation,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      FormBuilderTextField(
                        name: "message",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: messageRequired)
                        ]),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLines: 5,
                        decoration: normalTextFieldStyle("", sosMessage),
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * .06,
                        child: ElevatedButton(
                          style: secondaryBtnStyle(
                              primary, Colors.transparent, Colors.white54),
                          child: const Text(
                            submit,
                            style: TextStyle(color: Colors.white),
                          ),
                          //// on pressed
                          onPressed: () async{
                           if( formKey.currentState!.saveAndValidate()){
                            String message = formKey.currentState!.value['message'];
                                DateTime today = DateTime.now();
                                        String requestedDate =
                                            dteFormat.format(today);
                                            BlocProvider.of<SosBloc>(context).add(SendSOS(msg: message, requestDate: requestedDate));

                           }
                       
                          },
                        ),
                      ),
                    ],
                  ),
                )),
          );
          }
        return Container();
        },
    );
  }
}
