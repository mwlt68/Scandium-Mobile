import 'package:scandium/core/base/models/mappable.dart';

class ApproveRequestModel extends IToMappable {
  String? friendshipRequestId;
  ApproveRequestModel({
    this.friendshipRequestId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'friendshipRequestId': friendshipRequestId,
    };
  }
}
