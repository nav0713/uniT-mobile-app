import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/global.dart';

confirmAlert(context, Function() yes,String title, String subtitle) {
  AwesomeDialog(
    
    context: context,
    dialogType: DialogType.question,
    borderSide: const BorderSide(
      color: Colors.green,
      width: 0,
    ),
    width: blockSizeHorizontal * 90,
    buttonsBorderRadius: const BorderRadius.all(
      Radius.circular(2),
    ),
    dismissOnTouchOutside: false,
    dismissOnBackKeyPress: false,
    // onDismissCallback: (type) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Dismissed by $type'),
    //     ),
    //   );
    // },
    headerAnimationLoop: false,
    animType: AnimType.bottomSlide,
    title: title,
    desc: subtitle,
    btnOkText: "Yes",
    btnCancelText: "No",
    showCloseIcon: false,
    btnCancelOnPress: () {},
    btnOkOnPress: yes,
  ).show();
}

confirmAlertWithCancel(context, Function() yes,Function() no,String title, String subtitle,) {
  AwesomeDialog(
  
    context: context,
    dialogType: DialogType.question,
    borderSide: const BorderSide(
      color: Colors.green,
      width: 0,
    ),
    width: blockSizeHorizontal * 90,
    buttonsBorderRadius: const BorderRadius.all(
      Radius.circular(2),
    ),
    dismissOnTouchOutside: false,
    dismissOnBackKeyPress: false,
    // onDismissCallback: (type) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Dismissed by $type'),
    //     ),
    //   );
    // },
    headerAnimationLoop: false,
    animType: AnimType.bottomSlide,
    title: title,
    desc: subtitle,
    btnOkText: "Yes",
    btnCancelText: "No",
    showCloseIcon: false,
    btnCancelOnPress: no,
    btnOkOnPress: yes,
  ).show();
}


errorAlert(context, title, description,Function() func) {
  AwesomeDialog(
    dismissOnTouchOutside: false,
    width: blockSizeHorizontal * 90,
    context: context,
    dialogType: DialogType.error,
    animType: AnimType.scale,
    headerAnimationLoop: false,
    title: title,
    desc: description,
    btnOk: SizedBox(height: 50,child: ElevatedButton(onPressed:func, style: mainBtnStyle(primary, Colors.transparent, second), child: const Text("OK")), )
  ).show();
}
successAlert(context, title, description,Function() func) {
  AwesomeDialog(
    dismissOnTouchOutside: false,
    width: blockSizeHorizontal * 90,
    context: context,
    dialogType: DialogType.success,
    animType: AnimType.scale,
    headerAnimationLoop: false,
    title: title,
    desc: description,
    btnOk: SizedBox(height: 50,child: ElevatedButton(style: mainBtnStyle(success2, Colors.transparent, success), onPressed: func, child: const Text("OK")), )
  ).show();
}
okAlert(context,title,description){
   AwesomeDialog(
    dismissOnTouchOutside: false,
    width: blockSizeHorizontal * 90,
    context: context,
    dialogType: DialogType.error,
    animType: AnimType.scale,
    headerAnimationLoop: false,
    title: title,
    desc: description,
    btnOkOnPress: () {},
  ).show();
}
