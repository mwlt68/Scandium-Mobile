import 'package:scandium/core/base/models/mappable.dart';

class MessageRequestModel extends IToMappable {
  String receiverId;
  String content;
  MessageRequestModel({required this.receiverId, required this.content});

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{'receiverId': receiverId, 'content': content};
  }
}
