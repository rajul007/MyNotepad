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
import 'package:mynotepad/db/constant.dart';

class MongoDatabase {
  // ignore: prefer_typing_uninitialized_variables
  static var db, users, notes;
  static var token;
  static connect() async {
    db = await Db.create(mongoURI);
    await db.open();
    inspect(db);
    users = db.collection(usersCollection);
    notes = db.collection(notesCollection);
  }

  static Future<String> insertNote(
      ObjectId user, String title, String description, String tag) async {
    if (!isLength(title, 3)) {
      return "Title must atleast be 3 characters long";
    }
    if (!isLength(description, 5)) {
      return "Description must atleast be 5 characters long";
    }

    try {
      var _id = ObjectId();
      final data = NotesSchema(
          id: _id,
          user: user,
          title: title,
          tag: tag == "" ? "General" : tag,
          description: description,
          date: DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch,
              isUtc: true));
      var result = await notes.insertOne(data.toJson());
      if (result.isSuccess) {
        return "Success";
      } else {
        return "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future<List<Map<String, dynamic>>> getNotes(ObjectId user) async {
    final userNotes = await notes.find({'user': user}).toList();
    return userNotes;
  }

  static Future<void> update(
      ObjectId id, String title, String description, String tag) async {
    try {
      var note = await notes.findOne({"_id": id});
      note['title'] = title;
      note['tag'] = tag;
      note['description'] = description;

      await notes.save(note);
    } catch (e) {}
  }

  static Future<void> delete(ObjectId id) async {
    try {
      await notes.remove(where.id(id));
    } catch (e) {}
  }

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
      var hashedPassword =
          new DBCrypt().hashpw(password, DBCrypt().gensaltWithRounds(10));

      final userData = UserSchema(
          id: _id,
          name: name,
          email: email,
          password: hashedPassword,
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

  static Future<Map<String, dynamic>> getUser(ObjectId id) async {
    var user = await users.findOne({"_id": id});
    Map<String, dynamic> userDetails = {
      "name": user["name"],
      "email": user["email"]
    };
    return userDetails;
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
    const storage = FlutterSecureStorage();
    await storage.write(key: "user", value: user);
  }

  static Future<String?> getState() async {
    const storage = FlutterSecureStorage();
    String? user = await storage.read(key: "user");
    return user;
  }
}
