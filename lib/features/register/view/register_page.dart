import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandium/core/init/extension/string_extension.dart';
import 'package:scandium/core/init/locale_keys.g.dart';
import 'package:scandium/features/login/view/login_page.dart';
import 'package:scandium/features/register/bloc/register_bloc.dart';
import 'package:scandium/features/register/view/register_form.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';
import 'package:scandium/product/widgets/scaffold/base_scaffold_bloc.dart';
import 'package:scandium/product/widgets/snackbars/scaffold_snackbar.dart';
import 'package:scandium/product/widgets/text/localized_text.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const RegisterPage());
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldBlocListener<RegisterBloc, RegisterState, RegisterEvent>(
        create: (context) {
          return RegisterBloc(
              userRepository: RepositoryProvider.of<UserRepository>(context));
        },
        listener: _registerBlocListener,
        listenWhen: (RegisterState p, RegisterState c) =>
            p.registered != c.registered,
        child: Scaffold(
            appBar: AppBar(
                title: const LocText(LocaleKeys.pages_register_pageTitle)),
            body: const Padding(
              padding: EdgeInsets.all(12),
              child: RegisterForm(),
            )));
  }

  void _registerBlocListener(BuildContext context, RegisterState state) {
    if (state.registered == true) {
      context.showDelayedScaffoldSnackbar(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (builder) => const LoginPage()),
            (route) => false);
      }, LocaleKeys.pages_register_registrationSuccessfulText.lcl,
          Colors.green);
    }
  }
}
