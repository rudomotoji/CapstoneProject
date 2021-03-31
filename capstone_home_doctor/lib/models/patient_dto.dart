import 'package:capstone_home_doctor/models/relative_dto.dart';

class PatientDTO {
  int patientId;
  String fullName;
  String gender;
  String phoneNumber;
  String email;
  String address;
  String dateOfBirth;
  String career;
  int height;
  int weight;
  String dateStarted;
  String dateFinished;
  List<RelativeDTO> relatives;
  PatientHealthRecordDTO patientHealthRecord;

  PatientDTO(
      {this.patientId,
      this.fullName,
      this.gender,
      this.phoneNumber,
      this.email,
      this.address,
      this.dateOfBirth,
      this.career,
      this.height,
      this.weight,
      this.dateStarted,
      this.dateFinished,
      this.relatives,
      this.patientHealthRecord});

  PatientDTO.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'];
    fullName = json['fullName'];
    gender = json['gender'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    address = json['address'];
    dateOfBirth = json['dateOfBirth'];
    career = json['career'];
    height = json['height'];
    weight = json['weight'];
    dateStarted = json['dateStarted'];
    dateFinished = json['dateFinished'];
    if (json['relatives'] != null) {
      relatives = new List<RelativeDTO>();
      json['relatives'].forEach((v) {
        relatives.add(new RelativeDTO.fromJson(v));
      });
    }
    patientHealthRecord = json['patientHealthRecord'] != null
        ? new PatientHealthRecordDTO.fromJson(json['patientHealthRecord'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientId'] = this.patientId;
    data['fullName'] = this.fullName;
    data['gender'] = this.gender;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['address'] = this.address;
    data['dateOfBirth'] = this.dateOfBirth;
    data['career'] = this.career;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['dateStarted'] = this.dateStarted;
    data['dateFinished'] = this.dateFinished;
    if (this.relatives != null) {
      data['relatives'] = this.relatives.map((v) => v.toJson()).toList();
    }
    if (this.patientHealthRecord != null) {
      data['patientHealthRecord'] = this.patientHealthRecord.toJson();
    }
    return data;
  }
}

class PatientHealthRecordDTO {
  int height;
  int weight;
  String personalMedicalHistory;
  String familyMedicalHistory;
  List<RelativeDTO> relatives;

  PatientHealthRecordDTO(
      {this.height,
      this.weight,
      this.personalMedicalHistory,
      this.familyMedicalHistory,
      this.relatives});

  PatientHealthRecordDTO.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    weight = json['weight'];
    personalMedicalHistory = json['personalMedicalHistory'];
    familyMedicalHistory = json['familyMedicalHistory'];
    if (json['relatives'] != null) {
      relatives = new List<RelativeDTO>();
      json['relatives'].forEach((v) {
        relatives.add(new RelativeDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['personalMedicalHistory'] = this.personalMedicalHistory;
    data['familyMedicalHistory'] = this.familyMedicalHistory;
    if (this.relatives != null) {
      data['relatives'] = this.relatives.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
