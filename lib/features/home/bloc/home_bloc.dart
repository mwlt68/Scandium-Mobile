import 'package:bloc/bloc.dart';
import 'package:scandium/core/init/bloc/bloc/base_bloc.dart';
import 'package:scandium/core/init/bloc/extension/emitter_extension.dart';
import 'package:scandium/core/init/bloc/model/base_bloc_dialog_model.dart';
import 'package:scandium/product/hub/message_hub.dart';
import 'package:scandium/product/models/response/message_response_model.dart';
import 'package:scandium/product/repositories/message/message_repository.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  HomeBloc(
      {required UserRepository userRepository,
      required MessageRepository messageRepository})
      : _userRepository = userRepository,
        _messageRepository = messageRepository,
        super(HomeState()) {
    on<LogOutSubmitted>(_onLogOut);
    on<LoadHomeEvent>(_onLoadHome);
    on<MessageReceiveEvent>(_onMessageReceiveEvent);
    _messageHub = MessageHub(messageReceive: addMessageReceiveEvent);
    _messageHub.openChatConnection();
  }

  void addMessageReceiveEvent(messageResponse) =>
      {add(MessageReceiveEvent(messageResponse))};

  final UserRepository _userRepository;
  final MessageRepository _messageRepository;
  late MessageHub _messageHub;

  Future _onLogOut(
    LogOutSubmitted event,
    Emitter<HomeState> emit,
  ) async {
    await _userRepository.logOut();
  }

  Future _onLoadHome(
    LoadHomeEvent event,
    Emitter<HomeState> emitter,
  ) async {
    await emitter.emit(
        state: state,
        requestOperation: _messageRepository.getLastMessages(),
        getSuccessfulState: (messagesResponse) =>
            state.copyWith(messages: messagesResponse.value!));
  }

  Future _onMessageReceiveEvent(
      MessageReceiveEvent event, Emitter<HomeState> emit) async {
    var messages =
        List<MessageResponseModel>.from(state.messages, growable: true);
    bool isMessageExist = messages.anyOther(event.messageResponse);
    if (isMessageExist) {
      messages
          .removeWhere((element) => element.isSameOther(event.messageResponse));
    }
    messages.insert(0, event.messageResponse);
    emit(state.copyWith(messages: messages));
  }
}
