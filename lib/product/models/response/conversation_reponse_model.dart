import 'package:scandium/product/models/response/user_response_model.dart';

import '../../../core/base/models/mappable.dart';

class ConversationResponseModel implements IFromMappable {
  UserResponseModel? currentUser;
  UserResponseModel? otherUser;
  List<ConversationMessageModel>? messages;
  ConversationResponseModel({
    this.currentUser,
    this.otherUser,
    this.messages,
  });

  @override
  ConversationResponseModel fromMap(Map<String, dynamic> map) {
    return ConversationResponseModel(
        currentUser: map['currentUser'] != null
            ? UserResponseModel.fromMap(
                map['currentUser'] as Map<String, dynamic>)
            : null,
        otherUser: map['otherUser'] != null
            ? UserResponseModel.fromMap(
                map['otherUser'] as Map<String, dynamic>)
            : null,
        messages: map['messages'] != null
            ? (map['messages'] as List)
                .map((e) => ConversationMessageModel().fromMap(e))
                .toList()
            : null);
  }
}

class ConversationMessageModel implements IFromMappable {
  String? id;
  DateTime? createdAt;
  String? senderId;
  String? receiverId;
  String? content;
  bool didTransmit;
  ConversationMessageModel(
      {this.id,
      this.createdAt,
      this.senderId,
      this.receiverId,
      this.content,
      this.didTransmit = false});

  @override
  ConversationMessageModel fromMap(Map<String, dynamic> map) {
    return ConversationMessageModel(
        id: map['id'] != null ? map['id'] as String : null,
        senderId: map['senderId'] != null ? map['senderId'] as String : null,
        receiverId:
            map['receiverId'] != null ? map['receiverId'] as String : null,
        content: map['content'] != null ? map['content'] as String : null,
        createdAt:
            map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
        didTransmit: true);
  }
}
