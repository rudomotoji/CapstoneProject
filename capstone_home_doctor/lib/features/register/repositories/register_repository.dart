import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/features/register/register_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterRepository extends BaseApiClient {
  final http.Client httpClient;
  RegisterRepository({@required this.httpClient}) : assert(httpClient != null);

  Future<bool> registerAccPatient(FormRegisterDTO formRegisterDTO) async {
    final String url = '/Accounts/PatientRegister';
    try {
      final response = await postApi(url, '', formRegisterDTO.toJson());
      print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
      // return true;
    } catch (e) {
      print('ERROR AT getAllMedicalToShare ${e.toString()}');
      return false;
    }
  }
}
