part of 'select_contact_bloc.dart';

class SelectContactState extends BaseState<SelectContactState> {
  SelectContactState(
      {this.users,
      super.status,
      super.errorKeys,
      super.successfulKeys,
      super.warningKeys,
      super.dialogModel});

  final List<UserResponseModel>? users;

  SelectContactState copyWith(
      {List<UserResponseModel>? users,
      BaseStateStatus? status,
      List<String>? errorKeys,
      List<String>? successfulKeys,
      List<String>? warningKeys,
      BaseBlocDialogModel? dialogModel}) {
    return SelectContactState(
        users: users ?? this.users,
        dialogModel: dialogModel ?? this.dialogModel,
        errorKeys: errorKeys ?? this.errorKeys,
        successfulKeys: successfulKeys ?? this.successfulKeys,
        warningKeys: warningKeys ?? this.warningKeys,
        status: status ?? this.status);
  }

  @override
  SelectContactState copyWithBase(
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

  @override
  List<Object?> get subProps => [users];
}
