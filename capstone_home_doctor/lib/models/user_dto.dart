import 'package:cloud_firestore/cloud_firestore.dart';

class UserDTO {
  String id;
  String name;
  String image;
  UserDTO({this.id, this.name, this.image});
  factory UserDTO.fromDocument(DocumentSnapshot doc) {
    return UserDTO(
      id: doc['id'],
      name: doc['name'],
      image: doc['image'],
    );
  }
  factory UserDTO.fromJson(Map<String, dynamic> doc) {
    return UserDTO(
      id: doc['id'],
      name: doc['name'],
      image: doc['image'],
    );
  }
}
