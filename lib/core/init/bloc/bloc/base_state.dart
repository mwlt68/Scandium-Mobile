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
      [status, errorKeys, warningKeys, successfulKeys, dialogModel];

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
