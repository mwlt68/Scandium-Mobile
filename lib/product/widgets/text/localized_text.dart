import 'package:flutter/material.dart';
import 'package:scandium/core/init/extension/string_extension.dart';

class LocText extends StatelessWidget {
  const LocText(this.data, {super.key});
  final String data;
  @override
  Widget build(BuildContext context) {
    return Text(data.lcl);
  }
}
