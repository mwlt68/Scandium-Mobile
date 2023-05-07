import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandium/features/authentication/bloc/bloc/authentication_bloc.dart';
import 'package:scandium/features/home/view/home_page.dart';
import 'package:scandium/features/login/view/login_page.dart';
import 'package:scandium/features/splash/splash_page.dart';
import 'package:scandium/product/constants/application_constants.dart';
import 'package:scandium/product/network/product_network_manager.dart';
import 'product/repositories/user/user_repository.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final UserRepository _userRepository;

  @override
  void initState() {
    super.initState();
    _userRepository = UserRepository(ProductNetworkManager());
  }

  @override
  void dispose() {
    _userRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _userRepository,
      child: BlocProvider(
          create: (context) =>
              AuthenticationBloc(userRepository: _userRepository),
          child: const AppView()),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state.user != null) {
              _navigator.pushAndRemoveUntil<void>(
                HomePage.route(),
                (route) => false,
              );
            } else {
              _navigator.pushAndRemoveUntil<void>(
                LoginPage.route(),
                (route) => false,
              );
            }
          },
          child: child,
        );
      },
      theme: ThemeData(
          primaryColor: Color(ApplicationConstants.instance.blueColor),
          appBarTheme: AppBarTheme(
              backgroundColor: Color(ApplicationConstants.instance.blueColor))),
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
