// ignore_for_file: constant_identifier_names

import 'dart:developer';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:mynotepad/db/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mynotepad/models/Notes.dart';
import 'package:mynotepad/models/Users.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  static Future<dynamic> login(String email, String password) async {
    try {
      Map<String, dynamic>? user = await users.findOne({"email": email});
      if (user == null) {
        return false;
      }
      var passwordCompare = await DBCrypt().checkpw(password, user["password"]);
      if (!passwordCompare) {
        return false;
      }

      final data = {"user": user["_id"]};
      final jwt = JWT(data);
      final authtoken = jwt.sign(SecretKey(jwt_secret));

      saveState(authtoken);
      return authtoken;
    } catch (e) {
      return "Something went wrong";
    }
  }

  static Future<void> saveState(String user) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: "user", value: user);
  }
}
