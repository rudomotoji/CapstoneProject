import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/contract_inlist_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListContractRepository extends BaseApiClient {
  final http.Client httpClient;
  ListContractRepository({@required this.httpClient})
      : assert(httpClient != null);
  Future<List<ContractListDTO>> getListContract(int patientId) async {
    final String url = '/Contracts?patientId=${patientId}';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        List<ContractListDTO> list = responseData.map((dto) {
          return ContractListDTO(
              contractId: dto['contractId'],
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
}
