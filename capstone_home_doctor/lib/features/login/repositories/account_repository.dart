import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/account_dto.dart';
import 'package:capstone_home_doctor/models/account_token_dto.dart';
import 'package:capstone_home_doctor/models/token_device_dto.dart';
import 'package:capstone_home_doctor/services/token_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class AccountRepository extends BaseApiClient {
  final http.Client httpClient;
  final TokenHelper _tokenHelper = TokenHelper();
  AccountRepository({@required this.httpClient}) : assert(httpClient != null);

  //
  Future<AccountTokenDTO> checkLogin(AccountDTO dto) async {
    final url = '/Accounts/Login';
    try {
      final request = await postApi(url, null, dto.toJson());
      if (request.statusCode == 200) {
        //
        String response = request.body;
        await _tokenHelper.setToken(response);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(response);
        //return int.tryParse(decodedToken["patientId"]);
        return AccountTokenDTO.fromJson(decodedToken);
      } else {
        return null;
      }
    } catch (e) {
      print('ERROR AT CHECK LOGIN ${e}');
    }
  }

  //
  Future<bool> sendTokenDevice(TokenDeviceDTO dto) async {
    // final url = '/FireBases';
    // try {
    //   final request = await postApi(url, null, dto.toJson());
    //   print('request body send device ${request.body}');
    //   if (request.statusCode == 201) {
    //     return true;
    //   } else {
    //     return false;
    //   }
    // } catch (e) {
    //   print('ERROR AT SEND TOKEN DEVICE ${e}');
    // }

    var uri = Uri.parse('http://45.76.186.233:8000/api/v1/FireBases');
    var request = new http.MultipartRequest('POST', uri);
    request.fields['accountId'] = '${dto.accountId}';
    request.fields['token'] = '${dto.tokenDevice}';
    final response = await request.send();
    print('send token device ${response.statusCode}');
    if (response.statusCode == 201) return true;
    return false;
  }
}
