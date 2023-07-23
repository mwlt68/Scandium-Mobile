import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandium/features/register/bloc/register_bloc.dart';
import 'package:scandium/features/register/view/register_form.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const RegisterPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) {
            return RegisterBloc(
                userRepository: RepositoryProvider.of<UserRepository>(context));
          },
          child: const RegisterForm(),
        ),
      ),
    );
  }
}
