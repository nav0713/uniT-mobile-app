import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:unit2/bloc/sos/sos_bloc.dart';
import 'package:unit2/theme-data.dart/text-styles.dart';
import 'package:unit2/utils/screen_info.dart';
import '../../../theme-data.dart/btn-style.dart';
import '../../../theme-data.dart/colors.dart';
import '../../../theme-data.dart/form-style.dart';
import '../../../utils/global.dart';
import '../../../utils/text_container.dart';
import '../../../utils/validators.dart';
import '../../../widgets/wave.dart';

class AddMobile extends StatelessWidget {
  AddMobile({super.key});
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
 
    return BlocBuilder<SosBloc, SosState>(
        builder: (context, state) {
          if(state is UserLocationLoaded){
     return SingleChildScrollView(
            child: SizedBox(
              height: screenHeight * .95,
              child: Stack(
                children: [
        
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: WaveReverse(height: blockSizeVertical * 8)),
                  Container(
                    height: screenHeight,
                    padding: isMobile()
                        ? const EdgeInsets.symmetric(horizontal: 60)
                        : const EdgeInsets.symmetric(horizontal: 60),
                    width: double.infinity,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                  const SizedBox(height: 100,),
                          SvgPicture.asset(
                            'assets/svgs/add_mobile.svg',
                            height: isMobile()
                                ? blockSizeVertical * 22
                                : blockSizeVertical * 30,
                            allowDrawingOutsideViewBox: true,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(addMobile,textAlign: TextAlign.center, style: titleTextStyle()),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(addMobileCaption,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(
                            height: 24,
                          ),
                          FormBuilder(
                              key: _formKey,
                              child: Column(
                                children: [
                                  //// Mobile number 1
                                  FormBuilderTextField(
                                    keyboardType: const TextInputType.numberWithOptions(),
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                      name: 'mobile1',
                                      validator: mobileNumberValidator,
                                      maxLength: 11,
                                      decoration:
                                          normalTextFieldStyle(mobile1, "+639000000000")),
                              
                                  //// Mobile number 2
                                  FormBuilderTextField(
                         
                                           keyboardType: const TextInputType.numberWithOptions(),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      name: 'mobile2',
                                   
                                      decoration:
                                          normalTextFieldStyle(mobile2, "+639000000000")),
    
                                  const SizedBox(height: 30,),
                                  SizedBox(
                                    width: double.infinity,
                                    height: screenHeight * .06,
                                    child: ElevatedButton(
                                      style: secondaryBtnStyle(primary,
                                          Colors.transparent, Colors.white54),
                                      child: const Text(
                                        submit,
                                        style: TextStyle(color: Colors.white),
                                      ),//// on pressed
                                      onPressed: () {
                                        if (_formKey.currentState!
                                            .saveAndValidate()) {
                                              String mobile1 = _formKey.currentState!.value['mobile1'];
                                                  String? mobile2 = _formKey.currentState!.value['mobile2'];
                                          context.read<SosBloc>().add(SubmitMobile(mobile1: mobile1, mobile2: mobile2));
                                        }
    
                                        // }
                                      },
                                    ),
                                  ),
                                ],
                              ))
                        ]),
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
