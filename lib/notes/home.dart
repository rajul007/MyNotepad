import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mynotepad/notes/display.dart';
import 'package:mynotepad/users/login.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DisplayNotes(),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("MyNotepad"),
      ),
      drawer: const NavigationDrawer(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      //       builder: (BuildContext context) {
      //         return Login();
      //       },
      //     ), (route) => false);
      //   },
      //   backgroundColor: Colors.green,
      //   child: const Icon(Icons.logout),
      // ),
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

  Widget buildHeader(BuildContext context) => Container(
        color: Colors.blue[700],
        padding: EdgeInsets.only(
            top: 20 + MediaQuery.of(context).padding.top, bottom: 20),
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
