import 'package:formz/formz.dart';
import 'package:scandium/product/constants/application_constants.dart';

enum PasswordConfirmationValidationError { empty, mismatch }

class PasswordConfirmation
    extends FormzInput<String, PasswordConfirmationValidationError> {
  final String password;
  const PasswordConfirmation.pure({this.password = ''}) : super.pure('');

  const PasswordConfirmation.dirty({required this.password, String value = ''})
      : super.dirty(value);

  @override
  PasswordConfirmationValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordConfirmationValidationError.empty;
    } else if (password != value) {
      return PasswordConfirmationValidationError.mismatch;
    }
    return null;
  }

  String? getErrorMessage() {
    if (!invalid) return null;
    switch (error) {
      case PasswordConfirmationValidationError.empty:
        return ApplicationConstants.instance.emptyFieldText;
      case PasswordConfirmationValidationError.mismatch:
        return "Password confirmation does not match with your password.";
      default:
        return null;
    }
  }
}
