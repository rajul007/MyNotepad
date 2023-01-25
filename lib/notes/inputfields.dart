import 'package:flutter/material.dart';

Widget NoteInputFields(TextEditingController title, TextEditingController tag,
    TextEditingController description) {
  return Column(
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
          decoration: InputDecoration(labelText: "Description")),
    ],
  );
}
