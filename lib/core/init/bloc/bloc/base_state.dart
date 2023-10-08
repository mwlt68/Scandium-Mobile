// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'base_bloc.dart';

enum BaseStateStatus { loading, success, error }

abstract class BaseState<T extends BaseState<T>> extends Equatable {
  BaseState(
      {BaseStateStatus? status,
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

  @override
  List<Object?> get props => [status, errorKeys, warningKeys, successfulKeys];

  T copyWithBase(
      {BaseStateStatus? status,
      List<String>? errorKeys,
      List<String>? warningKeys,
      List<String>? successfulKeys});

  clear() {
    errorKeys = List.empty();
    successfulKeys = List.empty();
    warningKeys = List.empty();
  }
}
