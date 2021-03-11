import 'package:capstone_home_doctor/models/disease_dto.dart';

class HealthRecordDTO {
  int healthRecordId;
  // String disease;
  String place;
  // String doctorName;
  String description;
  //to get owner
  int personalHealthRecordId;
  String dateCreated;
  //for currency health record.
  int contractId;
  //patient Id
  int patientId;
  //list diseaseId to insert
  List<int> diceaseIds;
  //list diseases to get
  List<dynamic> diseases;

  //constructor
  HealthRecordDTO({
    this.healthRecordId,
    this.place,
    this.description,
    this.diseases,
    this.diceaseIds,
    this.personalHealthRecordId,
    this.dateCreated,
    this.contractId,
    this.patientId,
  });

  // Map<String, dynamic> toMapSqflite() {
  //   var map = <String, dynamic>{
  //     'health_record_id': healthRecordId,
  //     'diseases': diseases,
  //     'diceaseIds': diceaseIds,
  //     'place': place,
  //     'description': description,
  //     'personal_health_record_id': personalHealthRecordId,
  //     'date_create': dateCreated,
  //     'contract_id': contractId,
  //   };
  //   return map;
  // }

  // HealthRecordDTO.fromMapSqflite(Map<String, dynamic> map) {
  //   healthRecordId = map['health_record_id'];
  //   diseases = map['diseases'];
  //   diceaseIds = map['diceaseIds'];
  //   place = map['place'];
  //   description = map['description'];
  //   personalHealthRecordId = map['personal_health_record_id'];
  //   dateCreated = map['date_create'];
  //   contractId = map['contract_id'];
  // }

  HealthRecordDTO.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'];
    healthRecordId = json['healthRecordId'];
    diseases = json['diseases'];
    diceaseIds = json['diceaseIds'];
    place = json['place'];
    description = json['description'];
    dateCreated = json['dateCreated'];
    contractId = json['contractId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientId'] = this.patientId;
    data['personalHealthRecordId'] = this.personalHealthRecordId;
    data['diseases'] = this.diseases;
    data['diceaseIds'] = this.diceaseIds;
    data['place'] = this.place;
    data['description'] = this.description;
    return data;
  }
}
