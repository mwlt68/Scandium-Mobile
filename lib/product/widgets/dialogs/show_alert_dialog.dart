import 'package:flutter/material.dart';
import 'package:scandium/core/init/extension/string_extension.dart';
import 'package:scandium/core/init/locale_keys.g.dart';

extension AlertDialogHelpers on BuildContext {
  void showAlertDialog(
      {String? buttonText,
      String? titleText,
      String? contentText,
      bool? isSuccess,
      void Function()? onPressed}) {
    _showAlertDialog(
        context: this,
        buttonText: buttonText,
        contentText: contentText,
        titleText: titleText,
        isSuccess: isSuccess,
        onPressed: onPressed);
  }

  void _showAlertDialog(
      {required BuildContext context,
      String? buttonText,
      String? titleText,
      String? contentText,
      bool? isSuccess,
      void Function()? onPressed}) {
    Widget okButton = TextButton(
      onPressed: onPressed ??
          () {
            Navigator.of(context).pop();
          },
      child: Text(buttonText ?? LocaleKeys.generals_ok.lcl,
          style:
              TextStyle(color: isSuccess == true ? Colors.green : Colors.red)),
    );

    AlertDialog alert = AlertDialog(
      title: Text(titleText ?? ""),
      content: Text(contentText ?? ""),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
