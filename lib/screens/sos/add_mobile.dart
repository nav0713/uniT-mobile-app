import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:unit2/theme-data.dart/text-styles.dart';
import 'package:unit2/utils/screen_info.dart';
import '../../theme-data.dart/btn-style.dart';
import '../../theme-data.dart/colors.dart';
import '../../theme-data.dart/form-style.dart';
import '../../utils/global.dart';
import '../../utils/text_container.dart';
import '../../utils/validators.dart';
import '../../widgets/wave.dart';

class AddMobile extends StatelessWidget {
  AddMobile({super.key});
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return PopScope(
     canPop: true,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Add contact info"),
            centerTitle: true,
            backgroundColor: primary,
            elevation: 0,
          ),
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: SizedBox(
              height: screenHeight * .90,
              child: Stack(
                children: [
                  Wave(height: blockSizeVertical * 8),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: WaveReverse(height: blockSizeVertical * 8)),
                  Container(
                    height: screenHeight,
                    padding: isMobile()
                        ? const EdgeInsets.symmetric(horizontal: 24)
                        : const EdgeInsets.symmetric(horizontal: 60),
                    width: double.infinity,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: isMobile()
                                  ? screenHeight * .12
                                  : screenHeight * .20),
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
                          Text(addMobile, style: titleTextStyle()),
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
                                  // Mobile number 1
                                  FormBuilderTextField(
                                      name: 'mobile1',
                                      validator: mobileNumberValidator,
                                      maxLength: 11,
                                      decoration:
                                          normalTextFieldStyle(mobile1, "sfdfsdfsd")),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  FormBuilderTextField(
                                      name: 'mobile2',
                                      maxLength: 11,
                                      decoration:
                                          normalTextFieldStyle(mobile2, "0900000000000")),

                                  SizedBox(
                                      height: isMobile()
                                          ? blockSizeVertical * 3
                                          : blockSizeHorizontal * 5),
                                  SizedBox(
                                    width: double.infinity,
                                    height: screenHeight * .06,
                                    child: ElevatedButton(
                                      style: secondaryBtnStyle(second,
                                          Colors.transparent, Colors.white54),
                                      child: const Text(
                                        submit,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!
                                            .saveAndValidate()) {
                            
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
          ),
        ),
      ),
    );
  }
}
