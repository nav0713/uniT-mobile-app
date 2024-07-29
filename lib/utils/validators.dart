import 'package:form_builder_validators/form_builder_validators.dart';
import '../utils/text_container.dart';

final mobileNumberValidator = FormBuilderValidators.compose([
  FormBuilderValidators.equalLength(11),
  FormBuilderValidators.required(errorText: mobileNumberRequired),
  FormBuilderValidators.numeric(errorText: numericValidator)
]);
final numericRequired = FormBuilderValidators.compose([
  FormBuilderValidators.required(errorText: "This field is required"),
  FormBuilderValidators.numeric(errorText: numericValidator)
]);

final registerPasswordValidator = FormBuilderValidators.compose([
  FormBuilderValidators.required(errorText: "Password is required"),
  FormBuilderValidators.minLength(6,
      errorText: "Password must be equal or greater than 6 characters"),
]);

final integerAndNumeric = FormBuilderValidators.compose([
  FormBuilderValidators.integer(radix: 10, errorText: "Enter a number"),
  FormBuilderValidators.numeric(errorText: "Enter a number")
]);
