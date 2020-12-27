import 'package:cloud_firestore/cloud_firestore.dart';

class UserDTO {
  String id;
  String name;
  String email;
  String password;
  String role;
  String phoneNo;
  UserDTO(
      {this.phoneNo, this.id, this.name, this.email, this.password, this.role});
  factory UserDTO.fromDocument(DocumentSnapshot doc) {
    return UserDTO(
      id: doc['id'],
      name: doc['name'],
      email: doc['email'],
    );
  }
}
