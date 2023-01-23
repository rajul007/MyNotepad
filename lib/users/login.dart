import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:mynotepad/db/mongodb.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mongo_dart/mongo_dart.dart' as md;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email = TextEditingController();
  var password = TextEditingController();
  final jwt_secret = 'Youare@wesome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: LayoutBuilder(
          builder: (context, constraints) => ListView(
            scrollDirection: Axis.vertical,
            children: [
              Container(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: email,
                      decoration: InputDecoration(
                        labelText: "Email Address",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _loginUser(email.text, password.text);
                        },
                        child: Text("Login"))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginUser(String email, String password) async {
    var result = await MongoDatabase.login(email, password);
    var user;
    print(result);

    if (result == false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please try to login with correct credentials")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Logged In Successfully")));
    }

    dynamic verifyToken(String token) {
      final jwt = JWT.verify(token, SecretKey(jwt_secret));
      return md.ObjectId.fromHexString(jwt.payload['user']);
    }
  }
}
