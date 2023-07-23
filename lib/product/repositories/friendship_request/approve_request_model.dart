import 'package:scandium/core/base/models/mappable.dart';

class ApproveRequestModel extends IToMappable {
  String? senderId;
  ApproveRequestModel({
    this.senderId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
    };
  }
}
