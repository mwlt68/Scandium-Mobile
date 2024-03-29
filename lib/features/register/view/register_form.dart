import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:scandium/core/init/extension/string_extension.dart';
import 'package:scandium/core/init/locale_keys.g.dart';
import 'package:scandium/features/login/view/login_page.dart';
import 'package:scandium/features/register/bloc/register_bloc.dart';
import 'package:scandium/product/widgets/text/localized_text.dart';
import '../../../product/widgets/progress_indicators/circular_progress_bloc_builder.dart';

part 'register_form_values.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -1 / 3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _UsernameInput(),
          const Padding(padding: EdgeInsets.all(12)),
          _PasswordInput(),
          const Padding(padding: EdgeInsets.all(12)),
          _PasswordConfirmationInput(),
          const Padding(padding: EdgeInsets.all(12)),
          _RegisterOrLogin(),
        ],
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  final _RegisterFormValues _values = _RegisterFormValues();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextField(
          key: Key(_values.usernameInputKey),
          onChanged: (username) => context
              .read<RegisterBloc>()
              .add(RegisterUsernameChanged(username)),
          decoration: InputDecoration(
              labelText: LocaleKeys.pages_register_usernameLabelText.lcl,
              errorText: state.username.getErrorMessage()),
        );
      },
      buildWhen: (previous, current) => previous.username != current.username,
    );
  }
}

class _PasswordInput extends StatelessWidget {
  final _RegisterFormValues _values = _RegisterFormValues();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextField(
          key: Key(_values.passwordInputKey),
          onChanged: (password) => context
              .read<RegisterBloc>()
              .add(RegisterPasswordChanged(password)),
          decoration: InputDecoration(
              labelText: LocaleKeys.pages_register_passwordLabelText.lcl,
              errorText: state.password.getErrorMessage()),
          obscureText: true,
        );
      },
      buildWhen: (previous, current) => previous.password != current.password,
    );
  }
}

class _PasswordConfirmationInput extends StatelessWidget {
  final _RegisterFormValues _values = _RegisterFormValues();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextField(
          key: Key(_values.passwordConfimationInputKey),
          onChanged: (passwordConfirmation) => context
              .read<RegisterBloc>()
              .add(RegisterPasswordConfirmChanged(passwordConfirmation)),
          decoration: InputDecoration(
              labelText:
                  LocaleKeys.pages_register_passwordConfirmationLabelText.lcl,
              errorText: state.passwordConfirm.getErrorMessage()),
          obscureText: true,
        );
      },
      buildWhen: (previous, current) =>
          previous.passwordConfirm != current.passwordConfirm ||
          previous.password != current.password,
    );
  }
}

class _RegisterOrLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressBlocBuilder<RegisterBloc, RegisterState,
        RegisterEvent>(
      getChild: (c, s) => Column(
        children: [
          _registerButton(s, context),
          _loginRow(context),
        ],
      ),
      buildWhen: (previous, current) =>
          previous.formStatus != current.formStatus,
    );
  }

  Row _loginRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const LocText(LocaleKeys.pages_register_registerInfoText),
        _loginButton(context)
      ],
    );
  }

  ElevatedButton _registerButton(RegisterState state, BuildContext context) {
    return ElevatedButton(
        onPressed: state.formStatus.isValidated && state.registered != true
            ? () {
                context.read<RegisterBloc>().add(const RegisterSubmitted());
              }
            : null,
        child: const LocText(LocaleKeys.pages_register_registerPageButtonText));
  }

  TextButton _loginButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (builder) => const LoginPage()),
            (route) => false);
      },
      child: const LocText(LocaleKeys.pages_register_loginButtonText),
    );
  }
}
