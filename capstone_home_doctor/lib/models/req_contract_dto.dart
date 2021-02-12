import 'package:flutter/material.dart';

class RequestContractDTO {
  int doctorId;
  int patientId;
  String dateStarted;
  int licenseId;
  List<String> diseaseIds;
  String note;

  RequestContractDTO(
      {this.doctorId,
      this.patientId,
      this.dateStarted,
      this.licenseId,
      this.diseaseIds,
      this.note});

  RequestContractDTO.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    patientId = json['patientId'];
    dateStarted = json['dateStarted'];
    licenseId = json['licenseId'];
    diseaseIds = json['diseaseIds'].cast<String>();
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorId'] = this.doctorId;
    data['patientId'] = this.patientId;
    data['dateStarted'] = this.dateStarted;
    data['licenseId'] = this.licenseId;
    data['diseaseIds'] = this.diseaseIds;
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
  );

  setProvider(
      {int doctorId,
      int patientId,
      String dateStarted,
      List<String> diseaseIds,
      int licenseId,
      String note}) async {
    this.dto.doctorId = doctorId;
    this.dto.patientId = patientId;
    this.dto.dateStarted = dateStarted;
    this.dto.diseaseIds = diseaseIds;
    this.dto.licenseId = licenseId;
    this.dto.note = note;
  }

  RequestContractDTO get getProvider => dto;
}
