import 'package:capstone_home_doctor/feature/register/sign_up.dart';
import 'package:capstone_home_doctor/feature/room_chat/room_chat.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignInScreen> {
  Future<QuerySnapshot> _futureSearch;
  SharedPreferences preferences;
  String name;

  @override
  void initState() {
    super.initState();
    // isSignIn();
  }

  Future<void> isSignIn() async {
    preferences = await SharedPreferences.getInstance();
    String name = preferences.getString("name");

    if (name != "" || !name.isEmpty) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RoomChatScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => name = value,
              decoration: InputDecoration(
                hintText: "Enter Your name...",
                border: const OutlineInputBorder(),
              ),
            ),
            MaterialButton(
              onPressed: () => {login(name)},
              minWidth: 200.0,
              height: 45.0,
              child: Text("login"),
            ),
            MaterialButton(
              onPressed: () => {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignUp()))
              },
              minWidth: 200.0,
              height: 45.0,
              child: Text("register"),
            ),
          ],
        )),
      ),
    );
  }

  Future<Null> login(String name) async {
    preferences = await SharedPreferences.getInstance();
    final QuerySnapshot resultQuery = await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: name)
        .get();
    final List<QueryDocumentSnapshot> documentSnapshot = resultQuery.docs;
    // if (documentSnapshot.length == 0) {
    //   FirebaseFirestore.instance
    //       .collection("users")
    //       .doc(Uuid().v4())
    //       .set({"name": name, "age": 1, "chattingWith": null});

    //   await preferences.setString("name", name);
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => RoomChatScreen()));
    // }
    // else {
    //   await preferences.setString("name", documentSnapshot[0]["name"]);
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => RoomChatScreen()));
    // }
    if (documentSnapshot.length != 0) {
      await preferences.setString("name", documentSnapshot[0]["name"]);
      await preferences.setString("id", documentSnapshot[0]["id"]);
      await preferences.setString("email", documentSnapshot[0]["email"]);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RoomChatScreen(
                    currentUser: documentSnapshot[0]["id"],
                  )));
    }
  }
}
