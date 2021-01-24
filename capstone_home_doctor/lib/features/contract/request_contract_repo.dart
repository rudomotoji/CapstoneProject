import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:flutter/material.dart';

class RequestContractProvider with ChangeNotifier {
  RequestContractDTO dto;

  setMethod({
    RequestContractDTO requestContractDTO,
  }) {
    this.dto = requestContractDTO;
  }

  Future<bool> initial({RequestContractDTO requestContractDTO}) async {
    this.dto = requestContractDTO;
    _makeRequestContract();
    return true;
  }

  _makeRequestContract() {}

  Map<String, String> toJson(dto) {
    final Map<String, String> data = new Map<String, String>();
    data['doctorId'] = this.dto.doctorId.toString();
    data['patientId'] = this.dto.patientId.toString();
    data['dateStarted'] = this.dto.dateStarted.toString();
    data['dateEnded'] = this.dto.dateFinished.toString();
    data['reason'] = this.dto.reason.toString();
    return data;
  }
}
