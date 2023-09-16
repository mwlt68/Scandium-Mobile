import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:scandium/core/extensions/list_extension.dart';
import 'package:scandium/product/hub/message_hub.dart';
import 'package:scandium/product/models/response/conversation_reponse_model.dart';
import 'package:scandium/product/models/response/user_response_model.dart';
import 'package:scandium/product/repositories/message/message_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({required MessageRepository messageRepository})
      : _messageRepository = messageRepository,
        super(ChatState(isLoading: true)) {
    on<GetConversationEvent>(_onGetConversation);
    on<SendMessageEvent>(_onSendMessageEvent);
    on<ContentChangedEvent>(_onContentChangedEvent);
    on<ReceiveMessageEvent>(_onReceiveMessageEvent);
    _messageHub =
        MessageHub(receiveMessage: (a) => {add(ReceiveMessageEvent(a))});
    _messageHub.openChatConnection();
  }

  final MessageRepository _messageRepository;
  late MessageHub _messageHub;

  Future _onReceiveMessageEvent(
      ReceiveMessageEvent event, Emitter<ChatState> emit) async {
    var messages = List<ConversationMessageModel>.from(state.messages);
    messages.add(event.conversationMessageModel);
    emit(state.copyWith(messages: messages));
  }

  Future _onGetConversation(
      GetConversationEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(isLoading: true));
    var conversationResponse =
        await _messageRepository.getConversation(event.otherUserId);
    if (conversationResponse?.value != null &&
        conversationResponse!.hasNotError) {
      emit(state.copyWith(
          messages: conversationResponse.value!.messages,
          otherUser: conversationResponse.value!.otherUser,
          currentUser: conversationResponse.value!.currentUser));
    } else {
      emit(state.copyWith(error: conversationResponse?.errorMessage));
    }
    emit(state.copyWith(isLoading: false));
  }

  Future _onSendMessageEvent(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    if (!state.isLoading && event.content != null) {
      var id = Guid.newGuid.toString();
      var messages = List<ConversationMessageModel>.from(state.messages);

      var conversationModel = ConversationMessageModel(
          id: id,
          content: state.content,
          createdAt: DateTime.now(),
          receiverId: state.otherUser?.id,
          senderId: state.currentUser?.id);
      messages.add(conversationModel);
      var conversationResponse = await _messageRepository.sendMessage(
          state.otherUser!.id!, event.content!);

      if (conversationResponse?.value != null &&
          conversationResponse!.hasNotError) {
        var message = messages.firstOrDefault((element) => element.id == id);
        if (message != null) {
          message.didTransmit = true;
        }
        emit(state.copyWith(messages: messages, content: ''));
      } else {
        emit(state.copyWith(error: conversationResponse?.errorMessage));
      }
    }
  }

  Future _onContentChangedEvent(
      ContentChangedEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(content: event.content));
  }
}
