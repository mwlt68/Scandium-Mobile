import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:scandium/core/init/extension/string_extension.dart';
import 'package:scandium/core/init/locale_keys.g.dart';
import 'package:scandium/features/login/bloc/login_bloc.dart';
import 'package:scandium/features/register/view/register_page.dart';
import 'package:scandium/product/widgets/progress_indicators/circular_progress_bloc_builder.dart';
part 'login_form_values.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});
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
          _LoginOrRegister(),
        ],
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  final _LoginFormValues _values = _LoginFormValues();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          key: Key(_values.usernameInputKey),
          onChanged: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username)),
          decoration: InputDecoration(
              labelText: LocaleKeys.pages_login_usernameLabelText.lcl,
              errorText: state.username.invalid
                  ? LocaleKeys.pages_login_usernameErrorText.lcl
                  : null),
        );
      },
      buildWhen: (previous, current) => previous.username != current.username,
    );
  }
}

class _PasswordInput extends StatelessWidget {
  final _LoginFormValues _values = _LoginFormValues();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          key: Key(_values.passwordInputKey),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          decoration: InputDecoration(
              labelText: LocaleKeys.pages_login_passwordLabelText.lcl,
              errorText: state.username.invalid
                  ? LocaleKeys.pages_login_passwordErrorText.lcl
                  : null),
          obscureText: true,
        );
      },
      buildWhen: (previous, current) => previous.password != current.password,
    );
  }
}

class _LoginOrRegister extends StatelessWidget {
  final _LoginFormValues _values = _LoginFormValues();

  @override
  Widget build(BuildContext context) {
    return CircularProgressBlocBuilder<LoginBloc, LoginState, LoginEvent>(
      getChild: (c, s) => Column(
        children: [
          _loginButton(s, c),
          _registerRow(c),
        ],
      ),
      buildWhen: (previous, current) =>
          previous.formStatus != current.formStatus,
    );
  }

  Row _registerRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(LocaleKeys.pages_login_registerInfoText.lcl),
        _registerButton(context)
      ],
    );
  }

  TextButton _registerButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const RegisterPage()),
              (route) => false);
        },
        child: Text(LocaleKeys.pages_login_registerPageButtonText.lcl));
  }

  ElevatedButton _loginButton(LoginState state, BuildContext context) {
    return ElevatedButton(
      onPressed: state.formStatus.isValidated
          ? () => context.read<LoginBloc>().add(const LoginSubmitted())
          : null,
      child: Text(LocaleKeys.pages_login_loginButtonText.lcl),
    );
  }
}
