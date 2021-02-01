import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/contract_inlist_dto.dart';
import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ContractRepository extends BaseApiClient {
  final http.Client httpClient;
  ContractRepository({@required this.httpClient}) : assert(httpClient != null);
  //
  Future<List<ContractListDTO>> getListContract(int patientId) async {
    final String url = '/Contracts?patientId=${patientId}';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        List<ContractListDTO> list = responseData.map((dto) {
          return ContractListDTO(
              contractId: dto['contractId'],
              contractCode: dto['contractCode'],
              fullNameDoctor: dto['fullNameDoctor'],
              daysOfTracking: dto['daysOfTracking'],
              status: dto['status'],
              dateCreated: dto['dateCreated'],
              dateStarted: dto['dateStarted'],
              dateFinished: dto['dateFinished']);
        }).toList();
        return list;
        // List<ContractListDTO> list =
      } else {
        return List<ContractListDTO>();
      }
    } catch (e) {
      print('ERROR AT GET LIST CONTRACT $e');
    }
  }

  Future<bool> createRequestContract(RequestContractDTO dto) async {
    // final String url = '/contracts';
    final String url = '/Contracts';
    try {
      final request = await postApi(url, null, dto.toJson());
      if (request.statusCode == 201) {
        return true;
      }
      if (request.statusCode == 400) {
        return false;
      }
      return false;
    } catch (e) {
      print('ERROR AT MAKE REQUEST CONTRACT API: $e');
    }
  }
}
