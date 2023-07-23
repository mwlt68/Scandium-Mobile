// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:scandium/core/base/models/mappable.dart';

class FollowRequestModel extends IToMappable {
  String? receiverId;
  FollowRequestModel({
    this.receiverId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'receiverId': receiverId,
    };
  }
}
