import 'package:flutter/material.dart';

// class RequestContractDTO {
//   int doctorId;
//   int patientId;
//   String dateStarted;
//   List<String> diseaseIds;
//   List<int> medicalInstructionIds;
//   String note;

//   RequestContractDTO(
//       {this.doctorId,
//       this.patientId,
//       this.dateStarted,
//       this.diseaseIds,
//       this.medicalInstructionIds,
//       this.note});

//   RequestContractDTO.fromJson(Map<String, dynamic> json) {
//     doctorId = json['doctorId'];
//     patientId = json['patientId'];
//     dateStarted = json['dateStarted'];
//     diseaseIds = json['diseaseIds'].cast<String>();
//     medicalInstructionIds = json['medicalInstructionIds'].cast<int>();
//     note = json['note'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['doctorId'] = this.doctorId;
//     data['patientId'] = this.patientId;
//     data['dateStarted'] = this.dateStarted;
//     data['diseaseIds'] = this.diseaseIds;
//     data['medicalInstructionIds'] = this.medicalInstructionIds;
//     data['note'] = this.note;
//     return data;
//   }

//   @override
//   String toString() {
//     // TODO: implement toString
//     return '';
//   }
// }

class RequestContractDTO {
  int doctorId;
  int patientId;
  String dateStarted;
  List<String> diseaseHealthRecordIds;
  List<DiseaseMedicalInstructions> diseaseMedicalInstructions;
  String note;

  RequestContractDTO(
      {this.doctorId,
      this.patientId,
      this.dateStarted,
      this.diseaseHealthRecordIds,
      this.diseaseMedicalInstructions,
      this.note});

  RequestContractDTO.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    patientId = json['patientId'];
    dateStarted = json['dateStarted'];
    diseaseHealthRecordIds = json['diseaseHealthRecordIds'].cast<String>();
    if (json['diseaseMedicalInstructions'] != null) {
      diseaseMedicalInstructions = new List<DiseaseMedicalInstructions>();
      json['diseaseMedicalInstructions'].forEach((v) {
        diseaseMedicalInstructions
            .add(new DiseaseMedicalInstructions.fromJson(v));
      });
    }
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorId'] = this.doctorId;
    data['patientId'] = this.patientId;
    data['dateStarted'] = this.dateStarted;
    data['diseaseHealthRecordIds'] = this.diseaseHealthRecordIds;
    if (this.diseaseMedicalInstructions != null) {
      data['diseaseMedicalInstructions'] =
          this.diseaseMedicalInstructions.map((v) => v.toJson()).toList();
    }
    data['note'] = this.note;
    return data;
  }
}

class DiseaseMedicalInstructions {
  String diseaseId;
  List<int> medicalInstructionIds;

  DiseaseMedicalInstructions({this.diseaseId, this.medicalInstructionIds});

  DiseaseMedicalInstructions.fromJson(Map<String, dynamic> json) {
    diseaseId = json['diseaseId'];
    medicalInstructionIds = json['medicalInstructionIds'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diseaseId'] = this.diseaseId;
    data['medicalInstructionIds'] = this.medicalInstructionIds;
    return data;
  }
}

class RequestContractDTOProvider extends ChangeNotifier {
  RequestContractDTO dto = new RequestContractDTO(
    patientId: 0,
    doctorId: 0,
    dateStarted: '',
    diseaseHealthRecordIds: [],
    diseaseMedicalInstructions: [],
    note: '',
  );

  setProvider({
    int patientId,
    int doctorId,
    String dateStarted,
    List<String> diseaseHealthRecordIds,
    List<DiseaseMedicalInstructions> diseaseMedicalInstructions,
    String note,
  }) async {
    this.dto.doctorId = doctorId;
    this.dto.patientId = patientId;
    this.dto.dateStarted = dateStarted;
    this.dto.diseaseHealthRecordIds = diseaseHealthRecordIds;
    this.dto.diseaseMedicalInstructions = diseaseMedicalInstructions;
    this.dto.note = note;
  }

  RequestContractDTO get getProvider => dto;
}
