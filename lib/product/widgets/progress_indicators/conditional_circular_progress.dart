import 'package:flutter/material.dart';

class ConditionalCircularProgress extends StatelessWidget {
  ConditionalCircularProgress(
      {required this.child,
      required this.isLoading,
      this.hasMessage = false,
      this.message,
      this.defaultMessage,
      super.key});
  bool? isLoading;
  bool? hasMessage;
  String? message;
  String? defaultMessage;
  Widget child;
  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (hasMessage == true) {
      return Center(
        child: Text(message ?? defaultMessage ?? ''),
      );
    } else {
      return child;
    }
  }
}
