import 'package:scandium/core/base/models/mappable.dart';

class UserResponseModel implements IFromMappable {
  String? id;
  String? username;

  UserResponseModel({
    this.id,
    this.username,
  });

  factory UserResponseModel.fromMap(Map<String, dynamic> map) {
    return UserResponseModel(
      id: map['id'] != null ? map['id'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
    );
  }

  @override
  IFromMappable fromMap(Map<String, dynamic> map) {
    return UserResponseModel(
      id: map['id'] != null ? map['id'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
    );
  }
}
