import 'dart:convert';

class UserModel {
  UserModel({this.id, this.name, this.email});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return UserModel(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  int id;
  String name;
  String email;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }



  String toJson() => json.encode(toMap());

}
