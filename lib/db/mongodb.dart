// ignore_for_file: constant_identifier_names

import 'dart:developer';
import 'package:mynotepad/db/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mynotepad/models/Notes.dart';
import 'package:mynotepad/models/Users.dart';

class MongoDatabase {
  // ignore: prefer_typing_uninitialized_variables
  static var db, users, notes;
  static const jwt_secret = 'Youare@wesome';
  static String? token;
  static connect() async {
    db = await Db.create(mongoURI);
    await db.open();
    inspect(db);
    users = db.collection(usersCollection);
    notes = db.collection(notesCollection);
  }
}
