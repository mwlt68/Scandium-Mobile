import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scandium/product/models/response/message_response_model.dart';
import 'package:scandium/product/repositories/message/message_repository.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
      {required UserRepository userRepository,
      required MessageRepository messageRepository})
      : _userRepository = userRepository,
        _messageRepository = messageRepository,
        super(const HomeLoading()) {
    on<LogOutSubmitted>(_onLogOut);
    on<LoadHomeEvent>(_onLoadHome);
  }

  final UserRepository _userRepository;
  final MessageRepository _messageRepository;

  Future _onLogOut(
    LogOutSubmitted event,
    Emitter<HomeState> emit,
  ) async {
    await _userRepository.logOut();
  }

  Future _onLoadHome(
    LoadHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    final messagesResponse = await _messageRepository.getLastMessages();
    if (messagesResponse?.value != null && messagesResponse!.hasNotError) {
      emit(HomeLoadedState(messages: messagesResponse.value!));
    } else {
      emit(HomeErrorState(messagesResponse!.errorMessage));
    }
  }
}
