import 'package:flutter/material.dart';

//TEST MOCKUP CLASSES
// class RequestContractDTOProvider extends ChangeNotifier {
//   RequestContractDTO dto = new RequestContractDTO(
//       patientId: '0',
//       fullName: '',
//       phoneNumber: '',
//       contractCode: '',
//       dateCreated: '',
//       reason: '',
//       status: '');
//   final TextEditingController _reasonController = TextEditingController();
//   TextEditingController get reasonController => _reasonController;
//   //
//   setProvider(
//       {String patientId,
//       String fullName,
//       String phoneNumber,
//       String contractCode,
//       String status,
//       String dateCreated}) async {
//     this.dto.patientId = patientId;
//     this.dto.fullName = fullName;
//     this.dto.phoneNumber = phoneNumber;
//     this.dto.contractCode = contractCode;
//     this.dto.reason = _reasonController.text;
//     this.dto.status = status;
//     this.dto.dateCreated = dateCreated;
//   }

//   RequestContractDTO get getProvider => dto;
// }

// class RequestContractDTO extends ChangeNotifier {
//   String patientId;
//   String fullName;
//   String phoneNumber;
//   String contractCode;
//   String reason;
//   String status;
//   String dateCreated;

//   RequestContractDTO({
//     this.patientId,
//     this.fullName,
//     this.phoneNumber,
//     this.contractCode,
//     this.reason,
//     this.status,
//     this.dateCreated,
//   });
//   RequestContractDTO.fromJson(Map<String, dynamic> json) {
//     patientId = json['patientId'];
//     fullName = json['fullName'];
//     phoneNumber = json['phoneNumber'];
//     contractCode = json['contractCode'];
//     reason = json['reason'];
//     status = json['status'];
//     dateCreated = json['dateCreated'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['patientId'] = this.patientId;
//     data['fullName'] = this.fullName;
//     data['phoneNumber'] = this.phoneNumber;
//     data['contractCode'] = this.contractCode;
//     data['reason'] = this.reason;
//     data['status'] = this.status;
//     data['dateCreated'] = this.dateCreated;
//     return data;
//   }
// }
//
//REAL OBJECT API
class RequestContractDTO {
  int doctorId;
  int patientId;
  String dateStarted;
  int dayOfTracking;
  String reason;

  RequestContractDTO({
    this.doctorId,
    this.patientId,
    this.dateStarted,
    this.dayOfTracking,
    this.reason,
  });
  RequestContractDTO.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    patientId = json['patientId'];
    dateStarted = json['dateStarted'];
    dayOfTracking = json['dayOfTracking'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorId'] = this.doctorId;
    data['patientId'] = this.patientId;
    data['dateStarted'] = this.dateStarted;
    data['dayOfTracking'] = this.dayOfTracking;
    data['reason'] = this.reason;
    return data;
  }
}

class RequestContractDTOProvider extends ChangeNotifier {
  RequestContractDTO dto = new RequestContractDTO(
    doctorId: 0,
    patientId: 0,
    dateStarted: '',
    dayOfTracking: 0,
    reason: '',
  );

  setProvider(
      {int doctorId,
      int patientId,
      String dateStarted,
      int dayOfTracking,
      String reason}) async {
    this.dto.doctorId = doctorId;
    this.dto.patientId = patientId;
    this.dto.dateStarted = dateStarted;
    this.dto.dayOfTracking = dayOfTracking;
    this.dto.reason = reason;
  }

  RequestContractDTO get getProvider => dto;
}
