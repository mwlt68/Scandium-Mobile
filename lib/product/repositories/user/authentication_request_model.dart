import 'package:scandium/core/base/models/mappable.dart';

class AuthenticationRequestModel extends IToMappable {
  String username;
  String password;
  AuthenticationRequestModel({
    required this.username,
    required this.password,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password': password,
    };
  }
}
