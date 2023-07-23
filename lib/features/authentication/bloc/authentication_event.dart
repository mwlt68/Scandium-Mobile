part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {
  const AuthenticationEvent();
}

class _AuthenticationStatusChanged extends AuthenticationEvent {
  const _AuthenticationStatusChanged(this.user);
  final User? user;
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}
