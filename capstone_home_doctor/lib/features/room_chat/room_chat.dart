import 'package:capstone_home_doctor/features/chat/chat.dart';
import 'package:capstone_home_doctor/models/user_dto.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class RoomChatScreen extends StatefulWidget {
  final String currentUser;
  RoomChatScreen({this.currentUser});

  @override
  _State createState() => _State(currentUser: currentUser);
}

class _State extends State<RoomChatScreen> {
  final String currentUser;
  _State({this.currentUser});

  Future<QuerySnapshot> _futureSearch;
  // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController searchEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    // final SharedPreferences prefs = await _prefs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerPageHeader(),
      body: _futureSearch == null
          ? displayNoSearchScreen()
          : displayUserFoundScreen(),
    );
  }

  headerPageHeader() {
    return AppBar(
      automaticallyImplyLeading: true,
      actions: [
        IconButton(
            icon: Icon(Icons.settings, size: 30.0, color: Colors.white),
            onPressed: () {}),
      ],
      backgroundColor: Colors.blue,
      title: TextFormField(
        style: TextStyle(fontSize: 18, color: Colors.white),
        controller: searchEditingController,
        decoration: InputDecoration(
          hintText: 'Search hear...',
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          filled: true,
          prefixIcon: Icon(
            Icons.person_pin,
            color: Colors.white,
            size: 30,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: emptyTextFormField,
          ),
        ),
        onFieldSubmitted: controllSearch,
      ),
    );
  }

  emptyTextFormField() {
    searchEditingController.clear();
  }

  controllSearch(String strName) {
    Future<QuerySnapshot> allUserFound = FirebaseFirestore.instance
        .collection("users")
        .where("name", isGreaterThanOrEqualTo: "aaaa")
        .get();
    setState(() {
      _futureSearch = allUserFound;
    });
  }

  displayNoSearchScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Icon(Icons.group, color: Colors.lightBlueAccent, size: 200),
            Text(
              'search user',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 50,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  displayUserFoundScreen() {
    return FutureBuilder(
      future: _futureSearch,
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return CircularProgressIndicator();
        }
        List<UserResult> searchResult = [];
        dataSnapshot.data.documents.forEach((document) {
          UserDTO eachUser = UserDTO.fromDocument(document);
          UserResult userResult = UserResult(eachUser);
          if (currentUser != document['id']) {
            searchResult.add(userResult);
          }
        });
        return ListView(children: searchResult);
      },
    );
  }
}

class UserResult extends StatelessWidget {
  final UserDTO eachUser;
  UserResult(this.eachUser);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            GestureDetector(
              onTap: () => sendUserToTabPage(context),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.black),
                title: Text(
                  eachUser.name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  sendUserToTabPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(
                receiveID: eachUser.id, receiveName: eachUser.name)));
  }
}
