import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandium/features/login/bloc/login_bloc.dart';
import 'package:scandium/features/login/view/login_form.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';
import 'package:scandium/product/widgets/scaffold/base_scaffold_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldBlocListener<LoginBloc, LoginState, LoginEvent>(
      create: (context) => LoginBloc(
          userRepository: RepositoryProvider.of<UserRepository>(context)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: const Padding(
          padding: EdgeInsets.all(12),
          child: LoginForm(),
        ),
      ),
    );
  }
}
