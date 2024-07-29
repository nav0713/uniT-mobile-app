  import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

var mobileFormatter = MaskTextInputFormatter(
      mask: "+63 (###) ###-####",
      filter: {"#": RegExp(r'^[0-9][0-9]*$')
},
      type: MaskAutoCompletionType.lazy,
      initialText: "0");

  var landLineFormatter = MaskTextInputFormatter(
      mask: "(###) ###-###",
      filter: {"#": RegExp(r"^[0-9]")},
      type: MaskAutoCompletionType.lazy,
      initialText: "0");

      class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}