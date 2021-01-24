import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/message/user_item.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capstone_home_doctor/models/user_dto.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<MessagePage> {
  String currentUser = '153176a9-877a-45ed-bb90-191535b8c820';
  List<UserItem> searchResult = [];
  List<UserDTO> searchResultDTO = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          HeaderWidget(
            title: 'Tin nhắn',
            isMainView: true,
            buttonHeaderType: ButtonHeaderType.AVATAR,
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  searchResult = [];
                  searchResultDTO = [];
                  snapshot.data.docs.forEach(
                    (DocumentSnapshot document) => {
                      document.data().forEach((key, value) {
                        UserDTO user = UserDTO.fromJson(value);
                        if (!searchResultDTO.contains(user) &&
                            currentUser != user.id) {
                          UserItem userResult = UserItem(user, '123');
                          searchResult.add(userResult);
                          searchResultDTO.add(user);
                        }
                      }),
                    },
                  );
                  if (searchResult.length > 0) {
                    return ListView(children: searchResult);
                  } else {
                    return Container();
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // getUserInfo(String id, String newMess) async {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(id)
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) async {
  //     if (documentSnapshot.exists) {
  //       UserDTO eachUser = UserDTO.fromDocument(documentSnapshot);
  //       if (!searchResultDTO.contains(eachUser)) {
  //         UserItem userResult = UserItem(eachUser, newMess);
  //         searchResultDTO.add(eachUser);
  //         searchResult.add(userResult);
  //       }
  //     }
  //   });
  // }
}
