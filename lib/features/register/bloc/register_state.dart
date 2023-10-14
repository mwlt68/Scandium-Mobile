part of 'register_bloc.dart';

class RegisterState extends BaseState<RegisterState> {
  RegisterState(
      {this.formStatus = FormzStatus.pure,
      this.username = const Username.pure(),
      this.password = const Password.pure(),
      this.passwordConfirm = const PasswordConfirmation.pure(),
      this.registered = false,
      super.errorKeys,
      super.successfulKeys,
      super.warningKeys,
      super.dialogModel});

  @override
  List<Object?> get props =>
      super.props + [username, password, passwordConfirm, registered];

  final FormzStatus formStatus;
  final Username username;
  final Password password;
  final PasswordConfirmation passwordConfirm;
  final bool? registered;

  RegisterState copyWith(
      {FormzStatus? formStatus,
      Username? username,
      Password? password,
      PasswordConfirmation? passwordConfirm,
      bool? registered,
      BaseStateStatus? status,
      List<String>? errorKeys,
      List<String>? successfulKeys,
      List<String>? warningKeys,
      BaseBlocDialogModel? dialogModel}) {
    return RegisterState(
        formStatus: formStatus ?? this.formStatus,
        username: username ?? this.username,
        password: password ?? this.password,
        passwordConfirm: passwordConfirm ?? this.passwordConfirm,
        errorKeys: errorKeys ?? this.errorKeys,
        successfulKeys: successfulKeys ?? this.successfulKeys,
        warningKeys: warningKeys ?? this.warningKeys,
        dialogModel: dialogModel ?? this.dialogModel,
        registered: registered ?? this.registered);
  }

  @override
  RegisterState copyWithBase(
      {BaseStateStatus? status,
      List<String>? errorKeys,
      List<String>? warningKeys,
      List<String>? successfulKeys,
      BaseBlocDialogModel? dialogModel}) {
    return copyWith(
        status: status,
        dialogModel: dialogModel,
        errorKeys: errorKeys,
        warningKeys: warningKeys,
        successfulKeys: successfulKeys);
  }
}
