// class RequestContractDTO {
//   String doctorId;
//   String patientId;
//   String dateStarted;
//   String dateFinished;
//   String reason;

//   RequestContractDTO({
//     this.doctorId,
//     this.patientId,
//     this.dateStarted,
//     this.dateFinished,
//     this.reason,
//   });
//   RequestContractDTO.fromJson(Map<String, dynamic> json) {
//     doctorId = json['doctorId'];
//     patientId = json['patientId'];
//     dateStarted = json['dateStarted'];
//     dateFinished = json['dateFinished'];
//     reason = json['reason'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['doctorId'] = this.doctorId;
//     data['patientId'] = this.patientId;
//     data['dateStarted'] = this.dateStarted;
//     data['dateFinished'] = this.dateFinished;
//     data['reason'] = this.reason;
//     return data;
//   }
// }

import 'package:flutter/material.dart';

class RequestContractDTOProvider extends ChangeNotifier {
  RequestContractDTO dto = new RequestContractDTO(
      patientId: '0',
      fullName: '',
      phoneNumber: '',
      contractCode: '',
      dateCreated: '',
      reason: '',
      status: '');
  final TextEditingController _reasonController = TextEditingController();
  TextEditingController get reasonController => _reasonController;
  //
  setProvider(
      {String patientId,
      String fullName,
      String phoneNumber,
      String contractCode,
      String status,
      String dateCreated}) async {
    this.dto.patientId = patientId;
    this.dto.fullName = fullName;
    this.dto.phoneNumber = phoneNumber;
    this.dto.contractCode = contractCode;
    this.dto.reason = _reasonController.text;
    this.dto.status = status;
    this.dto.dateCreated = dateCreated;
  }

  RequestContractDTO get getProvider => dto;
}

class RequestContractDTO extends ChangeNotifier {
  String patientId;
  String fullName;
  String phoneNumber;
  String contractCode;
  String reason;
  String status;
  String dateCreated;

  RequestContractDTO({
    this.patientId,
    this.fullName,
    this.phoneNumber,
    this.contractCode,
    this.reason,
    this.status,
    this.dateCreated,
  });
  RequestContractDTO.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'];
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    contractCode = json['contractCode'];
    reason = json['reason'];
    status = json['status'];
    dateCreated = json['dateCreated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientId'] = this.patientId;
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    data['contractCode'] = this.contractCode;
    data['reason'] = this.reason;
    data['status'] = this.status;
    data['dateCreated'] = this.dateCreated;
    return data;
  }
}
