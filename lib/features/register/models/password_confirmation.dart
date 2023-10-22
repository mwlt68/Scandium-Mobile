import 'package:formz/formz.dart';
import 'package:scandium/core/init/extension/string_extension.dart';
import 'package:scandium/core/init/locale_keys.g.dart';

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
        return LocaleKeys.generals_emptyFieldText.lcl;
      case PasswordConfirmationValidationError.mismatch:
        return LocaleKeys.pages_register_passwordConfirmationLabelText.lcl;
      default:
        return null;
    }
  }
}
