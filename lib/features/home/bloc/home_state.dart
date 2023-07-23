part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeLoadedState extends HomeState {
  const HomeLoadedState({required this.messages});
  final List<MessageResponseModel> messages;
}

class HomeLoading extends HomeState {
  const HomeLoading();
  @override
  List<Object> get props => [];
}

class HomeErrorState extends HomeState {
  const HomeErrorState(this.error);

  final String? error;

  @override
  List<Object?> get props => [error];
}
