import 'dart:async';
import 'package:flutter/material.dart';

extension ScaffoldSnackbarHelpers on BuildContext {
  void showScaffoldSnackbar({String? text, Color? color}) {
    _getSnackBar(text, color);
  }

  void showDelayedScaffoldSnackbar(
      FutureOr<void> Function()? computation, String? text, Color? color) {
    var snackBar = _getSnackBar(text, color);
    Future.delayed(
        Duration(milliseconds: snackBar.duration.inMilliseconds), computation);
  }

  SnackBar _getSnackBar(String? text, Color? color) {
    var snackBar = SnackBar(
      content: Text(text ?? ''),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
    return snackBar;
  }
}
