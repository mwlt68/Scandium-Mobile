class UserResponseModel {
  String? id;
  String? username;

  UserResponseModel({
    required this.id,
    required this.username,
  });

  factory UserResponseModel.fromMap(Map<String, dynamic> map) {
    return UserResponseModel(
      id: map['id'] != null ? map['id'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
    );
  }
}
