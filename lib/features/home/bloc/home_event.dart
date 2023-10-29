part of 'home_bloc.dart';

class HomeEvent extends BaseEvent {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class LogOutSubmitted extends HomeEvent {
  const LogOutSubmitted();
}

class LoadHomeEvent extends HomeEvent {}

class MessageReceiveEvent extends HomeEvent {
  final MessageResponseModel messageResponse;
  const MessageReceiveEvent(this.messageResponse);

  @override
  List<Object> get props => [messageResponse];
}
