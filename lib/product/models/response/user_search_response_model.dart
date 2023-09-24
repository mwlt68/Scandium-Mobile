import 'package:scandium/core/base/models/mappable.dart';
import 'package:scandium/product/models/response/user_response_model.dart';

class UserSearchResponseModel implements IFromMappable {
  UserResponseModel? userResponseDto;
  String? friendshipRequestId;
  String? receiverId;
  FriendshipRequestStatus? friendshipRequestStatus;
  UserSearchResponseModel({
    this.userResponseDto,
    this.friendshipRequestId,
    this.receiverId,
    this.friendshipRequestStatus,
  });

  @override
  UserSearchResponseModel fromMap(Map<String, dynamic> map) {
    return UserSearchResponseModel(
      friendshipRequestId: map['friendshipRequestId'] != null
          ? map['friendshipRequestId'] as String
          : null,
      userResponseDto: map['userResponseDto'] != null
          ? UserResponseModel.fromMap(
              map['userResponseDto'] as Map<String, dynamic>)
          : null,
      receiverId:
          map['receiverId'] != null ? map['receiverId'] as String : null,
      friendshipRequestStatus: map['friendshipRequestStatus'] != null
          ? FriendshipRequestStatus.values[map['friendshipRequestStatus']]
          : null,
    );
  }
}

enum FriendshipRequestStatus { Following, Follow, Approve, Requested }
