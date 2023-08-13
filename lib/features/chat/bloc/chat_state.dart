part of 'chat_bloc.dart';

class ChatState extends Equatable {
  ChatState(
      {List<ConversationMessageModel>? messages,
      String? content,
      this.otherUser,
      this.currentUser,
      this.error,
      this.isLoading = false}) {
    this.messages = messages ?? List.empty(growable: true);
    this.content = content ?? '';
  }
  late List<ConversationMessageModel> messages;
  late String content;
  final UserResponseModel? otherUser;
  final UserResponseModel? currentUser;
  final String? error;
  final bool isLoading;

  ChatState copyWith(
      {List<ConversationMessageModel>? messages,
      UserResponseModel? otherUser,
      UserResponseModel? currentUser,
      String? error,
      String? content,
      bool? isLoading}) {
    return ChatState(
        messages: messages ?? this.messages,
        otherUser: otherUser ?? this.otherUser,
        currentUser: currentUser ?? this.currentUser,
        error: error ?? this.error,
        content: content ?? this.content,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props =>
      [messages, otherUser, currentUser, error, isLoading, content];
}

extension ConversationMessageModelHelpers on ConversationMessageModel {
  bool senderIsCurrentUser(String currentUserId) => currentUserId == senderId;
}
