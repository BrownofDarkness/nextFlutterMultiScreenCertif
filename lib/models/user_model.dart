import 'dart:convert';

class UserModel {
  String? id;
  String? pseudo;
  String? email;
  String? password;

  UserModel({
    this.id,
    this.pseudo,
    this.email,
    this.password,
  });

  UserModel copyWith({
    String? id,
    String? pseudo,
    String? email,
    String? password,
  }) =>
      UserModel(
        id: id ?? this.id,
        pseudo: pseudo ?? this.pseudo,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    pseudo: json["pseudo"],
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "pseudo": pseudo,
    "email": email,
    "password": password,
  };
}
