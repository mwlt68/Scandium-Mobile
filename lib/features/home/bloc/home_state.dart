part of 'home_bloc.dart';

class HomeState extends Equatable {
  final String? error;
  final bool isLoading;
  late List<MessageResponseModel> messages;

  HomeState(
      {List<MessageResponseModel>? messages,
      this.isLoading = false,
      this.error}) {
    this.messages = messages ?? List.empty();
  }

  HomeState copyWith(
      {List<MessageResponseModel>? messages, bool? isLoading, String? error}) {
    return HomeState(
        messages: messages ?? this.messages,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [error, isLoading, messages];
}
