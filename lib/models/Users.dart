// ignore_for_file: file_names

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

UserSchema userSchemaFromJson(String str) =>
    UserSchema.fromJson(json.decode(str));

String userSchemaToJson(UserSchema data) => json.encode(data.toJson());

class UserSchema {
  UserSchema({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.date,
  });

  ObjectId id;
  String name;
  String email;
  String password;
  DateTime date;

  factory UserSchema.fromJson(Map<String, dynamic> json) => UserSchema(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "password": password,
        "date": date,
      };
}
