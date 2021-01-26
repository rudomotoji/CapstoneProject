import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RequestContractRepository extends BaseApiClient {
  final http.Client httpClient;
  //constructor
  RequestContractRepository({@required this.httpClient})
      : assert(httpClient != null);
  //
  Future<bool> makeRequestContract(RequestContractDTO dto) async {
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
