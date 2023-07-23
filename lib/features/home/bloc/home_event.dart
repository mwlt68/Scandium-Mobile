part of 'home_bloc.dart';

class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class LogOutSubmitted extends HomeEvent {
  const LogOutSubmitted();
}

class LoadHomeEvent extends HomeEvent {
  List<Object> get props => [];
}
