import 'package:empire/core/utilis/validation_error.dart';

class FormValidationResult {
  final Map<String, ValidationError> errors;
  final bool isValid;

  const FormValidationResult({
    required this.errors,
    required this.isValid,
  });

  factory FormValidationResult.valid() {
    return const FormValidationResult(errors: {}, isValid: true);
  }

  factory FormValidationResult.invalid(Map<String, ValidationError> errors) {
    return FormValidationResult(errors: errors, isValid: false);
  }

  ValidationError? getError(String field) => errors[field];
  bool hasError(String field) => errors.containsKey(field);
}