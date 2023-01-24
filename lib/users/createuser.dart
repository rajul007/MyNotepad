import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mynotepad/db/mongodb.dart';
import 'package:mynotepad/users/login.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  var name = InputField();
  var email = InputField();
  var password = InputField();
  var confirmPassword = InputField();

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
    confirmPassword.field.addListener(() {
      setFieldState(confirmPassword);
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
                      controller: confirmPassword.field,
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
                                confirmPassword.fieldStatus
                            ? () => _createUser(
                                name.field.text,
                                email.field.text,
                                password.field.text,
                                confirmPassword.field.text)
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
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                          return const Login();
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

  void setFieldState(InputField input) {
    setState(() {
      input.fieldStatus = input.field.text.isNotEmpty;
    });
  }

  Future<void> _createUser(String name, String email, String password,
      String confirmPassword) async {
    var result =
        await MongoDatabase.createUser(name, email, password, confirmPassword);
    if (result == "Success") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) {
        return const Login();
      }), (route) => false);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account Created Successfully")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    }
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
