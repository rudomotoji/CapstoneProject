import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/account_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class AccountRepository extends BaseApiClient {
  final http.Client httpClient;
  AccountRepository({@required this.httpClient}) : assert(httpClient != null);

  //
  Future<int> checkLogin(AccountDTO dto) async {
    final url = '/Accounts/Login';
    try {
      final request = await postApi(url, null, dto.toJson());
      if (request.statusCode == 200) {
        //
        String a = request.body;
        Map<String, dynamic> decodedToken = JwtDecoder.decode(a);
        return int.tryParse(decodedToken["patientId"]);
      } else {
        return null;
      }
    } catch (e) {
      print('ERROR AT CHECK LOGIN ${e}');
    }
  }
}
