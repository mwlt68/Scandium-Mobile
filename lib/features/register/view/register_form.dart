import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:scandium/features/login/view/login_page.dart';
import 'package:scandium/features/register/bloc/register_bloc.dart';
import 'package:scandium/product/constants/application_constants.dart';

import '../../../product/widgets/progress_indicators/conditional_circular_progress.dart';
part 'register_form_values.dart';

class RegisterForm extends StatelessWidget {
  RegisterForm({super.key});
  final _RegisterFormValues _values = _RegisterFormValues();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: _registerBlocListener,
      child: Align(
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
      ),
    );
  }

  void _registerBlocListener(context, state) {
    if (state.status.isSubmissionFailure) {
      var snackBar = SnackBar(
        content: Text(state.errorMessage ??
            ApplicationConstants.instance.unexpectedErrorDefaultMessage),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else if (state.registered == true) {
      var snackBar = SnackBar(
        content: Text(_values.registrationSuccessfulText),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      Future.delayed(Duration(milliseconds: snackBar.duration.inMilliseconds),
          () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (builder) => const LoginPage()),
            (route) => false);
      });
    }
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
              labelText: _values.usernameLabelText,
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
              labelText: _values.passwordLabelText,
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
              labelText: _values.passwordConfirmationLabelText,
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
  final _RegisterFormValues _values = _RegisterFormValues();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ConditionalCircularProgress(
            isLoading: state.status.isSubmissionInProgress,
            child: Column(
              children: [
                _registerButton(state, context),
                _loginRow(context),
              ],
            ));
      },
    );
  }

  Row _loginRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(_values.registerInfoText), _loginButton(context)],
    );
  }

  ElevatedButton _registerButton(RegisterState state, BuildContext context) {
    return ElevatedButton(
        onPressed: state.status.isValidated && state.registered != true
            ? () {
                context.read<RegisterBloc>().add(const RegisterSubmitted());
              }
            : null,
        child: Text(_values.registerPageButtonText));
  }

  TextButton _loginButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (builder) => const LoginPage()),
            (route) => false);
      },
      child: Text(_values.loginButtonText),
    );
  }
}
