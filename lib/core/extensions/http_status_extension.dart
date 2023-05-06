import 'dart:io';

extension HttpStatusExtension on int? {
  bool isSuccessful() {
    return this != null &&
        this! >= HttpStatus.ok &&
        this! <= HttpStatus.multipleChoices;
  }
}
