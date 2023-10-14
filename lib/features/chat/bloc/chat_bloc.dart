import 'package:bloc/bloc.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:scandium/core/extensions/list_extension.dart';
import 'package:scandium/core/init/bloc/bloc/base_bloc.dart';
import 'package:scandium/core/init/bloc/model/base_bloc_dialog_model.dart';
import 'package:scandium/product/hub/message_hub.dart';
import 'package:scandium/product/models/response/conversation_reponse_model.dart';
import 'package:scandium/product/models/response/message_response_model.dart';
import 'package:scandium/product/models/response/user_response_model.dart';
import 'package:scandium/product/repositories/message/message_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends BaseBloc<ChatEvent, ChatState> {
  ChatBloc({required MessageRepository messageRepository})
      : _messageRepository = messageRepository,
        super(ChatState()) {
    on<GetConversationEvent>(_onGetConversation);
    on<SendMessageEvent>(_onSendMessageEvent);
    on<ContentChangedEvent>(_onContentChangedEvent);
    on<MessageReceiveEvent>(_onMessageReceiveEvent);
    _messageHub = MessageHub(
        messageReceive: (messageResponse) =>
            {add(MessageReceiveEvent(messageResponse))});
    _messageHub.openChatConnection();
  }

  final MessageRepository _messageRepository;
  late MessageHub _messageHub;

  Future _onMessageReceiveEvent(
      MessageReceiveEvent event, Emitter<ChatState> emit) async {
    var messages = List<ConversationMessageModel>.from(state.messages);
    var messageRes = event.messageResponse;
    var messageModel = ConversationMessageModel(
        id: messageRes.id,
        content: messageRes.content,
        createdAt: messageRes.createDate,
        didTransmit: messageRes.didTransmit,
        receiverId: messageRes.receiver?.id,
        senderId: messageRes.sender?.id);
    messages.add(messageModel);
    emit(state.copyWith(messages: messages));
  }

  Future _onGetConversation(
      GetConversationEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: BaseStateStatus.loading));
    var conversationResponse =
        await _messageRepository.getConversation(event.otherUserId);
    var isSuccessful = emitBaseState(emit, conversationResponse);
    if (isSuccessful) {
      emit(state.copyWith(
          messages: conversationResponse!.value!.messages,
          otherUser: conversationResponse.value!.otherUser,
          currentUser: conversationResponse.value!.currentUser));
    }
  }

  Future _onSendMessageEvent(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    if (state.status != BaseStateStatus.loading && event.content != null) {
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
        emitErrorKeys(emit, conversationResponse?.errorContents);
      }
    }
  }

  Future _onContentChangedEvent(
      ContentChangedEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(content: event.content));
  }
}
