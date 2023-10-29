part of 'home_bloc.dart';

class HomeState extends BaseState<HomeState> {
  late List<MessageResponseModel> messages;

  HomeState(
      {List<MessageResponseModel>? messages,
      super.status,
      super.errorKeys,
      super.successfulKeys,
      super.warningKeys,
      super.dialogModel}) {
    this.messages = messages ?? List.empty();
  }

  HomeState copyWith(
      {List<MessageResponseModel>? messages,
      BaseStateStatus? status,
      List<String>? errorKeys,
      List<String>? successfulKeys,
      List<String>? warningKeys,
      BaseBlocDialogModel? dialogModel}) {
    return HomeState(
        messages: messages ?? this.messages,
        dialogModel: dialogModel ?? this.dialogModel,
        errorKeys: errorKeys ?? this.errorKeys,
        successfulKeys: successfulKeys ?? this.successfulKeys,
        warningKeys: warningKeys ?? this.warningKeys,
        status: status ?? this.status);
  }

  @override
  List<Object?> get subProps => [messages];

  @override
  HomeState copyWithBase(
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
