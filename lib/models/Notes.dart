// ignore_for_file: file_names

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

NotesSchema notesSchemaFromJson(String str) =>
    NotesSchema.fromJson(json.decode(str));

String notesSchemaToJson(NotesSchema data) => json.encode(data.toJson());

class NotesSchema {
  ObjectId id;
  ObjectId user;
  String title;
  String description;
  String tag;
  DateTime date;

  NotesSchema({
    required this.id,
    required this.user,
    required this.title,
    required this.description,
    required this.tag,
    required this.date,
  });

  factory NotesSchema.fromJson(Map<String, dynamic> json) => NotesSchema(
        id: json["_id"],
        user: json["user"],
        title: json["title"],
        description: json["description"],
        tag: json["tag"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "title": title,
        "description": description,
        "tag": tag,
        "date": date,
      };
}
