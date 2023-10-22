import 'package:formz/formz.dart';
import 'package:scandium/core/init/extension/string_extension.dart';
import 'package:scandium/core/init/locale_keys.g.dart';

enum PasswordValidationError { empty, invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  final String passwordRegex = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{7,25}$';

  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    } else if (!RegExp(passwordRegex).hasMatch(value)) {
      return PasswordValidationError.invalid;
    }
    return null;
  }

  String? getErrorMessage() {
    if (!invalid) return null;
    switch (error) {
      case PasswordValidationError.empty:
        return LocaleKeys.generals_emptyFieldText.lcl;
      case PasswordValidationError.invalid:
        return LocaleKeys.pages_login_passwordValidationText.lcl;
      default:
        return null;
    }
  }
}
