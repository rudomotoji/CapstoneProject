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
  List<String> diceaseIds;
  List<Diseases> diseases;
  String status;
  String contractStatus;

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
    this.status,
    this.contractStatus,
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
    if (json['diseases'] != null) {
      diseases = new List<Diseases>();
      json['diseases'].forEach((v) {
        diseases.add(new Diseases.fromJson(v));
      });
    }
    diceaseIds = json['diceaseIds'];
    place = json['place'];
    description = json['description'];
    dateCreated = json['dateCreated'];
    contractId = json['contractId'];
    status = json['status'];
    contractStatus = json['contractStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientId'] = this.patientId;
    data['personalHealthRecordId'] = this.personalHealthRecordId;
    if (this.diseases != null) {
      data['diseases'] = this.diseases.map((v) => v.toJson()).toList();
    }
    data['diceaseIds'] = this.diceaseIds;
    data['place'] = this.place;
    data['description'] = this.description;
    data['status'] = this.status;
    data['contractStatus'] = this.contractStatus;
    return data;
  }

  Map<String, dynamic> toJsonUpdate() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['place'] = this.place;
    data['description'] = this.description;
    data['diseases'] = this.diceaseIds;
    return data;
  }
}

class Diseases {
  String diseaseId;
  String diseaseName;

  Diseases({this.diseaseId, this.diseaseName});

  Diseases.fromJson(Map<String, dynamic> json) {
    diseaseId = json['diseaseId'];
    diseaseName = json['diseaseName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diseaseId'] = this.diseaseId;
    data['diseaseName'] = this.diseaseName;
    return data;
  }
}
