import 'package:flutter/material.dart';

extension ScaffoldSnackbarHelpers on BuildContext {
  void showScaffoldSnackbar({String? text, Color? color}) {
    _showScaffoldSnackbar(context: this, text: text, color: color);
  }

  void _showScaffoldSnackbar(
      {required BuildContext context, String? text, Color? color}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(text ?? ''),
        backgroundColor: color,
      ));
  }
}
