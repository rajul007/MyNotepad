import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as md;
import 'package:mynotepad/db/mongodb.dart';
import 'package:mynotepad/models/Users.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  var name = InputField();
  var email = InputField();
  var password = InputField();
  var confirm_password = InputField();

  @override
  void initState() {
    super.initState();
    name.field.addListener(() {
      setFieldState(name);
    });

    email.field.addListener(() {
      setFieldState(email);
    });
    password.field.addListener(() {
      setFieldState(password);
    });
    confirm_password.field.addListener(() {
      setFieldState(confirm_password);
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
                      controller: name.field,
                      decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: email.field,
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
                      controller: password.field,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: confirm_password.field,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: name.fieldStatus &&
                                email.fieldStatus &&
                                password.fieldStatus &&
                                confirm_password.fieldStatus
                            ? () => _createUser(
                                name.field.text,
                                email.field.text,
                                password.field.text,
                                confirm_password.field.text)
                            : null,
                        child: Text("Sign Up")),
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
                            text: "Already have an account? ",
                            children: <InlineSpan>[
                              TextSpan(
                                  text: "Log In",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold))
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

  void setFieldState(InputField input) {
    setState(() {
      input.fieldStatus = input.field.text.isNotEmpty;
    });
  }

  Future<void> _createUser(String name, String email, String password,
      String confirm_password) async {
    if (confirm_password != password) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Password does not match with Confirm field")));
      return;
    }
    var _id = md.ObjectId();
    var hashed_password =
        new DBCrypt().hashpw(password, new DBCrypt().gensaltWithRounds(10));

    final data = UserSchema(
        id: _id,
        name: name,
        email: email,
        password: hashed_password,
        date: DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch,
            isUtc: true));

    var result = await MongoDatabase.createUser(data);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Successfully Signed In ${_id}")));
  }
}

class InputField {
  var field;
  var fieldStatus;

  InputField() {
    field = TextEditingController();
    fieldStatus = false;
  }
}
