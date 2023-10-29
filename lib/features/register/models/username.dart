import 'package:formz/formz.dart';
import 'package:scandium/core/init/extension/string_extension.dart';
import 'package:scandium/core/init/locale_keys.g.dart';

enum UsernameValidationError { empty, invalid }

class Username extends FormzInput<String, UsernameValidationError> {
  final String regex = r'^[A-Za-z\d]{7,}$';
  const Username.pure() : super.pure('');
  const Username.dirty([super.value = '']) : super.dirty();

  @override
  UsernameValidationError? validator(String value) {
    if (value.isEmpty) return UsernameValidationError.empty;
    if (!RegExp(regex).hasMatch(value)) return UsernameValidationError.invalid;
    return null;
  }

  String? getErrorMessage() {
    if (!invalid) return null;
    switch (error) {
      case UsernameValidationError.empty:
        return LocaleKeys.generals_emptyFieldText.lcl;
      case UsernameValidationError.invalid:
        return LocaleKeys.pages_login_usernameValidationText.lcl;
      default:
        return null;
    }
  }
}
