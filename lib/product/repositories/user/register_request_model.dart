import 'package:scandium/core/base/models/mappable.dart';

class RegisterRequestModel extends IToMappable {
  String username;
  String password;
  String passwordConfirm;
  RegisterRequestModel(
    this.username,
    this.password,
    this.passwordConfirm,
  );

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password': password,
      'passwordConfirm': passwordConfirm,
    };
  }
}
