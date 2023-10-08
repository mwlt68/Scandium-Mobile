part of 'login_bloc.dart';

class LoginState extends BaseState<LoginState> {
  LoginState(
      {this.formStatus = FormzStatus.pure,
      this.username = const Username.pure(),
      this.password = const Password.pure(),
      super.errorKeys,
      super.warningKeys,
      super.successfulKeys,
      super.status});

  @override
  List<Object?> get props =>
      super.props +
      [
        formStatus,
        username,
        password,
      ];

  final FormzStatus formStatus;
  final Username username;
  final Password password;

  LoginState copyWith(
      {FormzStatus? formStatus,
      Username? username,
      Password? password,
      String? errorMessage,
      BaseStateStatus? status,
      List<String>? errorKeys,
      List<String>? successfulKeys,
      List<String>? warningKeys}) {
    return LoginState(
        formStatus: formStatus ?? this.formStatus,
        username: username ?? this.username,
        password: password ?? this.password,
        status: status ?? this.status,
        errorKeys: errorKeys ?? this.errorKeys,
        successfulKeys: successfulKeys ?? this.successfulKeys,
        warningKeys: warningKeys ?? this.warningKeys);
  }

  @override
  LoginState copyWithBase(
      {BaseStateStatus? status,
      List<String>? errorKeys,
      List<String>? warningKeys,
      List<String>? successfulKeys}) {
    return copyWith(
        status: status,
        errorKeys: errorKeys,
        successfulKeys: successfulKeys,
        warningKeys: warningKeys);
  }
}
