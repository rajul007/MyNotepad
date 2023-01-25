// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mynotepad/db/mongodb.dart';
import 'package:mongo_dart/mongo_dart.dart' as md;

class InsertNotes extends StatefulWidget {
  const InsertNotes({super.key});
  @override
  State<InsertNotes> createState() => _InsertNotesState();
}

class _InsertNotesState extends State<InsertNotes> {
  var title = TextEditingController();
  var tag = TextEditingController();
  var description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                TextField(
                  controller: title,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: tag,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(labelText: "Tag"),
                ),
                TextField(
                  controller: description,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(labelText: "Description"),
                ),
                ElevatedButton(
                    onPressed: () {
                      _insertNote(MongoDatabase.token, title.text,
                          description.text, tag.text);
                    },
                    child: Text("Add Note"))
              ]),
        ),
      ),
    );
  }

  Future<void> _insertNote(
      md.ObjectId user, String title, String description, String tag) async {
    var result = await MongoDatabase.insertNote(user, title, description, tag);
    if (result == "Success") {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Note Added Successfully")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    }
  }
}
