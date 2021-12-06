import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//
class SMSRepository extends BaseApiClient {
  final http.Client httpClient;
  SMSRepository({@required this.httpClient}) : assert(httpClient != null);
//
  Future<bool> sendSmsMessage(int pAId, int dAId) async {
    final String url =
        '/SMSMessages?doctorAccountId=${dAId}&patientAccountId=${pAId}';
    try {
      //
      final request = await postApi(url, null, null);
      if (request.statusCode == 204) {
        //
        print('Send SMS Successful!');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('ERROR AT SEND SMS MESSAGE ${e}');
    }
  }
}
