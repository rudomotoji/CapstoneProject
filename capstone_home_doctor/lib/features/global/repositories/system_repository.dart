import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/features/register/register_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SystemRepository extends BaseApiClient {
  final http.Client httpClient;

  SystemRepository({@required this.httpClient}) : assert(httpClient != null);

  Future<String> getTimeSystem() async {
    final String url = 'http://45.76.186.233:8000/api/v1/Times';
    try {
      final response = await http.get(url, headers: {
        'accept': 'aplication/json',
      });
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return '';
      }
      // return true;
    } catch (e) {
      print('ERROR AT getAllMedicalToShare ${e.toString()}');
      return '';
    }
  }
}
