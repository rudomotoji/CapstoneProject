import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/models/user_dto.dart';
import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final UserDTO eachUser;
  final String newMess;
  UserItem(this.eachUser, this.newMess);
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
                subtitle: Text(newMess),
                isThreeLine: false,
              ),
            )
          ],
        ),
      ),
    );
  }

  sendUserToTabPage(BuildContext context) {
    Map<String, dynamic> param = {
      'receiveID': eachUser.id,
      'receiveName': eachUser.name
    };
    Navigator.pushNamed(context, RoutesHDr.CHAT, arguments: param);
  }
}
