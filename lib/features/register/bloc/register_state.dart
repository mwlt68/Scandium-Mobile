part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState(
      {this.status = FormzStatus.pure,
      this.username = const Username.pure(),
      this.password = const Password.pure(),
      this.passwordConfirm = const PasswordConfirmation.pure(),
      this.registered = false,
      this.errorMessage});

  @override
  List<Object?> get props =>
      [status, username, password, passwordConfirm, errorMessage];

  final FormzStatus status;
  final Username username;
  final Password password;
  final PasswordConfirmation passwordConfirm;
  final bool? registered;
  final String? errorMessage;

  RegisterState copyWith(
      {FormzStatus? status,
      Username? username,
      Password? password,
      PasswordConfirmation? passwordConfirm,
      bool? registered,
      String? errorMessage}) {
    return RegisterState(
        status: status ?? this.status,
        username: username ?? this.username,
        password: password ?? this.password,
        passwordConfirm: passwordConfirm ?? this.passwordConfirm,
        errorMessage: errorMessage ?? this.errorMessage,
        registered: registered ?? this.registered);
  }
}
