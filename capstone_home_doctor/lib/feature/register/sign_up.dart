import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();
  String name;
  String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(children: [
              Column(children: [
                Text('Name:'),
                TextFormField(
                  controller: usernameEditingController,
                  onChanged: (value) => name = value,
                  validator: (val) {
                    return val.isEmpty || val.length < 3
                        ? "Enter Username 3+ characters"
                        : null;
                  },
                ),
              ]),
              Column(children: [
                Text('Email:'),
                TextFormField(
                  controller: emailEditingController,
                  onChanged: (value) => email = value,
                  validator: (val) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val)
                        ? null
                        : "Enter correct email";
                  },
                ),
              ]),
              MaterialButton(
                onPressed: () => {signup(name, email)},
                minWidth: 200.0,
                height: 45.0,
                child: Text("register"),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<Null> signup(String name, String email) async {
    final String id = Uuid().v4();
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set({"id": id, "name": name, "email": email, "chattingWith": null});
  }
}
