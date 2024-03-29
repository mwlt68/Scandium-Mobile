// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'base_bloc.dart';

enum BaseStateStatus { loading, success, error }

abstract class BaseState<T extends BaseState<T>> extends Equatable {
  BaseState(
      {this.dialogModel,
      BaseStateStatus? status,
      List<String>? errorKeys,
      List<String>? warningKeys,
      List<String>? successfulKeys}) {
    this.status = status ?? BaseStateStatus.loading;
    this.errorKeys = errorKeys ?? [];
    this.warningKeys = warningKeys ?? [];
    this.successfulKeys = successfulKeys ?? [];
  }

  late BaseStateStatus status;
  late List<String> errorKeys;
  late List<String> warningKeys;
  late List<String> successfulKeys;
  late BaseBlocDialogModel? dialogModel;

  @override
  List<Object?> get props =>
      subProps + [status, errorKeys, warningKeys, successfulKeys, dialogModel];

  List<Object?> get subProps;

  T copyWithBase(
      {BaseStateStatus? status,
      List<String>? errorKeys,
      List<String>? warningKeys,
      List<String>? successfulKeys,
      BaseBlocDialogModel? dialogModel});

  clear() {
    errorKeys = List.empty();
    successfulKeys = List.empty();
    warningKeys = List.empty();
    dialogModel = null;
  }
}

extension BaseStateHelpers<T extends BaseState<T>> on T {
  bool baseStateCompare(T current) =>
      dialogModel != current.dialogModel ||
      errorKeys != current.errorKeys ||
      status != current.status ||
      successfulKeys != current.successfulKeys ||
      warningKeys != current.warningKeys;

  bool get isLoading => status == BaseStateStatus.loading;
  bool get isFailed => status == BaseStateStatus.error;
  bool get isSuccessful => status == BaseStateStatus.error;
}
