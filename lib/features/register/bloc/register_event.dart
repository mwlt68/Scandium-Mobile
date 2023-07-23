part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterUsernameChanged extends RegisterEvent {
  const RegisterUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class RegisterPasswordChanged extends RegisterEvent {
  const RegisterPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class RegisterPasswordConfirmChanged extends RegisterEvent {
  const RegisterPasswordConfirmChanged(this.passwordConfirm);
  final String passwordConfirm;

  @override
  List<Object> get props => [passwordConfirm];
}

class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted();
}
