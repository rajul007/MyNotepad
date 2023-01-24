// ignore_for_file: constant_identifier_names

import 'dart:developer';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:mynotepad/db/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mynotepad/models/Notes.dart';
import 'package:mynotepad/models/Users.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:validators/validators.dart';

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

  // static Future<String> createUser(UserSchema data) async {
  //   try {
  //     var result = await users.insertOne(data.toJson());
  //     if (result.isSuccess) {
  //       return "Data inserted Successfully";
  //     } else {
  //       return "Something went wrong";
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return e.toString();
  //   }
  // }
  static Future<String> createUser(String name, String email, String password,
      String confirmPassword) async {
    if (!isLength(name, 5)) {
      return "Name must atleast be 5 characters long";
    }
    if (!isEmail(email)) {
      return "Invalid Email";
    }
    if (!isLength(password, 5)) {
      return "Password must atleast be 5 characters long";
    }
    if (!equals(confirmPassword, password)) {
      return "Passwords does not match";
    }
    try {
      Map<String, dynamic>? user = await users.findOne({"email": email});
      if (user != null) {
        return "Sorry a user with the same email already exists";
      }

      var _id = ObjectId();
      var hashed_password =
          new DBCrypt().hashpw(password, new DBCrypt().gensaltWithRounds(10));

      final userData = UserSchema(
          id: _id,
          name: name,
          email: email,
          password: hashed_password,
          date: DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch,
              isUtc: true));

      var result = await users.insertOne(userData.toJson());
      if (result.isSuccess) {
        return "Success";
      } else {
        return "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    }
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
