import 'package:capstone_home_doctor/commons/http/contract_api.dart';
import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:flutter/material.dart';

class RequestContractProvider with ChangeNotifier {
  RequestContractDTO dto;
  ContractAPI contractAPI;

  setMethod({
    RequestContractDTO requestContractDTO,
  }) {
    this.dto = requestContractDTO;
  }

  Future<bool> initial({RequestContractDTO requestContractDTO}) async {
    this.dto = requestContractDTO;
    _makeRequestContract(dto);
    return true;
  }

  _makeRequestContract(dto) {
    Map<String, String> dtoToJson = toJson(dto);
    contractAPI.makeRequestAPI(dtoToJson);
  }

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
