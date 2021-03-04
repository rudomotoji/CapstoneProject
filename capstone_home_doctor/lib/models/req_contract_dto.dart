import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:flutter/material.dart';

class RequestContractDTO {
  int doctorId;
  int patientId;
  String dateStarted;
  int licenseId;
  List<String> diseaseIds;
  List<int> medicalInstructionIds = [];
  String note;

  RequestContractDTO(
      {this.doctorId,
      this.patientId,
      this.dateStarted,
      this.licenseId,
      this.diseaseIds,
      this.medicalInstructionIds,
      this.note});

  RequestContractDTO.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    patientId = json['patientId'];
    dateStarted = json['dateStarted'];
    licenseId = json['licenseId'];
    diseaseIds = json['diseaseIds'].cast<String>();
    medicalInstructionIds = json['medicalInstructionIds'].cast<int>();
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorId'] = this.doctorId;
    data['patientId'] = this.patientId;
    data['dateStarted'] = this.dateStarted;
    data['licenseId'] = this.licenseId;
    data['diseaseIds'] = this.diseaseIds;
    data['medicalInstructionIds'] = this.medicalInstructionIds;
    data['note'] = this.note;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return '${doctorId} - ${diseaseIds}';
  }
}

class RequestContractDTOProvider extends ChangeNotifier {
  RequestContractDTO dto = new RequestContractDTO(
    doctorId: 0,
    patientId: 0,
    dateStarted: '',
    diseaseIds: [],
    licenseId: 0,
    note: '',
    medicalInstructionIds: [],
  );

  setProvider(
      {int doctorId,
      int patientId,
      String dateStarted,
      List<String> diseaseIds,
      List<int> medicalInstructionIds,
      int licenseId,
      String note,
      List<MedicalInstructions> listMedInsChecked}) async {
    this.dto.doctorId = doctorId;
    this.dto.patientId = patientId;
    this.dto.dateStarted = dateStarted;
    this.dto.diseaseIds = diseaseIds;
    this.dto.licenseId = licenseId;
    this.dto.note = note;
    this.dto.medicalInstructionIds = medicalInstructionIds;
  }

  RequestContractDTO get getProvider => dto;
}
