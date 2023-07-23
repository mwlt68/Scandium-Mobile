import 'package:formz/formz.dart';
import 'package:scandium/product/constants/application_constants.dart';

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
        return ApplicationConstants.instance.emptyFieldText;
      case UsernameValidationError.invalid:
        return "Username can consist of 7 alphanumeric characters.";
      default:
        return null;
    }
  }
}
