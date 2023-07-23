import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:scandium/features/login/view/login_page.dart';
import 'package:scandium/features/register/bloc/register_bloc.dart';
import 'package:scandium/product/constants/application_constants.dart';
import 'package:scandium/product/widgets/conditional_circular_progress.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
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
          const snackBar = SnackBar(
            content: Text('Registration successful please login.'),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
          Future.delayed(
              Duration(milliseconds: snackBar.duration.inMilliseconds), () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (builder) => const LoginPage()),
                (route) => false);
          });
        }
      },
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
            _RegisterButton(),
          ],
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextField(
          key: const Key('registerForm_usernameInput_textField'),
          onChanged: (username) => context
              .read<RegisterBloc>()
              .add(RegisterUsernameChanged(username)),
          decoration: InputDecoration(
              labelText: 'Username',
              errorText: state.username.getErrorMessage()),
        );
      },
      buildWhen: (previous, current) => previous.username != current.username,
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextField(
          key: const Key('registerForm_passwordInput_textField'),
          onChanged: (password) => context
              .read<RegisterBloc>()
              .add(RegisterPasswordChanged(password)),
          decoration: InputDecoration(
              labelText: 'Password',
              errorText: state.password.getErrorMessage()),
        );
      },
      buildWhen: (previous, current) => previous.password != current.password,
    );
  }
}

class _PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextField(
          key: const Key('registerForm_passwordConfirmationInput_textField'),
          onChanged: (passwordConfirmation) => context
              .read<RegisterBloc>()
              .add(RegisterPasswordConfirmChanged(passwordConfirmation)),
          decoration: InputDecoration(
              labelText: 'Password Confirmation',
              errorText: state.passwordConfirm.getErrorMessage()),
        );
      },
      buildWhen: (previous, current) =>
          previous.passwordConfirm != current.passwordConfirm ||
          previous.password != current.password,
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ConditionalCircularProgress(
            isLoading: state.status.isSubmissionInProgress,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (builder) => const LoginPage()),
                        (route) => false);
                  },
                  child: const Text('Login Page'),
                ),
                ElevatedButton(
                  onPressed:
                      state.status.isValidated && state.registered != true
                          ? () {
                              context
                                  .read<RegisterBloc>()
                                  .add(const RegisterSubmitted());
                            }
                          : null,
                  child: const Text('Register'),
                ),
              ],
            ));
      },
    );
  }
}
