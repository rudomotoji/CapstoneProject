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
    final String url = '/contracts';
    try {
      final request = await postApi(url, null, dto.toJson());
      if (request.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('ERROR AT MAKE REQUEST CONTRACT API: $e');
    }
  }
}
