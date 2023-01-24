import 'package:flutter/material.dart';
import 'package:mynotepad/db/mongodb.dart';
import 'package:mynotepad/models/Notes.dart';
import 'package:mongo_dart/mongo_dart.dart' as md;

class DisplayNotes extends StatefulWidget {
  const DisplayNotes({super.key});

  @override
  State<DisplayNotes> createState() => _DisplayNotesState();
}

class _DisplayNotesState extends State<DisplayNotes> {
  @override
  Widget build(BuildContext context) {
    md.ObjectId user =
        ModalRoute.of(context)!.settings.arguments as md.ObjectId;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FutureBuilder(
            future: MongoDatabase.getNotes(user),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Transform.scale(
                    scale: 1.5,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasData && snapshot.data.isEmpty) {
                return Center(
                    child: Text(
                  "Add a Note",
                  style: TextStyle(color: Colors.black26, fontSize: 30),
                ));
              } else if (snapshot.hasData) {
                var total_data = snapshot.data.length;
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return displayCard(
                          NotesSchema.fromJson(snapshot.data[index]));
                    });
              } else {
                return Center(
                  child: Text(
                    "Data Unavailable",
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget displayCard(NotesSchema data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${data.title}"),
            SizedBox(
              height: 5,
            ),
            Text("${data.tag}"),
            SizedBox(
              height: 5,
            ),
            Text("${data.description}"),
          ],
        ),
      ),
    );
  }
}
