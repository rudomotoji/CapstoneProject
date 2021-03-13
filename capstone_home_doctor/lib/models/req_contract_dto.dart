import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:flutter/material.dart';

class RequestContractDTO {
  int doctorId;
  int patientId;
  String dateStarted;
  int licenseId;
  List<Diseases> diseases;
  String note;

  RequestContractDTO(
      {this.doctorId,
      this.patientId,
      this.dateStarted,
      this.licenseId,
      this.diseases,
      this.note});

  RequestContractDTO.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    patientId = json['patientId'];
    dateStarted = json['dateStarted'];
    licenseId = json['licenseId'];
    if (json['diseases'] != null) {
      diseases = new List<Diseases>();
      json['diseases'].forEach((v) {
        diseases.add(new Diseases.fromJson(v));
      });
    }
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorId'] = this.doctorId;
    data['patientId'] = this.patientId;
    data['dateStarted'] = this.dateStarted;
    data['licenseId'] = this.licenseId;
    if (this.diseases != null) {
      data['diseases'] = this.diseases.map((v) => v.toJson()).toList();
    }
    data['note'] = this.note;
    return data;
  }
}

class Diseases {
  String diseaseId;
  List<int> medicalInstructionIds;

  Diseases({this.diseaseId, this.medicalInstructionIds});

  Diseases.fromJson(Map<String, dynamic> json) {
    diseaseId = json['diseaseId'];
    medicalInstructionIds = json['medicalInstructionIds'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diseaseId'] = this.diseaseId;
    data['medicalInstructionIds'] = this.medicalInstructionIds;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'diseaseId: $diseaseId \nmedicalInstructionIds: ${medicalInstructionIds}\n';
  }
}

class RequestContractDTOProvider extends ChangeNotifier {
  RequestContractDTO dto = new RequestContractDTO(
    patientId: 0,
    doctorId: 0,
    dateStarted: '',
    licenseId: 0,
    diseases: [],
    note: '',
  );

  setProvider({
    int doctorId,
    int patientId,
    String dateStarted,
    int licenseId,
    List<Diseases> diseases,
    String note,
  }) async {
    this.dto.doctorId = doctorId;
    this.dto.patientId = patientId;
    this.dto.dateStarted = dateStarted;
    this.dto.licenseId = licenseId;
    this.dto.diseases = diseases;
    this.dto.note = note;
  }

  RequestContractDTO get getProvider => dto;
}

// class RequestContractDTOProvider extends ChangeNotifier {
//   RequestContractDTO dto = new RequestContractDTO(
//     doctorId: 0,
//     patientId: 0,
//     dateStarted: '',
//     diseaseIds: [],
//     licenseId: 0,
//     note: '',
//     medicalInstructionIds: [],
//   );

//   setProvider(
//       {int doctorId,
//       int patientId,
//       String dateStarted,
//       List<String> diseaseIds,
//       List<int> medicalInstructionIds,
//       int licenseId,
//       String note,
//       List<MedicalInstructions> listMedInsChecked}) async {
//     this.dto.doctorId = doctorId;
//     this.dto.patientId = patientId;
//     this.dto.dateStarted = dateStarted;
//     this.dto.diseaseIds = diseaseIds;
//     this.dto.licenseId = licenseId;
//     this.dto.note = note;
//     this.dto.medicalInstructionIds = medicalInstructionIds;
//   }

//   RequestContractDTO get getProvider => dto;
// }
