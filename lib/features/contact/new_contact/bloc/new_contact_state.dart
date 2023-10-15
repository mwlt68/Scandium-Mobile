part of 'new_contact_bloc.dart';

class NewContactState extends BaseState<NewContactState> {
  NewContactState(
      {this.searcResultUsers,
      this.searchValue = '',
      super.status,
      super.errorKeys,
      super.successfulKeys,
      super.warningKeys,
      super.dialogModel});

  final String? searchValue;
  final List<UserSearchResponseModel>? searcResultUsers;

  NewContactState copyWith(
      {String? searchValue,
      List<UserSearchResponseModel>? searcResultUsers,
      BaseStateStatus? status,
      List<String>? errorKeys,
      List<String>? successfulKeys,
      List<String>? warningKeys,
      BaseBlocDialogModel? dialogModel}) {
    return NewContactState(
        searchValue: searchValue ?? this.searchValue,
        searcResultUsers: searcResultUsers ?? this.searcResultUsers,
        dialogModel: dialogModel ?? this.dialogModel,
        errorKeys: errorKeys ?? this.errorKeys,
        successfulKeys: successfulKeys ?? this.successfulKeys,
        warningKeys: warningKeys ?? this.warningKeys,
        status: status ?? this.status);
  }

  @override
  NewContactState copyWithBase(
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
  List<Object?> get subProps => [searcResultUsers, searchValue];
}
