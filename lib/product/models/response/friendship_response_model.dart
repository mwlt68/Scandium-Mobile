import 'package:scandium/core/base/models/mappable.dart';
import 'package:scandium/product/models/response/user_response_model.dart';

class FriendshipResponseModel implements IFromMappable {
  String? id;
  UserResponseModel? sender;
  UserResponseModel? receiver;
  bool? isApproved;
  DateTime? createDate;
  FriendshipResponseModel({
    this.id,
    this.sender,
    this.receiver,
    this.isApproved,
    this.createDate,
  });

  @override
  FriendshipResponseModel fromMap(Map<String, dynamic> map) {
    return FriendshipResponseModel(
      id: map['id'] != null ? map['id'] as String : null,
      sender: map['sender'] != null
          ? UserResponseModel.fromMap(map['sender'] as Map<String, dynamic>)
          : null,
      receiver: map['receiver'] != null
          ? UserResponseModel.fromMap(map['receiver'] as Map<String, dynamic>)
          : null,
      isApproved: map['isApproved'] != null ? map['isApproved'] as bool : null,
      createDate:
          map['createDate'] != null ? DateTime.parse(map['createDate']) : null,
    );
  }
}
