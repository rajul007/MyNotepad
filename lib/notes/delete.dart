import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as md;
import 'package:mynotepad/db/mongodb.dart';

Future<void> deleteNote(BuildContext context, md.ObjectId id) async {
  await MongoDatabase.delete(id).whenComplete(() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Note Deleted Successfully")));
  });
}
