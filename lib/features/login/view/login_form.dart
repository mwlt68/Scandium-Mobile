import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
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
              labelText: _values.usernameLabelText,
              errorText:
                  state.username.invalid ? _values.usernameErrorText : null),
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
              labelText: _values.passwordLabelText,
              errorText:
                  state.username.invalid ? _values.passwordErrorText : null),
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
      children: [Text(_values.registerInfoText), _registerButton(context)],
    );
  }

  TextButton _registerButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const RegisterPage()),
              (route) => false);
        },
        child: Text(_values.registerPageButtonText));
  }

  ElevatedButton _loginButton(LoginState state, BuildContext context) {
    return ElevatedButton(
      onPressed: state.formStatus.isValidated
          ? () => context.read<LoginBloc>().add(const LoginSubmitted())
          : null,
      child: Text(_values.loginButtonText),
    );
  }
}
