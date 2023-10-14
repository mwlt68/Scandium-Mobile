part of 'chat_bloc.dart';

class ChatState extends BaseState<ChatState> {
  ChatState(
      {List<ConversationMessageModel>? messages,
      String? content,
      this.otherUser,
      this.currentUser,
      super.status,
      super.errorKeys,
      super.successfulKeys,
      super.warningKeys,
      super.dialogModel}) {
    this.messages = messages ?? List.empty(growable: true);
    this.content = content ?? '';
  }
  late List<ConversationMessageModel> messages;
  late String content;
  late UserResponseModel? otherUser;
  late UserResponseModel? currentUser;
  ChatState copyWith(
      {List<ConversationMessageModel>? messages,
      UserResponseModel? otherUser,
      UserResponseModel? currentUser,
      String? content,
      BaseStateStatus? status,
      List<String>? errorKeys,
      List<String>? successfulKeys,
      List<String>? warningKeys,
      BaseBlocDialogModel? dialogModel}) {
    return ChatState(
        messages: messages ?? this.messages,
        otherUser: otherUser ?? this.otherUser,
        currentUser: currentUser ?? this.currentUser,
        content: content ?? this.content,
        dialogModel: dialogModel ?? this.dialogModel,
        errorKeys: errorKeys ?? this.errorKeys,
        successfulKeys: successfulKeys ?? this.successfulKeys,
        warningKeys: warningKeys ?? this.warningKeys,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props =>
      super.props + [messages, otherUser, currentUser, content];

  @override
  ChatState copyWithBase(
      {BaseStateStatus? status,
      List<String>? errorKeys,
      List<String>? warningKeys,
      List<String>? successfulKeys,
      BaseBlocDialogModel? dialogModel}) {
    return copyWith(
        status: status,
        dialogModel: dialogModel,
        errorKeys: errorKeys,
        warningKeys: warningKeys,
        successfulKeys: successfulKeys);
  }
}

extension ConversationMessageModelHelpers on ConversationMessageModel {
  bool senderIsCurrentUser(String currentUserId) => currentUserId == senderId;
}
