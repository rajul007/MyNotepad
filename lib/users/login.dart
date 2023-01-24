import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mynotepad/db/mongodb.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mongo_dart/mongo_dart.dart' as md;
import 'package:mynotepad/users/createuser.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email = TextEditingController();
  var password = TextEditingController();
  bool isEmail = false; // To check if email field is empty
  bool isPass = false; // To check if password field is empty
  final jwt_secret = 'Youare@wesome';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email.addListener(() {
      setState(() {
        isEmail = email.text.isNotEmpty;
      });
    });

    password.addListener(() {
      setState(() {
        isPass = password.text.isNotEmpty;
      });
    });
  }

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
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: isEmail && isPass
                            ? () => _loginUser(email.text, password.text)
                            : null,
                        child: Text("Login")),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(color: Colors.black26),
                      )),
                    ),
                    Padding(
                        padding: EdgeInsets.all(15),
                        child: Text.rich(TextSpan(
                            text: "Don't have an account? ",
                            children: <InlineSpan>[
                              TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                          return const CreateUser();
                                        }), (route) => false))
                            ])))
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
