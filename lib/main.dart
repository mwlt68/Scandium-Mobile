import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:scandium/app.dart';
import 'package:scandium/product/constants/application_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('tr')],
      useOnlyLangCode: true,
      fallbackLocale: const Locale('en'),
      path: ApplicationConstants.instance.langPath,
      child: const App()));
}
