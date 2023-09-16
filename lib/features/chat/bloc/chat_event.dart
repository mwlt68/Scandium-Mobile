part of 'chat_bloc.dart';

class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class GetConversationEvent extends ChatEvent {
  const GetConversationEvent(this.otherUserId);

  final String otherUserId;
  @override
  List<Object?> get props => [otherUserId];
}

class SendMessageEvent extends ChatEvent {
  final String? content;

  const SendMessageEvent(this.content);

  @override
  List<Object?> get props => [content];
}

class ContentChangedEvent extends ChatEvent {
  final String? content;

  const ContentChangedEvent(this.content);

  @override
  List<Object?> get props => [content];
}

class ReceiveMessageEvent extends ChatEvent {
  final ConversationMessageModel conversationMessageModel;
  const ReceiveMessageEvent(this.conversationMessageModel);

  @override
  List<Object?> get props => [conversationMessageModel];
}
