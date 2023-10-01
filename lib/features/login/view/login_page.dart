import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandium/features/login/bloc/login_bloc.dart';
import 'package:scandium/features/login/view/login_form.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) {
            return LoginBloc(
                userRepository: RepositoryProvider.of<UserRepository>(context));
          },
          child: const LoginForm(),
        ),
      ),
    );
  }
}
