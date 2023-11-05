// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  final int? oid;
  final String? email;
  final String? password;
  String? apiStatus;

  Users({
    this.oid,
    this.email,
    this.password,
    this.apiStatus,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    oid: json["oid"],
    email: json["email"],
    password: json["password"],
    apiStatus: json["apiStatus"],
  );

  Map<String, dynamic> toJson() => {
    "oid": oid,
    "email": email,
    "password": password,
    "apiStatus": apiStatus,
  };
}
