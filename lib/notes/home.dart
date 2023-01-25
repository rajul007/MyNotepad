import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mynotepad/db/mongodb.dart';
import 'package:mynotepad/notes/display.dart';
import 'package:mongo_dart/mongo_dart.dart' as md;
import 'package:mynotepad/notes/insert.dart';
import 'package:mynotepad/users/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    md.ObjectId user =
        ModalRoute.of(context)!.settings.arguments as md.ObjectId;
    MongoDatabase.token = user;
    return Scaffold(
      body: SafeArea(
        child: DisplayNotes(),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("MyNotepad"),
      ),
      drawer: const NavigationDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InsertNotes()))
              .then((value) {
            setState(() {});
          });
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
        color: Colors.blue[700],
        padding: EdgeInsets.only(
            top: 20 + MediaQuery.of(context).padding.top, bottom: 20),
        child: FutureBuilder(
          future: MongoDatabase.getUser(MongoDatabase.token),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      "${snapshot.data['name'][0].toUpperCase()}",
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${snapshot.data['name']}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${snapshot.data['email']}",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              );
            } else {
              // return buildEmptyHeader(context);
              return Container();
            }
          },
        ));
  }

  Widget buildEmptyHeader(BuildContext context) => Container(
        color: Colors.blue[700],
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue[100],
              child: Text(
                "U",
                style: TextStyle(fontSize: 40),
              ),
            ),
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) => Column(
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout", style: TextStyle(fontSize: 15)),
            onTap: () async {
              final storage = new FlutterSecureStorage();
              await storage.deleteAll();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (BuildContext context) {
                  return const Login();
                },
              ), (route) => false);
            },
          )
        ],
      );
}
