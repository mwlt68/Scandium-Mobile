import 'package:scandium/core/base/models/mappable.dart';
import 'package:scandium/product/models/response/user_response_model.dart';

class MessageResponseModel implements IFromMappable {
  String? id;
  UserResponseModel? sender;
  UserResponseModel? receiver;
  String? content;
  DateTime? createDate;
  bool didTransmit;
  MessageResponseModel(
      {this.id,
      this.sender,
      this.receiver,
      this.content,
      this.createDate,
      this.didTransmit = true});

  @override
  MessageResponseModel fromMap(Map<String, dynamic> map) {
    return MessageResponseModel(
      id: map['id'] != null ? map['id'] as String : null,
      sender: map['sender'] != null
          ? UserResponseModel.fromMap(map['sender'] as Map<String, dynamic>)
          : null,
      receiver: map['receiver'] != null
          ? UserResponseModel.fromMap(map['receiver'] as Map<String, dynamic>)
          : null,
      content: map['content'] != null ? map['content'] as String : null,
      createDate:
          map['createDate'] != null ? DateTime.parse(map['createDate']) : null,
    );
  }

  bool get isSenderAndReceiverIdNull =>
      sender?.id == null || receiver?.id == null;

  String? getOtherUserName(String? currentUserId) {
    if (currentUserId != null && !isSenderAndReceiverIdNull) {
      return currentUserId == sender?.id
          ? receiver?.username
          : sender?.username;
    }
    return null;
  }

  String? getOtherUserId(String? currentUserId) {
    if (currentUserId != null && !isSenderAndReceiverIdNull) {
      return currentUserId == sender?.id ? receiver?.id : sender?.id;
    }
    return null;
  }
}

extension MessageResponseModelExtension on MessageResponseModel {
  bool isSameOther(MessageResponseModel other) {
    bool hasNullValue =
        isSenderAndReceiverIdNull || other.isSenderAndReceiverIdNull;
    if (hasNullValue) {
      return false;
    } else {
      return (sender!.id == other.sender!.id &&
              receiver!.id == other.receiver!.id) ||
          (receiver!.id == other.sender!.id &&
              sender!.id == other.receiver!.id);
    }
  }
}

extension MessageResponseModelsExtension on List<MessageResponseModel> {
  bool anyOther(MessageResponseModel other) {
    return any((element) => element.isSameOther(other));
  }
}
