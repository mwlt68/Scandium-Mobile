import 'package:equatable/equatable.dart';
import 'package:scandium/core/base/models/mappable.dart';

class User extends IMappable with EquatableMixin {
  User({this.id, this.username, this.token}) : super();

  final String? id;
  final String? username;
  final String? token;

  @override
  List<Object?> get props => [id];

  @override
  User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      username: map['username'] != null ? map['username'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'token': token,
    };
  }
}
