// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mynotepad/db/mongodb.dart';
import 'package:mongo_dart/mongo_dart.dart' as md;
import 'package:mynotepad/models/Notes.dart';
import 'package:mynotepad/notes/inputfields.dart';

class UpdateNote extends StatefulWidget {
  const UpdateNote({super.key});
  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  var title = TextEditingController();
  var tag = TextEditingController();
  var description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    NotesSchema data =
        ModalRoute.of(context)!.settings.arguments as NotesSchema;

    title.text = data.title;
    tag.text = data.tag;
    description.text = data.description;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _updateNote(data.id, title.text, description.text, tag.text);
              },
              icon: Icon(Icons.update))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                NoteInputFields(title, tag, description),
              ]),
        ),
      ),
    );
  }

  Future<void> _updateNote(
      md.ObjectId id, String title, String description, String tag) async {
    MongoDatabase.update(id, title, description, tag).whenComplete(() =>
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Note Updated Successfully"))));
  }
}
